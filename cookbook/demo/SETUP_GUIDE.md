# AgentOS Demo - Complete Setup Guide

This guide provides detailed instructions for setting up and running the AgentOS Demo Cookbook development server.

## Overview

The AgentOS Demo showcases a multi-agent system with:
- 🧩 **Agno MCP Agent** — connects to Agno MCP servers for live context
- 📚 **Agno Knowledge Agent** — searches Agno documentation
- 🎥 **YouTube Agent** — analyzes YouTube videos
- 💹 **Finance Agent** — retrieves and analyzes market data
- 🔍 **Research Agent** — performs live research using Exa
- 🧾 **Finance Team** — combines research and finance data
- 🧠 **Memory Manager** — summarizes and maintains user memories

## Quick Start (Automated Setup)

The easiest way to get started is using the automated setup script:

```bash
# Run the setup script
./cookbook/demo/setup.sh

# Follow the prompts to complete setup
# Then run the server:
./cookbook/demo/run_server.sh
```

## Manual Setup Instructions

If you prefer to set up manually or the automated script doesn't work, follow these steps:

### Prerequisites

- Python 3.12 or higher
- Docker Desktop (for PostgreSQL with PgVector)
- Git

### Step 1: Clone and Navigate to Repository

```bash
git clone https://github.com/Engine482/agno482.git
cd agno482
```

### Step 2: Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv .demoenv

# Activate it
source .demoenv/bin/activate  # On Linux/Mac
# OR
.demoenv\Scripts\activate     # On Windows
```

### Step 3: Install Dependencies

```bash
# Upgrade pip
pip install --upgrade pip

# Install requirements
pip install -r cookbook/demo/requirements.txt

# IMPORTANT: Install local development version of agno
pip uninstall -y agno
pip install -e libs/agno/
```

**Note:** The demo requires the local development version (v2.2.9) of agno, which includes features like `WorkflowAgent` that aren't available in the PyPI version (v2.2.1).

### Step 4: Start PostgreSQL with PgVector

The demo uses PostgreSQL with the PgVector extension for storing sessions, memories, and knowledge.

**Option A: Using the provided script:**
```bash
./cookbook/scripts/run_pgvector.sh
```

**Option B: Using Docker directly:**
```bash
docker run -d \
  -e POSTGRES_DB=ai \
  -e POSTGRES_USER=ai \
  -e POSTGRES_PASSWORD=ai \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v pgvolume:/var/lib/postgresql/data \
  -p 5532:5432 \
  --name pgvector \
  agnohq/pgvector:16
```

Verify it's running:
```bash
docker ps | grep pgvector
```

### Step 5: Configure API Keys

The demo requires API keys from three services:

1. **Anthropic** (for Claude models) - Get from [console.anthropic.com](https://console.anthropic.com/)
2. **OpenAI** (for embeddings) - Get from [platform.openai.com](https://platform.openai.com/api-keys)
3. **Exa** (for research) - Get from [exa.ai](https://exa.ai/)

**Option A: Create a .env file (recommended):**

```bash
# Copy the example file
cp cookbook/demo/.env.example cookbook/demo/.env

# Edit it with your actual API keys
nano cookbook/demo/.env  # or use your preferred editor
```

**Option B: Export environment variables:**

```bash
export ANTHROPIC_API_KEY='your_anthropic_key_here'
export OPENAI_API_KEY='your_openai_key_here'
export EXA_API_KEY='your_exa_key_here'
```

### Step 6: Load Knowledge Base (Optional)

To enable the Agno Knowledge Agent to answer questions about Agno documentation:

```bash
# Make sure your virtual environment is activated and API keys are set
python cookbook/demo/agno_knowledge_agent.py
```

This will download and index the Agno documentation into the vector database. This step may take a few minutes.

### Step 7: Run the Demo Server

```bash
python cookbook/demo/run.py
```

Or use the convenience script:
```bash
./cookbook/demo/run_server.sh
```

You should see output like:
```
╔═══════════════ AgentOS ════════════════╗
║                                        ║
║          https://os.agno.com/          ║
║                                        ║
║  OS running on: http://localhost:7777  ║
║                                        ║
╚════════════════════════════════════════╝
```

### Step 8: Connect to AgentOS UI

1. Open your browser and go to [https://os.agno.com/](https://os.agno.com/)
2. Connect to `http://localhost:7777`
3. Start interacting with your agents!

