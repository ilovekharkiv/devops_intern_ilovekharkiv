FROM nginx:stable

RUN rm /etc/nginx/conf.d/default.conf
COPY configs/frontend-backend.conf /etc/nginx/conf.d

RUN ls -lh /etc/nginx/conf.d/

EXPOSE $PORT_NGINX

CMD ["nginx", "-g", "daemon off;"]
