#!/bin/bash
# Setup script for Bootcamp Bash Development Container - Debian 12-slim
# This script runs after the container is created

set -euo pipefail

echo "🚀 Setting up Bootcamp Bash Development Environment (Debian 12-slim)..."

# Verificar que estamos en el contenedor correcto
echo "🐳 Container verification:"
echo "- OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "- User: $(whoami)"
echo "- Timezone: $(cat /etc/timezone)"
echo "- Date: $(date)"

# Verificar migración a Debian (si existe el script)
if [ -f "/workspace/.devcontainer/verify-debian.sh" ]; then
    echo "🔍 Verifying Debian migration..."
    bash /workspace/.devcontainer/verify-debian.sh
fi

# Verificar herramientas del bootcamp (si existe el script)
if [ -f "/workspace/.devcontainer/verify-bootcamp-tools.sh" ]; then
    echo "🛠️  Verifying bootcamp tools..."
    bash /workspace/.devcontainer/verify-bootcamp-tools.sh
fi

# Verificar configuración de PNPM (si existe el script)
if [ -f "/workspace/.devcontainer/verify-pnpm.sh" ]; then
    echo "📦 Verifying PNPM configuration..."
    bash /workspace/.devcontainer/verify-pnpm.sh
fi

# Validar configuración de zona horaria (si existe el script)
if [ -f "/workspace/.devcontainer/validate-timezone.sh" ]; then
    echo "🌍 Validating timezone configuration..."
    bash /workspace/.devcontainer/validate-timezone.sh
fi

# Verificar locale
echo "🌐 Locale configuration:"
locale

# Verificar herramientas principales manualmente
echo "� Essential tools verification:"
echo "- Bash: $(bash --version | head -1)"
echo "- Git: $(git --version)"
echo "- Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
echo "- Python: $(python3 --version 2>/dev/null || echo 'Not installed')"

# Verificar PNPM
echo "- PNPM: $(~/.local/share/pnpm/pnpm --version 2>/dev/null || echo 'Not installed')"

echo ""
echo "✅ Bootcamp Bash Development Environment setup complete!"
echo "🎯 You can now start working on the bash modules."
echo ""
echo "🚀 Quick start commands:"
echo "  cd /workspace"
echo "  ls -la modulo*/"
echo "  ./verify-environment.sh  # If available"
echo ""
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias bashcheck='shellcheck'
alias bcbash='cd /workspace'
alias docs='cd /workspace/_docs'
alias scripts='cd /workspace/_scripts'
alias m1='cd /workspace/bootcamp/week-01'
alias m2='cd /workspace/bootcamp/week-02'
alias m3='cd /workspace/bootcamp/week-03'
alias m4='cd /workspace/bootcamp/week-04'
alias m5='cd /workspace/bootcamp/week-05'
alias m6='cd /workspace/bootcamp/week-06'
alias m7='cd /workspace/bootcamp/week-07'
alias m8='cd /workspace/bootcamp/week-08'

# Useful functions
mk() { mkdir -p "$@" && cd "$1"; }
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"     ;;
            *.tar.gz)    tar xvzf "$1"     ;;
            *.bz2)       bunzip2 "$1"      ;;
            *.rar)       unrar x "$1"      ;;
            *.gz)        gunzip "$1"       ;;
            *.tar)       tar xvf "$1"      ;;
            *.tbz2)      tar xvjf "$1"     ;;
            *.tgz)       tar xvzf "$1"     ;;
            *.zip)       unzip "$1"        ;;
            *.Z)         uncompress "$1"   ;;
            *.7z)        7z x "$1"         ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

EOF

# Set up exercise runner script
echo "🎯 Setting up exercise utilities..."
sudo tee /usr/local/bin/run-exercise > /dev/null << 'EOF'
#!/bin/bash
# Exercise runner utility for Bootcamp Bash

