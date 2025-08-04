# Build stage
FROM node:20 AS build-stage
WORKDIR /app
COPY . ./
RUN npm install
RUN npm run build

# Production stage
FROM nginx:alpine AS production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
