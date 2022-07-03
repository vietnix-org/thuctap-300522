#!/bin/bash

install_nginx_as_rp() {
  # Configuration
  domain=""
  PROXY_HOST=""
  PROXY_USER=""
  PROXY_PASSWORD=""
  PROXY_PORT=""
  block="/etc/ngix/sites-available/$domain"

  echo "[ Setup proxy ]"
  echo -n "Domain:"
  read domain
  echo -n "Host: "
  read PROXY_HOST
  echo -n "Port: "
  read PROXY_PORT
  echo -n "Username: "
  read PROXY_USER
  echo -n "Password: "
  read -s PROXY_PASSWORD
  echo "Updating home dir"
  sudo mkdir -p /home/$PROXY_USER

  echo_statement "Configuring NGINX reverse proxy server"
  sudo apt-get install epel-realease nginx
  sudo apt-get install nginx-full -y

  # Set apt proxy settings
  "server {
      listen $PROXY_PORT;
      server_name $domain;
      access_log /var/log/nginx/access.log;
      proxy_set_header Host '$host';
      proxy_set_headerr X-Real-IP '$remote_addr';
      proxy_set_header X-Forwarded-For '$proxy_add_x_forwarded_for';

      location / {
           proxy pass http://$PROXY_IP:$PROXY_PORT;
      }
 }
"

  echo "$apt_conf_proxy" | sudo tee -a $block >/dev/null
  echo ""
  sudo ln -s $block /etc/nginx/sites-enabled/

  echo "Reload the Server"
  sudo nginx -t && sudo service nginx reload

  echo "Proxy enabled."
}

nginx_reverse_proxy_check() {
  URL=
  echo "Input URL of website to check Reverse Proxy: "
  read URL
  RESPONSE_MESSAGE=`curl -S -I ${URL} 2>/dev/null | grep "Server" | awk '{print $2}'`
  if [ -z "$RESPONSE_MESSAGE" ]; then
    echo "Server not installed Reverse Proxy yet"
    install_nginx_as_rp

  elif [ "$RESPONSE_MESSAGE"=="nginx"* ]; then
    echo "Server already installed Reverse Proxy"

  else
    echo "WARNING - Server not installed Reverse Proxy yet"
    install_nginx_as_rp

  fi
}

create_new_domain() {
  name=
  WEB_ROOT_DIR=
  IP=
  user=
  group=
  echo "Enter name user of Domain : "
  read user
  sudo useradd $user
  echo "Enter a name of Domain: "
  read name
  echo "Enter a root directory of Domain(home/'$user'/...): "
  read WEB_ROOT_DIR
  echo "Enter the IP of Domain: "
  read IP
  
  sitesEnabled='/etc/httpd/sites-enabled/'
  sitesAvailable='/etc/httpd/sites-available/'
  sitesAvailableDomain=$sitesAvailable$name.conf
  sudo mkdir -p $sitesEnabled
  sudo mkdir -p $sitesAvailable
  sudo mkdir -p $WEB_ROOT_DIR
  sudo chown -R $user: $WEB_ROOT_DIR
  sudo touch $sitesAvailableDomain
  sudo sed -i '$a'$IP'\t'$name'' /etc/hosts
  echo "Creating a vhost for $sitesAvailableDomain with a webroot $WEB_ROOT_DIR"
  sudo sed -i '$aIncludeOptional sites-enabled/*.conf' /etc/httpd/conf/httpd.conf

  ### create virtual host rules file
  echo "
    <VirtualHost *:80>
      ServerName $name
      DocumentRoot $WEB_ROOT_DIR
      <Directory $WEB_ROOT_DIR/>
        Options Indexes FollowSymLinks
        AllowOverride all
      </Directory>
      <Directory />
        Options -Indexes +FollowSymLinks +MultiViews
        AllowOverride All
        Require all granted
      </Directory>
    </VirtualHost>" > $sitesAvailableDomain
  echo -e $"\nNew Virtual Host Created\n"
  sudo ln -s /etc/httpd/$sitesAvailableDomain $sitesEnabled
  sudo systemctl restart httpd 2> /dev/null
  echo "Done, please browse to http://$name to check!"\
  echo ""
  menu
}

# Start_service
start_service() {
  sudo systemctl start apache2
  sudo systemctl enable apache2
  sudo systemctl start nginx
  sudo systemctl enable nginx
  sudo systemctl start mysqld 2>/dev/null

}


function menu() {
  echo " ------------  Manage Domain Menu ----------- "
  PS3=" ==> Enter the option: "
  cal=("Create new Domain" "Start_service" "Secure_mysql" "Exit the program")
  select i in "${cal[@]}"; do
    case $i in
    ${cal[0]})
      echo "You chose Install create new Domain"
      create_new_domain
      ;;

    ${cal[1]})
      echo "You chose Start service "
      ;;

    ${cal[2]})
      echo "You chose Secure MySQL "
      ;;

    ${cal[3]})
      echo "Exiting the program...."
      break
      ;;

    *)
      echo "Option no valadition!!"
      ;;
    esac
  done
}

main() {
  nginx_reverse_proxy_check
  menu

}

main
