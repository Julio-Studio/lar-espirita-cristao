#!/bin/bash

# Author: Julio Prata
# Version: 1.4
# Description: Script de deploy corrigido para estrutura com subpasta /lec e saída em /docs

# Cores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# 1. ENTRAR NA PASTA DO PROJETO (onde está o hugo.toml)
cd lec

echo -e "${CYAN}--- Iniciando Build Local em /lec ---${NC}"

# 2. GERAR O SITE (Forçando a saída para a pasta 'docs')
# Usamos -d docs porque o Cloudflare está configurado para ler 'docs'
if hugo --minify --cleanDestinationDir -d docs; then
    echo -e "${GREEN}--> Build concluído com sucesso em lec/docs!${NC}"
else
    echo -e "${RED}--> ERRO: Falha no build do Hugo.${NC}"
    exit 1
fi

# 3. VOLTAR PARA A RAIZ DO GIT
cd ..

echo -e "${CYAN}--- Sincronizando com o GitHub ---${NC}"

# Adiciona tudo (inclusive a nova pasta lec/docs)
git add .

msg="Update $(date +'%d/%m/%Y %H:%M')"
[ $# -eq 1 ] && msg="$1"

git commit -m "$msg"
git push origin main

echo -e "${GREEN}--- Deploy concluído! Verifique o Cloudflare em 1 min. ---${NC}"