if [[ $# -eq 0 ]]; then
    echo "Usage: run-exercise <module> <exercise>"
    echo "Example: run-exercise 1 basic-commands"
    exit 1
fi

MODULE="$1"
EXERCISE="$2"
EXERCISE_PATH="/workspace/modulo${MODULE}/2-practicas/${EXERCISE}.sh"

if [[ -f "$EXERCISE_PATH" ]]; then
    echo "🚀 Running exercise: Module $MODULE - $EXERCISE"
    echo "----------------------------------------"
    bash "$EXERCISE_PATH"
else
    echo "❌ Exercise not found: $EXERCISE_PATH"
    echo "Available exercises in module $MODULE:"
    ls -1 "/workspace/modulo${MODULE}/2-practicas/"*.sh 2>/dev/null | xargs -n1 basename -s .sh || echo "No exercises found"
fi
EOF

sudo chmod +x /usr/local/bin/run-exercise

# Set up project checker script
echo "✅ Setting up project utilities..."
sudo tee /usr/local/bin/check-project > /dev/null << 'EOF'
#!/bin/bash
# Project checker utility for Bootcamp Bash

MODULE="${1:-all}"

if [[ "$MODULE" == "all" ]]; then
    echo "🔍 Checking all modules..."
    for i in {1..8}; do
        echo "--- Module $i ---"
        find "/workspace/modulo$i" -name "*.sh" -exec shellcheck {} \; 2>/dev/null || echo "No scripts found in module $i"
    done
else
    echo "🔍 Checking module $MODULE..."
    find "/workspace/modulo$MODULE" -name "*.sh" -exec shellcheck {} \; 2>/dev/null || echo "No scripts found in module $MODULE"
fi
EOF

sudo chmod +x /usr/local/bin/check-project

# Create development workspace structure
echo "📁 Setting up workspace structure..."
cd /workspace

# Ensure all module directories exist with proper structure
for i in {1..8}; do
    mkdir -p "modulo$i"/{ejercicios,proyectos,data,tools}
done

# Create symbolic links for easy access
ln -sf /workspace/_docs ~/docs 2>/dev/null || true
ln -sf /workspace/_scripts ~/scripts 2>/dev/null || true

# Set executable permissions for all scripts
echo "🔐 Setting script permissions..."
find /workspace/_scripts -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
find /workspace -path "*/2-practicas/*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
find /workspace -path "*/3-proyecto/*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true

# Create a welcome message
echo "🎉 Creating welcome message..."
sudo tee /usr/local/bin/bootcamp-welcome > /dev/null << 'EOF'
#!/bin/bash

clear
figlet -f big "BC-BASH" 2>/dev/null || echo "=== BOOTCAMP BASH ==="
echo ""
echo "🚀 Welcome to the Bash Scripting Bootcamp Development Environment!"
echo ""
echo "📚 Available commands:"
echo "  bcbash           - Go to bootcamp root directory"
echo "  run-exercise     - Run a specific exercise"
echo "  check-project    - Check scripts with shellcheck"
echo "  m1, m2, ... m8   - Quick access to modules"
echo "  docs             - Go to documentation"
echo "  scripts          - Go to utility scripts"
echo ""
echo "🎯 Quick start:"
echo "  run-exercise 1 hello-world"
echo "  check-project 1"
echo ""
echo "📖 Documentation: /workspace/_docs/"
echo "🔧 Scripts: /workspace/_scripts/"
echo ""
echo "Happy coding! 🎉"
echo ""
EOF

sudo chmod +x /usr/local/bin/bootcamp-welcome

# Add welcome message to shell startup
echo "bootcamp-welcome" >> ~/.zshrc

# Create container health check
echo "❤️ Setting up health check..."
sudo tee /usr/local/bin/container-health > /dev/null << 'EOF'
#!/bin/bash
# Container health check for Bootcamp Bash environment

echo "🏥 Container Health Check"
echo "========================"

# Check essential tools
TOOLS=("bash" "zsh" "git" "shellcheck" "jq" "curl" "vim" "tree")
echo "🔧 Checking essential tools..."
for tool in "${TOOLS[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✅ $tool"
    else
        echo "  ❌ $tool (missing)"
    fi
done

# Check workspace structure
echo ""
echo "📁 Checking workspace structure..."
DIRS=("_docs" "_scripts" "assets")
for i in {1..8}; do
    DIRS+=("modulo$i" "modulo$i/ejercicios" "modulo$i/proyectos")
done

for dir in "${DIRS[@]}"; do
    if [[ -d "/workspace/$dir" ]]; then
        echo "  ✅ $dir"
    else
        echo "  ❌ $dir (missing)"
    fi
done

# Check permissions
echo ""
echo "🔐 Checking script permissions..."
SCRIPT_COUNT=$(find /workspace -name "*.sh" -type f -executable | wc -l)
echo "  📝 Executable scripts found: $SCRIPT_COUNT"

echo ""
echo "🎉 Health check completed!"
EOF

sudo chmod +x /usr/local/bin/container-health

# Clean up
echo "🧹 Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get autoclean

echo ""
echo "✨ Setup completed successfully!"
echo "🔄 Please reload your shell or restart the container to apply all changes."
echo ""
