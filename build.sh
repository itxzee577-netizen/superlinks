#!/bin/bash

# Build script for Social Media Manager deployment

echo "Building Social Media Manager for Vercel deployment..."

# Navigate to client directory and build
echo "Building client application..."
cd client

# Install dependencies
npm install

# Build the React app
npm run build

if [ $? -eq 0 ]; then
    echo "Client build successful!"
else
    echo "Client build failed!"
    exit 1
fi

# Go back to root
cd ..

echo "Preparing serverless functions..."
echo "All API routes are ready in the /api directory"

echo "Deployment preparation complete!"
echo ""
echo "To deploy to Vercel:"
echo "1. Make sure you have the Vercel CLI installed: npm install -g vercel"
echo "2. Run: vercel from the root directory"
echo "3. Set environment variables in the Vercel dashboard:"
echo "   - MONGODB_URI: Your MongoDB connection string"
echo "   - JWT_SECRET: Your JWT secret key"
echo ""
echo "For frontend deployment, set REACT_APP_API_URL to your backend URL"