FROM debian:buster

RUN apt-get update
RUN apt-get install -y apache2
ADD index.html /var/www/html
CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80/tcp
