# Dockerfile
FROM areesmoon/wppconnect-server:v0.0.0
WORKDIR /root/wppconnect-server
EXPOSE 22
EXPOSE 21465
EXPOSE 80
ENTRYPOINT apache2ctl -D BACKGROUND && npm update @wppconnect-team/wppconnect && yarn dev