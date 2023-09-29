FROM nginx:stable

COPY configs/frontend-backend.conf /etc/nginx/conf.d

EXPOSE $PORT_NGINX

CMD ["nginx", "-g", "daemon off;"]
