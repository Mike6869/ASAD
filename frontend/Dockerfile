FROM registry.red-soft.ru/ubi7/nodejs-18:latest AS build

WORKDIR /app
ENV STAND_MODE=1

COPY ["package.json", "package-lock.json*", "./"]
RUN npm config set fetch-retries 5 &&  \
    npm config set fetch-retry-mintimeout 600000 &&  \
    npm config set fetch-retry-maxtimeout 1200000 &&  \
    npm config set fetch-timeout 1800000 &&  \
    npm install

COPY . .

RUN npm run build

FROM registry.red-soft.ru/ubi7/ubi-minimal:latest

RUN microdnf install nginx gettext -y && rm -r /usr/share/nginx/html/* && mkdir -p /usr/share/nginx/html/static/

WORKDIR /usr/share/nginx/html

COPY --from=build /app/dist .

COPY nginx/nginx.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx/entrypoint.sh .

RUN chmod +x entrypoint.sh
EXPOSE 80

CMD ["sh",  "entrypoint.sh"]
