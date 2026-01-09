# 1. Use a lightweight Node image
FROM node:20-alpine

# 2. Set working directory
WORKDIR /app

# 3. Copy package files first (to leverage Docker cache)
COPY package*.json ./

# 4. Install dependencies
RUN npm install

# 5. Copy the rest of the code
COPY . .

# 6. Expose the Vite development port
EXPOSE 5173

# 7. Start the development server
# --host 0.0.0.0 is critical for Docker networking
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]