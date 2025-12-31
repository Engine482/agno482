# Quick Start Guide - AgentOS Demo

## TL;DR - Get Running in 5 Minutes

```bash
# 1. Navigate to repository
cd agno482

# 2. Run automated setup
./cookbook/demo/setup.sh

# 3. Set your API keys
export ANTHROPIC_API_KEY='your_key'
export OPENAI_API_KEY='your_key'
export EXA_API_KEY='your_key'

# 4. Run the server
./cookbook/demo/run_server.sh

# 5. Open browser
# Visit: https://os.agno.com/
# Connect to: http://localhost:7777
```

## Common Commands

```bash
# Start virtual environment
source .demoenv/bin/activate

# Start/Stop PostgreSQL
docker start pgvector
docker stop pgvector

# Load knowledge base
python cookbook/demo/agno_knowledge_agent.py

# Run server
python cookbook/demo/run.py
# OR
./cookbook/demo/run_server.sh

# Check if server is running
curl http://localhost:7777/health  # Should return server status
```

## Quick Examples

### Finance Agent
```
"What's the AAPL stock price?"
"Analyze TSLA financial metrics"
```

### Research Agent
```
"What are the latest AI breakthroughs?"
"Research quantum computing trends"
```

### YouTube Agent
```
"Summarize this video: https://www.youtube.com/watch?v=..."
```

### Agno Knowledge Agent
```
"What is AgentOS?"
"How do I create an agent in Agno?"
```

### Finance Team
```
"Analyze the semiconductor market: NVDA, AMD, INTC, TSM"
"Compare Tesla, Ford, GM, and Toyota"
```

## Getting API Keys

1. **Anthropic**: https://console.anthropic.com/
2. **OpenAI**: https://platform.openai.com/api-keys
3. **Exa**: https://exa.ai/

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Import error for WorkflowAgent | Run: `pip uninstall -y agno && pip install -e libs/agno/` |
| Can't connect to PostgreSQL | Run: `docker start pgvector` |
| Port 7777 in use | Run: `lsof -i :7777` then `kill <PID>` |
| API key errors | Check: `echo $ANTHROPIC_API_KEY` |

## File Locations

- Setup script: `./cookbook/demo/setup.sh`
- Run script: `./cookbook/demo/run_server.sh`
- Main app: `./cookbook/demo/run.py`
- Environment template: `./cookbook/demo/.env.example`
- Database config: `./cookbook/demo/db.py`
- Agents: `./cookbook/demo/*_agent.py`

## Full Documentation

For complete setup instructions, see [SETUP_GUIDE.md](./SETUP_GUIDE.md)
