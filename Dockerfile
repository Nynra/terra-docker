# This is the multistage build for the terra docker image
# This image is used to run the server needed to generate terra routes
# We need:
# 1. Node.js to run the server
# 2. body-parser to parse the request body
# 3. express to create the server
# 4. cors to allow cross-origin requests
# 5. node-fetch to make requests to the GPT API

# Stage 1: Build the server
FROM node:14.17.0-alpine3.13 AS build

WORKDIR /terra
COPY /terra/App/package*.json ./
RUN npm install --silent body-parser express cors node-fetch
COPY /terra/App .

# Stage 2: Run the server
FROM node:14.17.0-alpine3.13
WORKDIR /terra
COPY --from=build /terra .

# Expose the port
EXPOSE 3000

# Define the environment variable
ARG GPT_API_KEY
ARG MAPS_API_KEY
ENV PORT=3000
ENV GPT_API_KEY="YOUR_GPT_API_KEY"
ENV MAPS_API_KEY="YOUR_MAPS"

# Run the server
CMD ["node", "server.js"]
