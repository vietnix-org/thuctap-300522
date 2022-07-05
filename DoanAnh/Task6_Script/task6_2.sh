!#/bin/bash

install_service() {
    echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
    sudo apt-get update -y && sudo apt-get upgrade -y

    echo -e "\n\nInstalling Apache2 Web server\n"
    sudo apt-get install apache2 apache2-utils ssl-cert -y
    sudo systemctl restart apache2

    echo -e "\n\nInstalling PHP & Requirements\n"
    sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https 
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php 
    sudo apt update
    sudo apt-get install libapache2-mod-php7. php7.3 php7.3-common php7.3-mysql php7.3-cli php7.3-fpm -y

    echo -e "\n\nInstalling MySQL\n"
    sudo apt-get install mysql-server mysql-client -y

    echo -e "\n\nRestarting Apache\n"
    sudo service apache2 restart

      echo -e "\n\nPermissions for /var/www\n"
    sudo chmod -R 0755 /var/www/html/
    sudo chown -R www-data:www-data /var/www/
    echo -e "\n\n Permissions have been set\n"

    echo -e "\n\nInstall Nginx Reverse Proxy Server\n"
    sudo apt-get install nginx
    sudo ufw disable

    echo 'Finally Checking status of services'
    echo Apache service is $(systemctl show -p ActiveState --value apache2)
    echo Maria DB service is $(systemctl show -p ActiveState --value mysqld)

    echo LAMP setup installed on ubuntu Successfully
    exit 0

}

nginx_reverse_proxy_check() {
  URL=
  a=nginx
  echo "Input URL of website to check Reverse Proxy: "
  read URL
  RESPONSE_MESSAGE=`curl -S -I ${URL} 2>/dev/null | grep "Server" | awk '{print $2}'`     
  if [ -z "$RESPONSE_MESSAGE" ]; then
    echo "Server not installed Reverse Proxy yet"
    install_nginx_as_rp

  elif [ "$RESPONSE_MESSAGE" == "^nginx$" ]; then
    echo "Server already installed Reverse Proxy"

  else
    echo "WARNING - Server not installed Reverse Proxy yet"
    install_nginx_as_rp
  fi
}


install_nginx_as_rp() {
  # Configuration
  rvdomain=""
  PROXY_IP=""
  PROXY_PORT=""
  WEB_PORT=""
  echo "[ Setup proxy ]"
  echo -n "Enter name of file Reverse-Proxy(/etc/nginx/site_available/....): "
  read rvdomain
  sitesAvailable='/etc/nginx/sites-available/' 
  block=$sitesAvailable$rvdomain.conf
  sudo touch $block
  sudo ln -s $block /etc/nginx/sites-enabled/
  echo -n "Enter Port of Reverse Proxy: "
  read PROXY_PORT
  echo -n "Enter Port of Web Server: "
  read WEB_PORT
  echo -n "Enter IP proxy_pass: "
  read PROXY_IP
  echo "Installing required service..... Wait for second"
  sudo yum -y update >/dev/null 2>&1    
  sudo yum install -y epel-release > /dev/null 2>&1
  sudo yum -y install nginx > /dev/null 2>&1
  sudo systemctl start nginx >/dev/null 2>&1
  sudo systemctl enable nginx >/dev/null 2>&1
  # Set apt proxy settings
  echo "
  server {
      listen $PROXY_PORT;
      server_name _;
      access_log /var/log/nginx/access.log;
      error_log /var/log/nginx/error.log;
      proxy_set_header Host \$host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

      location / {
           proxy_pass http://$PROXY_IP:$WEB_PORT;
      }
  }" > $block
  sudo iptables -t raw -I PREROUTING -p tcp --dport 8080 -j ACCEPT
  
  echo "Reload the Server....."
  sudo nginx -t > /dev/null 2>&1 && sudo service nginx reload >/dev/null 2>&1
  echo "Finished install Reverse Proxy!!!."
}

function menu() {
  echo " ------------  Manage Domain Menu ----------- "
  PS3=" ==> Enter the option: "
  cal=("install_service" "Check reverse-proxy and install (if not)" "secure_mysql" "setup_vhost" "create_vhost" "Exit the program")
  select i in "${cal[@]}"; do
    case $i in
    ${cal[0]})
      echo "You chose Install Service"
      install_service
      ;;

    ${cal[1]})
      echo "You chose Check reverse-proxy and install"
      nginx_reverse_proxy_check
      ;;

    ${cal[2]})
      echo "You chose Secure MySQL"
      ;;

    ${cal[3]})
      echo "You chose Setup VHost"
      ;;

    ${cal[4]})
      echo "You chose Create VHost"
      ;;

    ${cal[5]})
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
  menu

}

main


