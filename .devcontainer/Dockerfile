# Dockerfile para Bootcamp Bash - Entorno de Desarrollo Seguro
FROM debian:12-slim

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Bogota

# Metadatos del contenedor
LABEL maintainer="Bootcamp Bash Team"
LABEL description="Entorno de desarrollo containerizado para Bootcamp Bash - Debian 12"
LABEL version="2.0"
LABEL base_image="debian:12-slim"

# Configurar timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Actualizar sistema e instalar dependencias básicas optimizadas para Debian slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Herramientas básicas del sistema
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    apt-transport-https \
    # Shells y herramientas de terminal esenciales
    bash \
    bash-completion \
    zsh \
    tmux \
    screen \
    # Herramientas de desarrollo core
    git \
    vim \
    nano \
    # Herramientas de texto y procesamiento (muchas ya están en base)
    gawk \
    # Herramientas de archivos y sistema
    file \
    tree \
    rsync \
    tar \
    gzip \
    unzip \
    # Herramientas de red básicas
    iputils-ping \
    net-tools \
    netcat-openbsd \
    telnet \
    dnsutils \
    # Analizadores de código Bash
    shellcheck \
    # Herramientas de debugging y desarrollo (Módulo 7)
    strace \
    ltrace \
    gdb \
    valgrind \
    # Herramientas de sistema y monitoreo (Módulo 6)
    procps \
    psmisc \
    cron \
    # Framework de testing para Bash (Módulo 7)
    bats \
    # Utilidades esenciales para bootcamp
    jq \
    bc \
    sudo \
    man-db \
    manpages-dev \
    # Herramientas adicionales para módulos avanzados
    htop \
    watch \
    time \
    parallel \
    pv \
    # Editores adicionales (less ya viene incluido, more también)
    # Python para scripts auxiliares
    python3 \
    python3-pip \
    # Node.js para herramientas modernas (sin npm, usaremos pnpm)
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Instalar Docker CLI para desarrollo (configuración para Debian)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Instalar GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario no-root para mayor seguridad
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid vscode --shell /bin/zsh --create-home vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

# Configurar Oh My Zsh para el usuario vscode
USER vscode
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Configurar plugins útiles para Oh My Zsh
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Configurar .zshrc con plugins útiles
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker docker-compose)/' ~/.zshrc

# Agregar aliases útiles para el bootcamp
RUN echo '' >> ~/.zshrc \
    && echo '# Bootcamp Bash Aliases' >> ~/.zshrc \
    && echo 'alias ll="ls -la"' >> ~/.zshrc \
    && echo 'alias la="ls -A"' >> ~/.zshrc \
    && echo 'alias l="ls -CF"' >> ~/.zshrc \
    && echo 'alias grep="grep --color=auto"' >> ~/.zshrc \
    && echo 'alias fgrep="fgrep --color=auto"' >> ~/.zshrc \
    && echo 'alias egrep="egrep --color=auto"' >> ~/.zshrc \
    && echo 'alias tree="tree -C"' >> ~/.zshrc \
    && echo 'alias shellcheck-all="find . -name \"*.sh\" -exec shellcheck {} \;"' >> ~/.zshrc \
    && echo 'alias bc-run="cd /workspace && bash"' >> ~/.zshrc \
    && echo 'alias bc-test="cd /workspace && bats"' >> ~/.zshrc

# Instalar PNPM (más eficiente que npm) usando el script oficial
RUN curl -fsSL https://get.pnpm.io/install.sh | sh - \
    && echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.zshrc \
    && echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.zshrc \
    && echo 'alias npm="pnpm"' >> ~/.zshrc \
    && echo 'alias npx="pnpx"' >> ~/.zshrc

# Configurar Git con configuración básica
RUN git config --global init.defaultBranch main \
    && git config --global core.autocrlf input \
    && git config --global core.eol lf \
    && git config --global pull.rebase false

# Instalar herramientas Python útiles para el bootcamp (usando --break-system-packages para Debian)
RUN pip3 install --user --break-system-packages \
    requests \
    beautifulsoup4 \
    pyyaml \
    jsonschema \
    markdown

# Cambiar de vuelta a root para configuraciones finales
USER root

# Crear directorio de workspace
RUN mkdir -p /workspace && chown vscode:vscode /workspace

# Configurar locale (optimizado para Debian)
RUN apt-get update && apt-get install -y --no-install-recommends locales \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Script de inicialización del contenedor
COPY setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

# Configurar punto de entrada
USER vscode
WORKDIR /workspace

# Exponer puertos para desarrollo
EXPOSE 3000 8000 8080 9000

# Comando por defecto optimizado para Bash bootcamp
CMD ["/bin/bash"]
