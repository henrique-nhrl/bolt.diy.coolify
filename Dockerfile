FROM node:20.18.0

WORKDIR /app

RUN corepack prepare pnpm@10.0.0 --activate

# Instalar pnpm e wrangler
RUN corepack enable pnpm && \
    npm install -g wrangler

# Copiar arquivos de dependências
COPY package.json pnpm-lock.yaml ./

# Instalar dependências
RUN pnpm install

# Copiar código  fonte e scripts
COPY . .

# Garantir que o bindings.sh tem permissões de execução e formato correto
RUN tr -d '\r' < bindings.sh > bindings.tmp && \
    mv bindings.tmp bindings.sh && \
    chmod +x bindings.sh

# Build da aplicação
RUN pnpm run build

# Expor porta
EXPOSE 5173

# Configurar variáveis de ambiente

# Define environment variables with default values or let them be overridden
ARG GROQ_API_KEY
ARG HuggingFace_API_KEY
ARG OPENAI_API_KEY
ARG ANTHROPIC_API_KEY
ARG OPEN_ROUTER_API_KEY
ARG GOOGLE_GENERATIVE_AI_API_KEY
ARG OLLAMA_API_BASE_URL=http://host.docker.internal:11434
ARG XAI_API_KEY
ARG TOGETHER_API_KEY
ARG TOGETHER_API_BASE_URL
ARG AWS_BEDROCK_CONFIG
ARG VITE_LOG_LEVEL=debug
ARG DEFAULT_NUM_CTX

ENV NODE_ENV=production \
    RUNNING_IN_DOCKER=true \
    WRANGLER_SEND_METRICS=false \
    GROQ_API_KEY=${GROQ_API_KEY} \
    HuggingFace_KEY=${HuggingFace_API_KEY} \
    OPENAI_API_KEY=${OPENAI_API_KEY} \
    ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY} \
    OPEN_ROUTER_API_KEY=${OPEN_ROUTER_API_KEY} \
    GOOGLE_GENERATIVE_AI_API_KEY=${GOOGLE_GENERATIVE_AI_API_KEY} \
    OLLAMA_API_BASE_URL=${OLLAMA_API_BASE_URL} \
    XAI_API_KEY=${XAI_API_KEY} \
    TOGETHER_API_KEY=${TOGETHER_API_KEY} \
    TOGETHER_API_BASE_URL=${TOGETHER_API_BASE_URL} \
    AWS_BEDROCK_CONFIG=${AWS_BEDROCK_CONFIG} \
    VITE_LOG_LEVEL=${VITE_LOG_LEVEL} \
    DEFAULT_NUM_CTX=${DEFAULT_NUM_CTX}\
    RUNNING_IN_DOCKER=true

# Comando para iniciar usando o script dockerstart
CMD ["pnpm", "run", "dockerstart"]
