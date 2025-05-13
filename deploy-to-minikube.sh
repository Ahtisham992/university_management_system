#!/bin/bash

# Check if minikube is running
if ! minikube status | grep -q "Running"; then
  echo "Starting Minikube..."
  minikube start
fi

# Set Docker to use Minikube's Docker daemon
eval $(minikube docker-env)

# Set your Docker Hub username - replace with your actual username
export DOCKER_USERNAME="ahtisham05"

# Create namespace if it doesn't exist
kubectl create namespace ums-system --dry-run=client -o yaml | kubectl apply -f -

# Apply MongoDB resources
echo "Deploying MongoDB..."
kubectl apply -f k8s/mongodb/secrets.yaml -n ums-system
kubectl apply -f k8s/mongodb/persistent-volume-claim.yaml -n ums-system
kubectl apply -f k8s/mongodb/deployment.yaml -n ums-system
kubectl apply -f k8s/mongodb/service.yaml -n ums-system

# Wait for MongoDB to be ready
echo "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n ums-system

# Apply Backend resources
echo "Deploying Backend..."
envsubst < k8s/backend/secrets.yaml | kubectl apply -f - -n ums-system
envsubst < k8s/backend/deployment.yaml | kubectl apply -f - -n ums-system
kubectl apply -f k8s/backend/service.yaml -n ums-system

# Wait for Backend to be ready
echo "Waiting for Backend to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/ums-backend -n ums-system

# Apply Frontend resources
echo "Deploying Frontend..."
envsubst < k8s/frontend/deployment.yaml | kubectl apply -f - -n ums-system
kubectl apply -f k8s/frontend/service.yaml -n ums-system

# Wait for Frontend to be ready
echo "Waiting for Frontend to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/ums-frontend -n ums-system

# Get the URL to access the application
echo "Deployment completed successfully!"
echo "You can access your application at:"
minikube service ums-frontend -n ums-system --url

# Display all resources
echo -e "\nDeployed resources:"
kubectl get all -n ums-system