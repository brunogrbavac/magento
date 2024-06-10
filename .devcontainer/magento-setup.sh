#!/bin/bash

# Function to wait for a service to be ready
wait_for_service() {
  local service="$1"
  local host="$2"
  local port="$3"
  echo "Waiting for $service to be ready at $host:$port..."
  until nc -z "$host" "$port"; do
    echo "Waiting for $service to be ready at $host:$port..."
    sleep 5
  done
}

# Wait for MySQL
wait_for_service "MySQL" "db" "3306"

# Wait for Elasticsearch
wait_for_service "Elasticsearch" "elasticsearch" "9200"

# Run Magento setup as www-data
su - www-data -s /bin/bash <<'EOF'
  cd /var/www/html/magento2 && \
  if [ ! -f app/etc/env.php ]; then
    composer install && \
    composer require elasticsearch/elasticsearch:^7.0 && \
    php bin/magento setup:install --base-url=http://localhost:3000/ --db-host=db --db-name=magento2 --db-user=meetanshi --db-password=password --admin-firstname=admin --admin-lastname=admin --admin-email=admin@admin.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --backend-frontname=admin --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200  && \
    php bin/magento setup:store-config:set --base-url=http://localhost:3000/ && \
    php bin/magento setup:store-config:set --base-url-secure=https://localhost:3000/ && \
    php bin/magento maintenance:disable
  else
    echo "Magento is already installed"
  fi
EOF