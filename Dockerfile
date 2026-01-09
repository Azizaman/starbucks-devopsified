# -----------------------------
# Stage 1: Build React App
# -----------------------------
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files first (layer caching)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build production-ready React app
RUN npm run build


# -----------------------------
# Stage 2: Serve with Nginx
# -----------------------------
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy React build from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx config (optional but recommended)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]





