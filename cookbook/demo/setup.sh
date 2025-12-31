#!/bin/bash
# Setup script for Demo Cookbook Development Server
# This script automates the setup process described in README.md

set -e  # Exit on error

echo "=================================================="
echo "Agno Demo Cookbook - Development Server Setup"
echo "=================================================="
echo ""

# Get the root directory of the repository
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

# Step 1: Check Python version
echo "[1/7] Checking Python version..."
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
REQUIRED_VERSION="3.12"
if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]]; then
    echo "❌ Error: Python 3.12 or higher is required. Found: $PYTHON_VERSION"
    exit 1
fi
echo "✓ Python $PYTHON_VERSION detected"
echo ""

# Step 2: Create virtual environment
echo "[2/7] Setting up virtual environment..."
if [ ! -d ".demoenv" ]; then
    python3 -m venv .demoenv
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi
echo ""

# Step 3: Install dependencies
echo "[3/7] Installing dependencies..."
source .demoenv/bin/activate
pip install --upgrade pip -q
pip install -r cookbook/demo/requirements.txt -q
# Install local agno development version
pip uninstall -y agno -q 2>/dev/null || true
pip install -e libs/agno/ -q
echo "✓ Dependencies installed (using local agno v2.2.9)"
echo ""

# Step 4: Check Docker and PostgreSQL
echo "[4/7] Setting up PostgreSQL with PgVector..."
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed. Please install Docker Desktop first."
    echo "   Visit: https://docs.docker.com/desktop/"
    exit 1
fi

# Check if pgvector container is already running
if docker ps | grep -q pgvector; then
    echo "✓ PostgreSQL with PgVector is already running"
else
    # Check if container exists but is stopped
    if docker ps -a | grep -q pgvector; then
        echo "Starting existing pgvector container..."
        docker start pgvector
    else
        echo "Starting PostgreSQL with PgVector container..."
        bash cookbook/scripts/run_pgvector.sh
    fi
    echo "✓ PostgreSQL with PgVector is now running on port 5532"
fi
echo ""

# Step 5: Check API keys
echo "[5/7] Checking API keys..."
MISSING_KEYS=0

if [ -f "cookbook/demo/.env" ]; then
    source cookbook/demo/.env
fi

if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "⚠️  ANTHROPIC_API_KEY is not set"
    MISSING_KEYS=1
fi

if [ -z "$OPENAI_API_KEY" ]; then
    echo "⚠️  OPENAI_API_KEY is not set"
    MISSING_KEYS=1
fi

if [ -z "$EXA_API_KEY" ]; then
    echo "⚠️  EXA_API_KEY is not set"
    MISSING_KEYS=1
fi

if [ $MISSING_KEYS -eq 1 ]; then
    echo ""
    echo "Please set your API keys by either:"
    echo "  1. Creating a .env file in cookbook/demo/ (see .env.example)"
    echo "  2. Exporting them as environment variables:"
    echo "     export ANTHROPIC_API_KEY='your_key_here'"
    echo "     export OPENAI_API_KEY='your_key_here'"
    echo "     export EXA_API_KEY='your_key_here'"
    echo ""
    echo "Then run this script again or proceed manually."
    echo ""
else
    echo "✓ All required API keys are set"
fi
echo ""

# Step 6: Optional - Load Agno documentation
echo "[6/7] Knowledge base setup..."
if [ $MISSING_KEYS -eq 0 ]; then
    echo "To load the Agno documentation into the knowledge base, run:"
    echo "  python cookbook/demo/agno_knowledge_agent.py"
    echo ""
    echo "Would you like to load it now? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        python cookbook/demo/agno_knowledge_agent.py
        echo "✓ Knowledge base loaded"
    else
        echo "⊘ Skipped - you can load it later"
    fi
else
    echo "⊘ Skipped - requires API keys"
fi
echo ""

# Step 7: Instructions to run
echo "[7/7] Setup complete!"
echo ""
echo "=================================================="
echo "Next Steps:"
echo "=================================================="
echo ""
echo "1. Activate the virtual environment:"
echo "   source .demoenv/bin/activate"
echo ""
if [ $MISSING_KEYS -eq 1 ]; then
    echo "2. Set your API keys (see above)"
    echo ""
    echo "3. Optionally load knowledge base:"
    echo "   python cookbook/demo/agno_knowledge_agent.py"
    echo ""
    echo "4. Run the demo server:"
else
    echo "2. Run the demo server:"
fi
echo "   python cookbook/demo/run.py"
echo ""
echo "3. Connect to the AgentOS UI:"
echo "   Open: https://os.agno.com/"
echo "   Connect to: http://localhost:7777"
echo ""
echo "=================================================="
