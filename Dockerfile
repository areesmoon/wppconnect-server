# Dockerfile
FROM amun/wppconnect-server
WORKDIR /root/wppconnect-server
EXPOSE 22
EXPOSE 21465
EXPOSE 80
ENTRYPOINT apache2ctl -D BACKGROUND && yarn dev