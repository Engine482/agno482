#!/bin/bash
# Run script for Demo Cookbook Development Server

set -e

# Get the root directory of the repository
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

# Load environment variables from .env if it exists
if [ -f "cookbook/demo/.env" ]; then
    echo "Loading environment variables from cookbook/demo/.env..."
    set -a
    source cookbook/demo/.env
    set +a
fi

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Virtual environment not activated. Activating .demoenv..."
    if [ -d ".demoenv" ]; then
        source .demoenv/bin/activate
    else
        echo "Error: Virtual environment not found. Run setup.sh first."
        exit 1
    fi
fi

# Check if PostgreSQL is running
if ! docker ps | grep -q pgvector; then
    echo "Starting PostgreSQL with PgVector..."
    if docker ps -a | grep -q pgvector; then
        docker start pgvector
    else
        bash cookbook/scripts/run_pgvector.sh
    fi
    echo "Waiting for PostgreSQL to be ready..."
    sleep 3
fi

echo "=================================================="
echo "Starting AgentOS Demo Server..."
echo "=================================================="
echo ""
echo "Connect to the AgentOS UI:"
echo "  Open: https://os.agno.com/"
echo "  Connect to: http://localhost:7777"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Run the demo
python cookbook/demo/run.py
