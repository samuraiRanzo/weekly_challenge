FROM node:20-slim

WORKDIR /app

# Copy package files first for better layer caching
COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 5173

# The --host flag is required for Vite to accept external Docker connections
CMD ["npm", "run", "dev", "--", "--host"]