## Troubleshooting

### Import Error: Cannot import 'WorkflowAgent'

**Problem:** Getting `ImportError: cannot import name 'WorkflowAgent' from 'agno.workflow'`

**Solution:** Make sure you've installed the local development version:
```bash
pip uninstall -y agno
pip install -e libs/agno/
```

### PostgreSQL Connection Issues

**Problem:** Server can't connect to PostgreSQL

**Solutions:**
1. Verify the container is running: `docker ps | grep pgvector`
2. Start the container if stopped: `docker start pgvector`
3. Check if port 5532 is available: `lsof -i :5532` (Mac/Linux)
4. Verify connection settings in `cookbook/demo/db.py`

### API Key Errors

**Problem:** Getting authentication errors for Claude, OpenAI, or Exa

**Solutions:**
1. Verify your API keys are valid
2. Check that environment variables are set: `echo $ANTHROPIC_API_KEY`
3. If using .env file, make sure it's in `cookbook/demo/.env`
4. Restart the server after setting new environment variables

### Port 7777 Already in Use

**Problem:** Port 7777 is already in use

**Solutions:**
1. Stop any other AgentOS instances
2. Find and kill the process: `lsof -i :7777` then `kill <PID>`
3. Or change the port in the application (advanced)

## Architecture

```
agno482/
├── cookbook/
│   ├── demo/
│   │   ├── run.py                      # Main entry point
│   │   ├── setup.sh                    # Automated setup script
│   │   ├── run_server.sh              # Convenience script to run server
│   │   ├── .env.example               # Template for API keys
│   │   ├── config.yaml                # AgentOS configuration
│   │   ├── db.py                      # Database configuration
│   │   ├── requirements.txt           # Python dependencies
│   │   └── *_agent.py                 # Individual agent definitions
│   └── scripts/
│       └── run_pgvector.sh           # PostgreSQL setup script
└── libs/
    └── agno/                          # Local agno development version
```

## Features and Agents

### Available Agents

1. **Finance Agent**
   - Retrieves stock prices, market data, and financial metrics
   - Uses YFinance for real-time data
   - Example: "What's the AAPL stock price?"

2. **Research Agent**
   - Performs live web research using Exa
   - Synthesizes information from multiple sources
   - Example: "What are the latest AI breakthroughs?"

3. **YouTube Agent**
   - Analyzes YouTube videos
   - Extracts and summarizes content
   - Example: "Summarize this video: [YouTube URL]"

4. **Agno Knowledge Agent**
   - Searches indexed Agno documentation
   - Provides framework-specific guidance
   - Example: "What is AgentOS?"

5. **Agno MCP Agent**
   - Connects to Agno MCP servers
   - Provides live context and data
   - Example: "What are Agno's key features?"

6. **Memory Manager**
   - Maintains user context and memories
   - Enables personalized interactions
   - Example: "What do you know about me?"

### Available Teams

1. **Finance Team**
   - Combines research and finance agents
   - Produces comprehensive investment briefs
   - Example: "Analyze the semiconductor market"

### Available Workflows

1. **Competitive Brief**
   - Generates competitive analysis reports
   - Compares multiple vendors/companies
   - Produces structured reports with positioning, pricing, and risks

## Additional Resources

- 📘 Documentation: [https://docs.agno.com](https://docs.agno.com)
- 💬 Discord: [https://agno.link/discord](https://agno.link/discord)
- 🌐 AgentOS UI: [https://os.agno.com](https://os.agno.com)
- 📦 GitHub: [https://github.com/Engine482/agno482](https://github.com/Engine482/agno482)

## Next Steps

After successfully running the demo:

1. **Experiment with Different Agents**: Try out each agent to understand their capabilities
2. **Customize Agents**: Modify agent configurations in the `cookbook/demo/*_agent.py` files
3. **Add Your Own Agents**: Create new agents following the existing patterns
4. **Explore the AgentOS UI**: Use the web interface to interact with agents visually
5. **Build Your Own Workflows**: Combine multiple agents into custom workflows

## Support

If you encounter issues not covered in this guide:

1. Check the [main README.md](../../README.md)
2. Search existing issues on GitHub
3. Join the Discord community
4. Open a new issue with detailed information about your problem

---

**Happy Building! 🚀**
