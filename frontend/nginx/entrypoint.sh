envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && \
    cp index.html base_index.html && \
    envsubst < /usr/share/nginx/html/base_index.html > /usr/share/nginx/html/index.html && \
    rm base_index.html && \
    nginx -g 'daemon off;'