#!/bin/bash

# *Mod by Fong on $(date '+%Y-%m-%d--%H-%M-%p')*

# Installation script for essential calculation and data analysis tools
# Based on rule-compute-with-tools-sandbox-tinh-toan.mdc

set -e  # Exit immediately if a command exits with a non-zero status
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}===== $1 =====${NC}\n"
}

print_step() {
    echo -e "${GREEN}>> $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

print_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

print_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Install essential tools for computation, data analysis, and sandboxed development."
    echo ""
    echo "Options:"
    echo "  --all               Install all tool categories"
    echo "  --base              Install base utilities only"
    echo "  --data              Install data processing tools"
    echo "  --scientific        Install scientific computation tools"
    echo "  --ml                Install machine learning tools"
    echo "  --viz               Install visualization tools"
    echo "  --command-line      Install command-line tools"
    echo "  --db                Install database tools"
    echo "  --performance       Install performance tools"
    echo "  --domain            Install specialized domain tools"
    echo "  --sandbox           Install sandbox development tools"
    echo "  --help              Display this help message"
    echo ""
    echo "Example: $0 --base --data --ml"
}

create_venv() {
    print_header "Setting up Python virtual environment"
    
    if [ ! -d "venv" ]; then
        print_step "Creating virtual environment..."
        python3 -m venv venv
    else
        print_step "Virtual environment already exists"
    fi
    
    print_step "Activating virtual environment..."
    source venv/bin/activate
    
    print_step "Updating pip..."
    pip install --upgrade pip
}

install_base() {
    print_header "Installing Base System Utilities"
    
    print_step "Updating system package lists..."
    sudo apt update
    
    print_step "Installing essential system utilities..."
    sudo apt install -y \
        build-essential \
        curl \
        wget \
        git \
        htop \
        unzip \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release
}

install_data_processing() {
    print_header "Installing Data Processing & Analysis Tools"
    
    print_step "Installing Pandas, NumPy and core data libraries..."
    pip install pandas numpy polars
    
    print_step "Installing big data processing libraries..."
    pip install "dask[complete]" vaex pyarrow modin datatable
}

install_scientific() {
    print_header "Installing Scientific Computation Tools"
    
    print_step "Installing SciPy, SymPy and core scientific libraries..."
    pip install scipy sympy
    
    print_step "Installing advanced computation tools..."
    pip install pymc statsmodels
    
    print_step "Installing JAX (CPU version)..."
    pip install "jax[cpu]"
    
    print_step "Installing additional scientific packages..."
    sudo apt install -y octave
    pip install rpy2
    
    print_warning "Note: PyStan is complex to install and may require specific system dependencies"
    # pip install pystan  # Commented out as it often requires specific setup
}

install_ml() {
    print_header "Installing Machine Learning & AI Tools"
    
    print_step "Installing scikit-learn..."
    pip install scikit-learn
    
    print_step "Installing gradient boosting libraries..."
    pip install xgboost lightgbm catboost
    
    print_step "Installing NLP libraries..."
    pip install transformers spacy
    pip install -U "spacy[cuda]"  # GPU version if available
    
    print_step "Installing TensorFlow (CPU)..."
    pip install tensorflow
    
    print_step "Installing PyTorch (CPU)..."
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    
    print_warning "Note: For GPU versions of TensorFlow and PyTorch, please install separately based on your GPU"
}

install_visualization() {
    print_header "Installing Visualization Tools"
    
    print_step "Installing core visualization libraries..."
    pip install matplotlib seaborn plotly
    
    print_step "Installing advanced visualization tools..."
    pip install bokeh altair holoviews datashader
    
    print_step "Installing PyVista for 3D visualization..."
    pip install pyvista
}

install_command_line() {
    print_header "Installing Command Line & Systems Tools"
    
    print_step "Installing core command line tools..."
    sudo apt install -y \
        bc \
        gawk \
        jq \
        datamash \
        parallel \
        miller \
        octave
    
    print_step "Installing cargo (Rust package manager) for xsv..."
    if ! command -v cargo &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source $HOME/.cargo/env
    fi
    
    print_step "Installing xsv (CSV processor)..."
    cargo install xsv
}

install_db() {
    print_header "Installing Database & Storage Tools"
    
    print_step "Installing SQLite and database tools..."
    sudo apt install -y sqlite3
    
    print_step "Installing Python database libraries..."
    pip install duckdb sqlalchemy psycopg2-binary pymysql
    
    print_step "Installing scientific data storage libraries..."
    pip install h5py zarr fsspec lmdb
}

