FROM nginx
MAINTAINER guojing
VOLUME /tmp
ENV LANG en_US.UTF-8
RUN echo "server {  \
                      listen       80; \
                  #解决Router(mode: 'history')模式下，刷新路由地址不能找到页面的问题 \
                  location / { \
                     root   /var/www/html/; \
                      try_files $uri $uri/ /index.html; \
                      index  index.html index.htm; \
                  } \
                  location /prod-api/ { \
                  			proxy_set_header Host $http_host; \
                  			proxy_set_header X-Real-IP $remote_addr; \
                  			proxy_set_header REMOTE-HOST $remote_addr; \
                  			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \
                  			proxy_pass http://gateway.yixiuge.pub/; \
                  		}\
                  access_log  /var/log/nginx/access.log ; \
              } " > /etc/nginx/conf.d/default.conf \
    &&  mkdir  -p  /var/www \
    &&  mkdir -p /var/www/html

ADD dist/ /var/www/html/
EXPOSE 80
EXPOSE 443
