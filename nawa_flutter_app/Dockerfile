# Use a base image with a recent version of Flutter and Dart SDK
FROM mobiledevops/flutter-sdk-image AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Create a new user and switch to it to avoid running as root
RUN useradd -ms /bin/bash flutteruser

# Ensure correct permissions on .flutter-sdk directory
USER root
RUN chown -R flutteruser:flutteruser /home/mobiledevops/.flutter-sdk

# Ensure correct permissions on .config/flutter directory
RUN mkdir -p /home/mobiledevops/.config/flutter && \
    chown -R flutteruser:flutteruser /home/mobiledevops/.config

# Ensure correct permissions on .pub-cache directory
RUN mkdir -p /home/mobiledevops/.pub-cache && \
    chown -R flutteruser:flutteruser /home/mobiledevops/.pub-cache

# Ensure correct permissions on the working directory
RUN chown -R flutteruser:flutteruser /app

# Switch to non-root user
USER flutteruser

# Upgrade Flutter SDK to the required version
RUN flutter upgrade

# Get dependencies
RUN flutter pub get

# Build the web app
RUN flutter build web

# Use a simple web server to serve the static files
FROM nginx:alpine

# Copy the build output to the web server's root directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Run the web server
CMD ["nginx", "-g", "daemon off;"]
