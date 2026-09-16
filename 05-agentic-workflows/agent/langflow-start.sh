#!/bin/bash

# Langflow Startup Script for Juno PM Agent
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Juno PM Agent — Langflow Startup${NC}\n"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker found${NC}"

# Check API key
if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${YELLOW}⚠️  Set OPENAI_API_KEY environment variable${NC}"
    read -p "Paste your key (or press Enter to skip): " OPENAI_API_KEY
    if [ -z "$OPENAI_API_KEY" ]; then
        echo -e "${RED}❌ API key required${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ API key configured${NC}\n"

# Check KB folder
KB_PATH="/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent"
if [ ! -d "$KB_PATH" ]; then
    echo -e "${RED}❌ KB folder not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ KB folder found${NC}\n"

# Stop existing
if docker ps --format '{{.Names}}' | grep -q "^langflow$"; then
    docker stop langflow || true
    docker rm langflow || true
fi

# Start
echo -e "${YELLOW}Starting Langflow...${NC}\n"
docker run \
  -e OPENAI_API_KEY="$OPENAI_API_KEY" \
  -e LANGFLOW_AUTO_LOGIN=true \
  -v "$KB_PATH:/app/kb" \
  -p 7860:7860 \
  --name langflow \
  langflowai/langflow
