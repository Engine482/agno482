#!/bin/bash
# Verification test for Demo Cookbook setup
# This script verifies that all components are properly configured

set -e

echo "=================================================="
echo "Demo Cookbook Setup Verification"
echo "=================================================="
echo ""

ERRORS=0

# Test 1: Virtual environment
echo "[1/8] Checking virtual environment..."
if [ -d ".demoenv" ]; then
    echo "✅ Virtual environment exists"
else
    echo "❌ Virtual environment not found"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Test 2: Agno package version
echo "[2/8] Checking agno package version..."
source .demoenv/bin/activate
AGNO_VERSION=$(python -c "import agno; print(agno.__version__)" 2>/dev/null || echo "not found")
if [ "$AGNO_VERSION" = "2.2.9" ]; then
    echo "✅ Agno v$AGNO_VERSION installed (local development version)"
else
    echo "⚠️  Agno v$AGNO_VERSION - expected v2.2.9"
    echo "   Run: pip uninstall -y agno && pip install -e libs/agno/"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Test 3: WorkflowAgent import
echo "[3/8] Checking WorkflowAgent availability..."
if python -c "from agno.workflow import WorkflowAgent" 2>/dev/null; then
    echo "✅ WorkflowAgent can be imported"
else
    echo "❌ WorkflowAgent import failed"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Test 4: PostgreSQL container
echo "[4/8] Checking PostgreSQL container..."
if docker ps | grep -q pgvector; then
    echo "✅ PostgreSQL with PgVector is running"
else
    echo "⚠️  PostgreSQL container not running"
    echo "   Run: ./cookbook/scripts/run_pgvector.sh"
fi
echo ""

# Test 5: Required files
echo "[5/8] Checking setup files..."
FILES=(
    "cookbook/demo/setup.sh"
    "cookbook/demo/run_server.sh"
    "cookbook/demo/.env.example"
    "cookbook/demo/SETUP_GUIDE.md"
    "cookbook/demo/QUICKSTART.md"
    "cookbook/demo/run.py"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file not found"
        ERRORS=$((ERRORS + 1))
    fi
done
echo ""

# Test 6: API keys
echo "[6/8] Checking API key configuration..."
if [ -f "cookbook/demo/.env" ]; then
    echo "  ✅ .env file exists"
    # Load .env safely: set -a exports variables, set +a disables it
    # This is a standard safe pattern for loading .env files
    set -a
    source cookbook/demo/.env
    set +a
    if [ ! -z "$ANTHROPIC_API_KEY" ]; then
        echo "  ✅ ANTHROPIC_API_KEY is set"
    else
        echo "  ⚠️  ANTHROPIC_API_KEY not set in .env"
    fi
    if [ ! -z "$OPENAI_API_KEY" ]; then
        echo "  ✅ OPENAI_API_KEY is set"
    else
        echo "  ⚠️  OPENAI_API_KEY not set in .env"
    fi
    if [ ! -z "$EXA_API_KEY" ]; then
        echo "  ✅ EXA_API_KEY is set"
    else
        echo "  ⚠️  EXA_API_KEY not set in .env"
    fi
else
    echo "  ⚠️  .env file not found (optional)"
    echo "     Copy cookbook/demo/.env.example to cookbook/demo/.env"
fi
echo ""

# Test 7: Dependencies
echo "[7/8] Checking key dependencies..."
PACKAGES=("fastapi" "uvicorn" "anthropic" "openai" "psycopg" "pgvector")
for package in "${PACKAGES[@]}"; do
    if python -c "import ${package}" 2>/dev/null; then
        echo "  ✅ ${package}"
    else
        echo "  ❌ ${package} not found"
        ERRORS=$((ERRORS + 1))
    fi
done
echo ""

# Test 8: Server startup (dry run)
echo "[8/8] Testing server configuration..."
if python -c "from cookbook.demo.run import agent_os; print('Configuration valid')" 2>/dev/null; then
    echo "✅ Server configuration is valid"
else
    echo "⚠️  Server configuration check had issues"
fi
echo ""

# Summary
echo "=================================================="
if [ $ERRORS -eq 0 ]; then
    echo "✅ ALL CHECKS PASSED"
    echo ""
    echo "Your demo cookbook is ready to run!"
    echo ""
    echo "To start the server:"
    echo "  ./cookbook/demo/run_server.sh"
    echo ""
    echo "Or manually:"
    echo "  source .demoenv/bin/activate"
    echo "  python cookbook/demo/run.py"
else
    echo "⚠️  FOUND $ERRORS ERROR(S)"
    echo ""
    echo "Please review the errors above and run setup again:"
    echo "  ./cookbook/demo/setup.sh"
fi
echo "=================================================="
