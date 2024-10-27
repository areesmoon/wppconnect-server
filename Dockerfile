# Dockerfile
FROM areesmoon/wppconnect-server:v0.0.0
COPY --chown=www-data:www-data html/ /var/www/html/
RUN rm -f /var/www/html/index.html
WORKDIR /root/wppconnect-server
EXPOSE 22
EXPOSE 21465
EXPOSE 80
ENTRYPOINT apache2ctl -D BACKGROUND && yarn dev