FROM node:18 as build

WORKDIR /app/frontend

# Copy package.json and package-lock.json files
COPY ./app/frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the frontend code
COPY ./app/frontend ./

# Create .env file for React build time
RUN echo "REACT_APP_BASE_URL=http://localhost:3000" > .env

# Build the React app
RUN npm run build

# Production environment
FROM nginx:stable-alpine

# Copy the build folder from the build stage
COPY --from=build /app/frontend/build /usr/share/nginx/html

# Add nginx configuration to handle SPA routing
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]