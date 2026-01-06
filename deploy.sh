#!/bin/bash

# Author: Julio Prata
# Version: 1.4
# Description: Script de deploy corrigido para estrutura com subpasta /lec e saída em /docs

# Cores para feedback visual
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem cor

# Pega o nome do projeto (ex: lar-espirita-cristao)
PROJECT_NAME=$(basename "$PWD")

echo -e "${CYAN}--- Iniciando Deploy para: $PROJECT_NAME ---${NC}"

# Define a mensagem de commit (Usa o argumento $1 ou a data atual)
msg="Update $(date +'%d/%m/%Y %H:%M')"
if [ $# -eq 1 ]; then
  msg="$1"
fi

# 1. ENTRAR NA PASTA DO PROJETO HUGO
if [ -d "lec" ]; then
    cd lec
else
    echo -e "${RED}--> ERRO: Pasta /lec não encontrada. Execute o script na raiz do repositório.${NC}"
    exit 1
fi

# 2. VERIFICAÇÃO DE AMBIENTE HUGO E BUILD
if [ -f "hugo.toml" ] || [ -f "config.toml" ]; then
    echo -e "${GREEN}--> Projeto Hugo detectado. Iniciando build otimizado...${NC}"
    
    # -d ../docs: gera o site na pasta docs da RAIZ (que o Cloudflare lê)
    # --cleanDestinationDir: limpa arquivos velhos na docs
    if hugo --minify --cleanDestinationDir -d ../docs; then
        echo -e "${GREEN}--> Build concluído com sucesso na pasta /docs!${NC}"
    else
        echo -e "${RED}--> ERRO: Falha crítica no build do Hugo. Deploy cancelado.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}--> Arquivo de configuração Hugo não encontrado dentro de /lec.${NC}"
    cd ..
    exit 1
fi

# 3. VOLTAR PARA A RAIZ PARA O PUSH
cd ..

# 4. PROCESSO DE GIT
echo -e "${GREEN}--> Sincronizando alterações...${NC}"

# Adiciona TUDO (o que mudou na /lec e o que o hugo gerou na /docs)
git add -A

# Verifica se há algo novo para commit
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> O repositório já está atualizado. Nada para enviar.${NC}"
    exit 0
fi

# Commit
git commit -m "$msg | Repositório: $PROJECT_NAME"

# Push para o GitHub (Main)
if git push origin main; then
    echo -e "${CYAN}--- Deploy de [$PROJECT_NAME] concluído com sucesso! ---${NC}"
    echo -e "${YELLOW}Dica: O Cloudflare levará cerca de 1 a 2 minutos para atualizar o site.${NC}"
else
    echo -e "${RED}--> ERRO: Falha ao enviar para o repositório. Verifique sua conexão.${NC}"
    exit 1
fi