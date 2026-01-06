#!/bin/bash

# Author: Julio Prata
# Version: 1.3
# Description: Script de deploy híbrido otimizado para Cloudflare Pages (Pasta docs)

# Cores para feedback visual
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem cor

PROJECT_NAME=$(basename "$PWD")

echo -e "${CYAN}--- Iniciando Deploy para: $PROJECT_NAME ---${NC}"

# Define a mensagem de commit (Usa o argumento $1 ou a data atual)
msg="Update $(date +'%d/%m/%Y %H:%M')"
if [ $# -eq 1 ]; then
  msg="$1"
fi

# 1. VERIFICAÇÃO DE AMBIENTE HUGO
if [ -f "hugo.toml" ] || [ -f "config.toml" ]; then
    echo -e "${GREEN}--> Projeto Hugo detectado. Iniciando build otimizado...${NC}"
    
    # --minify: comprime HTML/CSS/JS para performance máxima
    # --cleanDestinationDir: remove lixo de builds anteriores na pasta docs
    # -d docs: garante que o destino seja sempre a pasta lida pela Cloudflare
    if hugo --minify --cleanDestinationDir -d docs; then
        echo -e "${GREEN}--> Build concluído com sucesso!${NC}"
        
        # GARANTIA: Força o Git a monitorar a pasta docs (evita erro de 'nothing to commit')
        git add docs/
    else
        echo -e "${RED}--> ERRO: Falha crítica no build do Hugo. Deploy cancelado.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}--> Projeto comum detectado. Pulando etapa de build Hugo.${NC}"
fi

# 2. VERIFICAÇÃO DE MUDANÇAS NO GIT
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> O repositório já está atualizado. Nada para enviar.${NC}"
    exit 0
fi

# 3. PROCESSO DE PUSH
echo -e "${GREEN}--> Sincronizando alterações com o GitLab...${NC}"

# Adiciona todas as mudanças (arquivos novos, alterados e deletados)
git add -A

# Commit com a mensagem e o nome do projeto para facilitar o histórico
git commit -m "$msg | Repositório: $PROJECT_NAME"

# Push garantindo a branch main
if git push origin main; then
    echo -e "${CYAN}--- Deploy de [$PROJECT_NAME] concluído com sucesso! ---${NC}"
else
    echo -e "${RED}--> ERRO: Falha ao enviar para o GitLab. Verifique sua conexão ou permissões.${NC}"
    exit 1
fi