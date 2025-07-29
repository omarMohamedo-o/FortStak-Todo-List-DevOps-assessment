# Use Node.js LTS base image
# FROM node:18
FROM node:18.14.2-alpine3.17

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose the app port
EXPOSE 4000

# Start the app
CMD ["node", "index.js"]