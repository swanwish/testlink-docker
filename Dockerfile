FROM otechlabs/base

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends nginx php5-cgi php5-mysql php5-curl php5-gd php5-json php5-ldap mysql-client

ADD php.ini /etc/php5/cgi/php.ini
ADD nginx.conf /etc/nginx/nginx.conf
ADD fastcgi_params /etc/nginx/fastcgi_params
ADD php-fastcgi /etc/default/php-fastcgi
ADD php.init /etc/init.d/php-fastcgi
ADD setup-db.sh /etc/init.d/setup-db.sh
RUN chmod +x /etc/init.d/php-fastcgi

RUN mkdir -p /var/www && \
    wget -qO- -O /testlink.tar.gz "http://downloads.sourceforge.net/project/testlink/TestLink%201.9/TestLink%201.9.13/testlink-1.9.13.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ftestlink%2Ffiles%2FTestLink%25201.9%2FTestLink%25201.9.12%2F&ts=1424233417&use_mirror=jaist" && \
    tar -zxf /testlink.tar.gz -C /var/www/ && \
    mv /var/www/testlink-1.9.13 /var/www/testlink && \
    rm -f /testlink.tar.gz 

RUN mkdir -p /var/testlink/logs /var/testlink/upload_area && \
    chown www-data:www-data /var/testlink/ -R && \
    chown www-data:www-data /var/www/testlink/gui/templates_c

EXPOSE 80

CMD sh /etc/init.d/setup-db.sh ; /etc/init.d/php-fastcgi start ; /usr/sbin/nginx -c /etc/nginx/nginx.conf
