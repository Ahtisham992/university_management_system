FROM node:18

WORKDIR /app/backend

# Copy package.json and package-lock.json files
COPY ./app/backend/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the backend code
COPY ./app/backend ./

# Environment variables
ENV NODE_ENV=production

# Expose the port your backend runs on
EXPOSE 3000

# Start the server
CMD ["node", "index.js"]