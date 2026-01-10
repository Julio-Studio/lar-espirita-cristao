Aqui está um resumo da estrutura e das implementações realizadas no projeto **Lar Espírita Cristão (LEC)** até o momento, com base na árvore de arquivos atualizada:

---

## 📋 Resumo do Projeto Hugo (LEC)

O site utiliza o tema **Mainroad** e está configurado para gerar o conteúdo estático na pasta `./lec/docs`, facilitando a hospedagem via GitHub Pages.

### 🏗️ Estrutura de Customização

* **Redes Sociais Elegantes:** Foi criado um shortcode em `./lec/layouts/shortcodes/redes_sociais.html` que permite inserir ícones coloridos de YouTube e Facebook via Markdown.
* **Tratamento de Imagens e Legendas:** * **Render Hook:** Implementado em `./lec/layouts/_default/_markup/render-image.html` para envolver imagens em tags semânticas `<figure>` e `<figcaption>`.
* **Estilo Global:** O arquivo `./lec/static/css/custom.css` centraliza as imagens, aplica limites de largura (evitando que fotos fiquem gigantes) e estiliza as legendas.


* **Abertura de Links:** O arquivo `./lec/layouts/_default/_markup/render-link.html` garante que links externos sejam abertos em nova aba automaticamente.
* **Widgets Personalizados:** Existe um widget de agenda customizado em `./lec/layouts/partials/widgets/agenda_custom.html`.

### 📄 Conteúdo e Ativos

* **Páginas Principais:** Localizadas em `./lec/content/`, abrangendo temas como `agenda.md`, `allan-kardec.md`, `chico-xavier.md` e `pinga-fogo.md`.
* **Banco de Imagens:** Centralizado em `./lec/static/images/`, contendo fotos históricas e da fachada da instituição.
* **Configuração Central:** O arquivo `./lec/hugo.toml` gerencia o menu principal, as cores de destaque (`#e22d30`) e a integração do CSS personalizado.

### 🚀 Fluxo de Trabalho

1. **Edição:** O conteúdo é editado nos arquivos `.md` dentro de `content`.
2. **Renderização:** O Hugo utiliza os *layouts* e *shortcodes* para transformar o Markdown em HTML elegante.
3. **Publicação:** O script `./deploy.sh` na raiz do projeto é responsável por disparar a atualização do site para a pasta `docs`.

---
