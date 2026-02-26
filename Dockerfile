# --- Stage 1: The "builder" stage ---
# Use a full Node.js image to build our app
FROM node:18-alpine AS builder
# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install all dependencies (including devDependencies)
RUN npm install

# Copy the rest of the application source code
COPY . .

# (If your project has a build step, e.g., TypeScript, add it here)
# RUN npm run build

# --- Stage 2: The "production" stage ---
# Start from a fresh, lightweight base image
FROM node:18-alpine
WORKDIR /app

# Copy the package.json and install *only* production dependencies
COPY package*.json ./
RUN npm install --production

# Copy the built app code from the "builder" stage
COPY --from=builder /app/src ./src
# (If you had a build step, you would copy the 'dist' folder instead)
# COPY --from=builder /app/dist ./dist
# Expose the port the app listens on (check your app's code, e.g., server.js)
EXPOSE 3000

# The command to run the application (check your package.json 'start' script)
CMD [ "npm", "start" ]