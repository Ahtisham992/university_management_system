#!/bin/bash

# Get the backend service URL
BACKEND_URL=$(minikube service ums-backend -n ums-system --url)

# Create .env file with the dynamic URL
echo "REACT_APP_BASE_URL=$BACKEND_URL" > .env.local

# Start the React application
npm start