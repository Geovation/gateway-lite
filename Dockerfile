# Example
#
# ```
# export DOCKER_ID_USER="thejimmyg"
# docker login
# docker build . -t "$DOCKER_ID_USER/gateway-lite:0.1.0"
# docker push "$DOCKER_ID_USER/gateway-lite:0.1.0"
# docker tag "$DOCKER_ID_USER/gateway-lite:0.1.0" "$DOCKER_ID_USER/gateway-lite:latest"
# docker push "$DOCKER_ID_USER/gateway-lite:latest"
# ```


FROM node:alpine as base

FROM base as builder
RUN mkdir /app
WORKDIR /app
COPY package.json /app
COPY package-lock.json /app
RUN npm install

FROM base
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 8000
EXPOSE 3000
ENV NODE_PATH=/app/node_modules
ENV PORT=8000
ENV DEFAULT_DOMAIN=www.example.com
ENV HTTPS_PORT=3000
ENV NODE_ENV=production
ENV PATH="${PATH}:/app/node_modules/.bin"
COPY bin/ /app/bin/
ENTRYPOINT ["node", "bin/gateway-lite.js"]
CMD = []