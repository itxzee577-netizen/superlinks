# Social Media Manager - Vercel Deployment

This guide explains how to deploy the Social Media Manager application on Vercel.

## Overview

The Social Media Manager is a full-stack application consisting of:
- A React frontend for the user interface
- A Node.js/Express API backend for data processing
- MongoDB for data storage

For Vercel deployment, we've structured the application to work with Vercel's serverless functions.

## Prerequisites

Before deploying, you'll need:

1. A [Vercel account](https://vercel.com/signup)
2. A [MongoDB Atlas account](https://www.mongodb.com/atlas) for the database
3. Node.js installed locally (for testing)

## Deployment Steps

### 1. Fork/Clone the Repository

```bash
git clone https://github.com/your-username/social-media-manager.git
cd social-media-manager
```

### 2. Install Dependencies

```bash
npm run setup
```

### 3. Set Up Environment Variables

Create a `.env.local` file in the root directory with the following variables:

```env
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret_key
```

### 4. Deploy to Vercel

#### Option A: Using Vercel CLI

1. Install the Vercel CLI:
```bash
npm install -g vercel
```

2. Deploy the project:
```bash
vercel
```

Follow the prompts to link your project to your Vercel account.

#### Option B: Using Vercel Dashboard

1. Go to [vercel.com](https://vercel.com)
2. Click "New Project"
3. Import your GitHub repository
4. Vercel will automatically detect this is a Node.js project
5. Add your environment variables in the dashboard
6. Click "Deploy"

### 5. Configure Environment Variables in Vercel

Go to your project dashboard in Vercel and add these environment variables:

**Production Environment:**
- `MONGODB_URI`: Your MongoDB connection string
- `JWT_SECRET`: A strong secret key for JWT tokens

## Frontend Configuration

The frontend (React app) needs to know the URL of the deployed backend API. 

1. In your Vercel project settings for the frontend, add:
```
REACT_APP_API_URL=https://your-backend-project-name.vercel.app
```

2. Update the frontend's `.env.production` file accordingly

## API Routes

The backend exposes the following API routes:

- `GET /api/` - API root endpoint
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/campaigns` - Get all campaigns
- `POST /api/campaigns` - Create a new campaign
- `GET /api/campaigns/[id]` - Get a specific campaign
- `PUT /api/campaigns/[id]` - Update a campaign
- `DELETE /api/campaigns/[id]` - Delete a campaign
- `PATCH /api/campaigns/[id]/status` - Update campaign status

## Database Connection

The application uses MongoDB with Mongoose for database operations. In production, it's recommended to use MongoDB Atlas for a managed database service.

Connection pooling and caching are implemented to optimize database connections in the serverless environment.

## Security Considerations

- JWT tokens are used for authentication
- Input validation is performed on all endpoints
- Passwords are hashed using bcrypt
- Rate limiting should be implemented based on your needs
- CORS is configured for security

## Scaling Considerations

- Vercel's serverless functions scale automatically
- Database connection pooling is implemented
- For heavy loads, consider using Vercel's dedicated instances
- Monitor database connection limits with MongoDB Atlas

## Troubleshooting

### Common Issues:

1. **Database Connection Issues**: Ensure your MongoDB connection string is correct and the database is accessible from the internet.

2. **Environment Variables**: Verify all required environment variables are set in both local and Vercel environments.

3. **Cold Starts**: Serverless functions may have slight delays on first request after inactivity.

### Logs:
Check the Vercel dashboard for function logs to debug issues.

## Updating the Deployment

To update your deployed application:

1. Make changes to your code
2. Commit and push to your repository
3. Vercel will automatically redeploy your application

Or manually deploy using:
```bash
vercel --prod
```

## Custom Domain

To add a custom domain:

1. Go to your project settings in the Vercel dashboard
2. Navigate to the "Domains" section
3. Add your custom domain and follow DNS configuration instructions

## Support

For issues with the deployment, check:

1. Vercel function logs
2. Database connectivity
3. Environment variables
4. Frontend API URL configuration

The application follows modern best practices for serverless deployment while maintaining all functionality of the original application.