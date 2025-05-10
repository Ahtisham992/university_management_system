#!/bin/bash

# Print environment check for debugging
echo "Checking environment variables..."

if [ -z "$STRIPE_SECRET_KEY" ]; then
  echo "Warning: STRIPE_SECRET_KEY not set. Setting a placeholder value for testing."
  STRIPE_SECRET_KEY="sk_test_placeholder"
fi

if [ -z "$MONGODB_URI" ]; then
  echo "Warning: MONGODB_URI not set. Setting default URI for testing."
  MONGODB_URI="mongodb+srv://shamimuhammad77:helloAhtisham@cluster1.yvtj5.mongodb.net/UMS?retryWrites=true&w=majority&appName=Cluster0"
fi

if [ -z "$JWT_SECRET" ]; then
  echo "Warning: JWT_SECRET not set. Setting a default JWT secret."
  JWT_SECRET="default_jwt_secret_key"
fi

if [ -z "$CORS_ORIGIN" ]; then
  echo "Warning: CORS_ORIGIN not set. Setting to default frontend URL."
  CORS_ORIGIN="http://localhost:5000"
fi

# Create a local .env file from environment variables
echo "Creating .env file for backend..."
cat > /app/backend/.env <<EOL
NODE_ENV=${NODE_ENV:-production}
MONGODB_URI=${MONGODB_URI}
JWT_SECRET=${JWT_SECRET}
STRIPE_SECRET_KEY=${STRIPE_SECRET_KEY}
CORS_ORIGIN=${CORS_ORIGIN}
EOL

# Create a runtime config for the frontend to access
echo "Creating runtime config for frontend..."
mkdir -p /app/frontend/build
cat > /app/frontend/build/config.js <<EOL
window.ENV = {
  REACT_APP_BASE_URL: 'http://localhost:3000'
};
EOL

# Start backend
echo "Starting backend server on port 3000..."
cd /app/backend && node index.js &
BACKEND_PID=$!

# Start frontend
echo "Starting frontend server on port 5000..."
cd /app && serve -s frontend/build -l 5000 &
FRONTEND_PID=$!

# Wait for both to complete (this ensures container stays running)
wait $BACKEND_PID $FRONTEND_PID