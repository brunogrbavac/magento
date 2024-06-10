FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common netcat \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y openjdk-11-jdk curl wget git net-tools unzip nano libpng-dev libzip-dev libjpeg-dev libfreetype6-dev 
    
RUN apt-get install -y apache2

COPY magento2.conf /etc/apache2/sites-available/magento2.conf
RUN a2ensite magento2.conf && a2enmod rewrite


RUN apt-get install -y php8.2 libapache2-mod-php8.2 php8.2-common php8.2-gmp php8.2-curl php8.2-soap php8.2-bcmath php8.2-intl php8.2-mbstring php8.2-xmlrpc php8.2-mysql php8.2-gd php8.2-xml php8.2-cli php8.2-zip
COPY php.ini /etc/php/8.2/cli/php.ini
RUN service apache2 restart

RUN apt-get install -y mariadb-client

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


RUN useradd -ms /bin/bash vscode && \
    mkdir -p /home/vscode/.composer && \
    chown -R vscode:vscode /home/vscode

WORKDIR /var/www/html
RUN wget -P /var/www/html https://github.com/magento/magento2/archive/refs/tags/2.4.7.tar.gz

RUN tar -xzvf /var/www/html/2.4.7.tar.gz && \
    mv magento2-2.4.7 magento2 && \
    chown -R www-data:www-data /var/www/html/magento2/ && \
    chmod -R 755 /var/www/html/magento2/

COPY magento-setup.sh /workspace/magento-setup.sh
RUN chmod +x /workspace/magento-setup.sh

EXPOSE 3000

# CMD ["apache2ctl", "-D", "FOREGROUND"]
COPY start.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/start.sh
CMD ["/usr/local/bin/start.sh"]