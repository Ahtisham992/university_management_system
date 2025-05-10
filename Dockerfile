FROM node:18 as backend-build

# Set up backend
WORKDIR /app/backend
COPY ./app/backend/package*.json ./
RUN npm install
COPY ./app/backend ./

# Build frontend
FROM node:18 as frontend-build
WORKDIR /app/frontend
COPY ./app/frontend/package*.json ./
RUN npm install
COPY ./app/frontend ./

# Create .env file for React build time - this is critical
RUN echo "REACT_APP_BASE_URL=http://localhost:3000" > .env

RUN npm run build

# Production environment
FROM node:18-slim

# Set up app directory
WORKDIR /app

# Copy backend from build stage
COPY --from=backend-build /app/backend /app/backend

# Copy frontend build from frontend-build stage
COPY --from=frontend-build /app/frontend/build /app/frontend/build

# Install serve to serve the frontend static files
RUN npm install -g serve

# Set environment variables including Stripe API key
ENV NODE_ENV=production
ENV STRIPE_SECRET_KEY="your_stripe_secret_key"
ENV MONGODB_URI="mongodb+srv://shamimuhammad77:helloAhtisham@cluster1.yvtj5.mongodb.net/UMS?retryWrites=true&w=majority&appName=Cluster0"
ENV JWT_SECRET="your_jwt_secret"
ENV CORS_ORIGIN="http://localhost:5000"

# Expose ports
EXPOSE 3000
EXPOSE 5000

# Start both services using a script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]