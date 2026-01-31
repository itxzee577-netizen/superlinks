# Vercel Deployment Guide for Social Media Manager

This guide explains how to deploy the Social Media Manager application on Vercel.

## Architecture Overview

The Social Media Manager consists of two main parts:
1. **Frontend (Client)**: React application (deployed on Vercel)
2. **Backend (Server)**: Node.js/Express API (deployed on Vercel)

## Deployment Strategy

Due to Vercel's architecture, we'll need to deploy the frontend and backend separately, with the frontend connecting to the deployed backend API.

## Step 1: Deploy the Backend API

### 1.1 Prepare the Backend for Vercel

First, let's create a Vercel API route structure for the backend:

```
api/
├── auth/
│   ├── register.js
│   ├── login.js
│   └── me.js
├── campaigns/
│   ├── index.js
│   ├── [id].js
│   └── [id]/status.js
├── users/
│   └── index.js
├── analytics/
│   └── index.js
└── index.js
```

Let me create the main API handler:

**api/index.js**
```javascript
export default function handler(req, res) {
  res.status(200).json({ 
    message: 'Social Media Manager API', 
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      campaigns: '/api/campaigns',
      users: '/api/users',
      analytics: '/api/analytics'
    }
  });
}
```

**api/auth/login.js**
```javascript
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { connectToDatabase } from '../../lib/db'; // You'll need to implement this
import User from '../../models/User';

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ 
      success: false,
      error: { 
        code: 'MISSING_FIELDS',
        message: 'Email and password are required' 
      }
    });
  }

  try {
    await connectToDatabase();
    const user = await User.findOne({ email }).lean();

    if (!user) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'INVALID_CREDENTIALS',
          message: 'Invalid email or password'
        }
      });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'INVALID_CREDENTIALS',
          message: 'Invalid email or password'
        }
      });
    }

    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.JWT_SECRET || 'fallback_secret',
      { expiresIn: '7d' }
    );

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        isVerified: user.isVerified
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Login failed'
      }
    });
  }
}
```

For brevity, I won't create all the API routes here, but you would need to convert each route from the Express app to individual Vercel API routes.

## Step 2: Deploy the Frontend

### 2.1 Environment Configuration

Create a `.env.local` file in the client directory:

```
REACT_APP_API_URL=https://your-backend-vercel-url.vercel.app
```

### 2.2 Update API Calls

Update the axios instance in the frontend to use the environment variable:

```javascript
// In your api client file
import axios from 'axios';

const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL || 'http://localhost:5000',
});

export default api;
```

## Step 3: Vercel Configuration

### 3.1 Frontend vercel.json
```json
{
  "version": 2,
  "name": "social-media-manager-client",
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "build"
      }
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ],
  "env": {
    "REACT_APP_API_URL": "https://your-backend-vercel-url.vercel.app"
  }
}
```

## Alternative Approach: Monorepo with Separate Deployments

Since deploying both frontend and backend on Vercel requires separate projects, consider this approach:

1. Create a separate Git repository for the backend
2. Deploy the backend to Vercel first
3. Deploy the frontend to Vercel second, with the backend URL configured

## Prerequisites for Deployment

1. Install Vercel CLI: `npm i -g vercel`
2. Have a MongoDB Atlas account for production database
3. Set up environment variables in Vercel dashboard:
   - `MONGODB_URI`: Your MongoDB connection string
   - `JWT_SECRET`: Your JWT secret key
   - `NEXT_PUBLIC_API_URL`: The URL of your deployed backend (for frontend)

## Deployment Commands

### For Backend:
```bash
cd social-media-manager/server
vercel --prod
```

### For Frontend:
```bash
cd social-media-manager/client
npm run build
vercel --prod
```

## Production Environment Variables

Set these in your Vercel project settings:

**Backend:**
- `MONGODB_URI`: MongoDB connection string
- `JWT_SECRET`: Secret for JWT tokens
- `NODE_ENV`: production

**Frontend:**
- `NEXT_PUBLIC_API_URL`: Your backend API URL

## Important Notes

1. Vercel's serverless functions have execution time limits (max 10 seconds for hobby, 60 seconds for pro)
2. Database connections should be managed efficiently due to cold starts
3. Consider using Vercel's KV or other persistent storage for session management if needed
4. The application is designed to be compliant with social media platform terms of service