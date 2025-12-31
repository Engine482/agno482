# AgentOS Demo

This demo shows how to run a **multi-agent system** using **AgentOS**, the high-performance runtime built into the [Agno](https://agno.com) framework.

It includes a set of example Agents and Teams that demonstrate how AgentOS can coordinate specialized agents for tasks like research, analysis, memory management, and data retrieval.

---

## What’s Included

- 🧩 **Agno MCP Agent** — connects to the Agno MCP servers for live context and data
- 📚 **Agno Knowledge Agent** — searches the Agno documentation for information
- 🎥 **YouTube Agent** — analyzes YouTube videos and answers questions
- 💹 **Finance Agent** — retrieves and analyzes stock and market data
- 🔍 **Research Agent** — performs live research using ExaTools
- 🧾 **Finance Team** — combines research and finance data into reports to provide a full investment brief
- 🧠 **Memory Manager** — summarizes and maintains user memories

---

## Setup

> 💡 **Tip:** Fork and clone the repository first if you plan to modify the demo.

### Quick Start (Automated)

```shell
# Run the automated setup script
./cookbook/demo/setup.sh

# Then start the server
./cookbook/demo/run_server.sh
```

For detailed setup instructions, see [SETUP_GUIDE.md](./SETUP_GUIDE.md) or [QUICKSTART.md](./QUICKSTART.md).

### Manual Setup

### 1. Create a virtual environment

**Option A: Using uv (recommended)**
```shell
uv venv .demoenv --python 3.12
source .demoenv/bin/activate
```

**Option B: Using Python's built-in venv**
```shell
python3 -m venv .demoenv
source .demoenv/bin/activate
```

### 2. Install dependencies

**Option A: Using uv**
```shell
uv pip install -r cookbook/demo/requirements.txt
```

**Option B: Using pip**
```shell
pip install --upgrade pip
pip install -r cookbook/demo/requirements.txt
```

**Important:** Install the local development version of agno:
```shell
pip uninstall -y agno
pip install -e libs/agno/
```

### 3. Run Postgres with PgVector

We'll use postgres for storing session, memory and knowledge. Install [docker desktop](https://docs.docker.com/desktop/install/mac-install/) and run the following command to start a postgres container with PgVector.

```shell
./cookbook/scripts/run_pgvector.sh
```

OR use the docker run command directly:

```shell
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

### 4. Export API Keys

We recommend using claude-sonnet-4-5 for your agents, but you can use any Model you like.

**Option A: Using environment variables**
```shell
export ANTHROPIC_API_KEY=your_anthropic_key_here
export OPENAI_API_KEY=your_openai_key_here
export EXA_API_KEY=your_exa_key_here
```

**Option B: Using a .env file (recommended)**
```shell
# Copy the example file
cp cookbook/demo/.env.example cookbook/demo/.env

# Edit it with your actual API keys
nano cookbook/demo/.env
```

Get your API keys from:
- Anthropic: https://console.anthropic.com/
- OpenAI: https://platform.openai.com/api-keys
- Exa: https://exa.ai/

### 5. Add Agno Documentation to the Knowledge Base

```shell
python cookbook/demo/agno_knowledge_agent.py
```

### 6. Run the demo AgentOS

**Option A: Using the run script**
```shell
./cookbook/demo/run_server.sh
```

**Option B: Running directly**
```shell
python cookbook/demo/run.py
```

### 7. Connect to the AgentOS UI

- Open the web interface: [os.agno.com](https://os.agno.com/)
- Connect to http://localhost:7777 to interact with the demo AgentOS.

---

## Additional Resources

- 📘 **Documentation**: https://docs.agno.com
- 💬 **Discord**: https://agno.link/discord
- 📖 **Setup Guide**: [SETUP_GUIDE.md](./SETUP_GUIDE.md)
- 🚀 **Quick Start**: [QUICKSTART.md](./QUICKSTART.md)
