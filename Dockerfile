# Use an official nginx image to serve static files
FROM nginx:alpine

# Copy your application files to the container
COPY ./2048 /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80
