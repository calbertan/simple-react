FROM node:alpine AS build

WORKDIR /usr/src/app

#installs dependencies
# * means install all files that start with package
COPY ./package*.json ./

RUN npm install -g npm@6
RUN npm i -react-scripts

COPY . .

RUN npm run build

### Caddy
FROM caddy:2.4.5-alpine
RUN mkdir /srv/www
COPY Caddyfile /srv/www
RUN caddy fmt /srv/www/Caddyfile --overwrite
COPY --from=build /usr/src/app/build/ /srv/www
COPY ./src/config.js /srv/www

# RUN caddy 
RUN chmod -R 775 /srv/*
EXPOSE 2015

CMD ["/usr/bin/caddy", "run", "--config", "/srv/www/Caddyfile"]