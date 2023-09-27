# ----------------------------
# build from source
# ----------------------------
FROM node:18 AS build

WORKDIR /app

COPY package*.json .
RUN npm install

COPY . .
RUN npm run build

# ----------------------------
# run with nginx
# ----------------------------
FROM nginx:stable

RUN rm /etc/nginx/conf.d/default.conf
COPY /nginx/frontend.conf /etc/nginx/conf.d
COPY --from=build /app/dist/frontend /usr/share/nginx/html

EXPOSE $PORT_FRONTEND