install_performance() {
    print_header "Installing Performance & Scaling Tools"
    
    print_step "Installing core performance libraries..."
    pip install numba cython ray[default] joblib
    
    print_step "Installing Dask for parallel computing..."
    pip install dask distributed
    
    print_step "Installing Vaex for out-of-core dataframes..."
    pip install vaex
    
    print_warning "Note: CuPy (GPU accelerated NumPy) requires specific NVIDIA setup"
    # pip install cupy  # Commented out as it requires CUDA setup
}

install_domain() {
    print_header "Installing Specialized Domain Tools"
    
    print_step "Installing graph analysis tools..."
    pip install networkx
    
    print_step "Installing geospatial tools..."
    pip install geopandas
    
    print_step "Installing scientific specialized libraries..."
    pip install biopython astropy tables
    
    print_step "Installing NLP and audio processing tools..."
    pip install nltk librosa
}

install_time_series() {
    print_header "Installing Time Series & Forecasting Tools"
    
    print_step "Installing time series core libraries..."
    pip install tsfresh sktime
    
    print_step "Installing Prophet for forecasting..."
    pip install prophet
    
    print_step "Installing additional time series tools..."
    pip install kats pydlm pyts
}

install_optimization() {
    print_header "Installing Optimization & Operations Research Tools"
    
    print_step "Installing optimization libraries..."
    pip install pulp cvxpy ortools pyomo
    
    print_step "Installing hyperparameter optimization tools..."
    pip install optuna hyperopt
    
    print_step "Installing evolutionary algorithm libraries..."
    pip install deap
}

install_sandbox() {
    print_header "Installing Sandbox Development Tools"
    
    print_step "Installing Jupyter ecosystem..."
    pip install notebook jupyterlab ipython
    
    print_step "Installing Docker..."
    if ! command -v docker &> /dev/null; then
        sudo apt install -y docker.io
        sudo usermod -aG docker $USER
        sudo systemctl enable docker
        sudo systemctl start docker
        print_warning "You may need to log out and back in for Docker permissions to take effect"
    else
        print_step "Docker is already installed"
    fi
    
    print_step "Installing VS Code..."
    if ! command -v code &> /dev/null; then
        sudo apt install -y apt-transport-https
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt update
        sudo apt install -y code
    else
        print_step "VS Code is already installed"
    fi
    
    print_step "Installing Conda (Miniconda)..."
    if ! command -v conda &> /dev/null; then
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
        bash miniconda.sh -b -p $HOME/miniconda
        rm miniconda.sh
        echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
        print_warning "Please restart your terminal or run 'source ~/.bashrc' to use conda"
    else
        print_step "Conda is already installed"
    fi
}

install_all() {
    install_base
    install_data_processing
    install_scientific
    install_ml
    install_visualization
    install_command_line
    install_db
    install_performance
    install_domain
    install_time_series
    install_optimization
    install_sandbox
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    print_help
    exit 1
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            create_venv
            install_all
            shift
            ;;
        --base)
            install_base
            shift
            ;;
        --data)
            create_venv
            install_data_processing
            shift
            ;;
        --scientific)
            create_venv
            install_scientific
            shift
            ;;
        --ml)
            create_venv
            install_ml
            shift
            ;;
        --viz)
            create_venv
            install_visualization
            shift
            ;;
        --command-line)
            install_command_line
            shift
            ;;
        --db)
            create_venv
            install_db
            shift
            ;;
        --performance)
            create_venv
            install_performance
            shift
            ;;
        --domain)
            create_venv
            install_domain
            shift
            ;;
        --time-series)
            create_venv
            install_time_series
            shift
            ;;
        --optimization)
            create_venv
            install_optimization
            shift
            ;;
        --sandbox)
            create_venv
            install_sandbox
            shift
            ;;
        --help)
            print_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

print_header "Installation Complete!"
echo -e "${GREEN}To use Python packages, activate the virtual environment:${NC}"
echo -e "    source venv/bin/activate"
echo ""
echo -e "${YELLOW}Note: Some tools may require additional configuration or dependencies.${NC}"
echo -e "${YELLOW}Please check the documentation for specific tools if you encounter any issues.${NC}" 