# Use official Node.js 18 image
FROM node:18

# Set working directory in container
WORKDIR /app

# Copy only package.json and package-lock.json first (for caching)
COPY app/backend/package*.json ./backend/

# Install backend dependencies
WORKDIR /app/backend
RUN npm install

# Copy the full backend source code
COPY app/backend ./ 

# Set environment to production
ENV NODE_ENV=production

# Expose backend port
EXPOSE 3000

# Run the backend server
CMD ["node", "index.js"]
