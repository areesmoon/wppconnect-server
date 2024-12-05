# Dockerfile
# base
FROM node:lts-alpine3.18 AS base
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN apk update && apk add --no-cache vips-dev fftw-dev gcc g++ make libc6-compat chromium nano && rm -rf /var/cache/apk/*

# install node package on stage
FROM base AS stage
WORKDIR /root/wppconnect-server
COPY wppconnect-server/package.json ./
RUN npm install --force && npm cache clean --force

# copy repo and installed packages
FROM base
WORKDIR /root/wppconnect-server
COPY wppconnect-server/ /root/wppconnect-server/
COPY --from=stage /root/wppconnect-server/ /root/wppconnect-server/

# Expose needed port
EXPOSE 21465

# Check & Update wppconnect package
# Run wppconnect-server
ENTRYPOINT echo "Checking WPPConnect update..." && \
  if [ "$(npm outdated | grep '@wppconnect-team/wppconnect' | awk '{print $1}')" = "@wppconnect-team/wppconnect" ]; \
  then \
    echo "Updating WPPConnect..." && npm update @wppconnect-team/wppconnect; \
  else \
    echo "WPPConnect is up to date"; \
  fi && \
  yarn dev