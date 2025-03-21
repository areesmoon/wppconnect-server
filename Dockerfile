# Dockerfile
# base
FROM node:lts-alpine3.18 AS base
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN apk update && apk add --no-cache git && apk add --no-cache vips-dev fftw-dev gcc g++ make libc6-compat chromium openssh nano && rm -rf /var/cache/apk/*

# Setting openssh
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && ssh-keygen -A
RUN echo "root:root" | chpasswd

# install node package on stage
FROM base AS stage
WORKDIR /root/wppconnect-server
COPY wppconnect-server/package.json ./
RUN npm install --force && npm cache clean --force

# copy repo and installed packages
FROM base
WORKDIR /root
RUN git clone https://github.com/wppconnect-team/wppconnect-server
COPY --from=stage /root/wppconnect-server/ /root/wppconnect-server/

# Change dir to /root/wppconnect-server
WORKDIR /root/wppconnect-server

# Update package @wppconnect-team/wppconnect
RUN echo "Updating WPPConnect..." && npm update @wppconnect-team/wppconnect
RUN echo "WPPConnect updated!"

# Expose needed port
EXPOSE 22
EXPOSE 21465

# Run ssh
# Check & Update wppconnect package
# Run wppconnect-server
ENTRYPOINT /usr/sbin/sshd -e "$@" && \
  echo "Checking WPPConnect update..." && \
  if [ "$(npm outdated | grep '@wppconnect-team/wppconnect' | awk '{print $1}')" = "@wppconnect-team/wppconnect" ]; \
  then \
    echo "Updating WPPConnect..." && npm update @wppconnect-team/wppconnect; \
  else \
    echo "WPPConnect is up to date"; \
  fi && \
  yarn dev