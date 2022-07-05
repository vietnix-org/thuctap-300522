!#/bin/bash

install_service() {
  echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
  sudo apt-get update -y && sudo apt-get upgrade -y

  echo -e "\n\nInstalling Apache2 Web server\n"

  sudo apt-get install apache2 apache2-utils
  sudo systemctl restart apache2
  sudo systemctl enable apache2

  echo -e "\n\nInstalling PHP & Requirements\n"
  sudo apt install software-properties-common apt-transport-https -y
  sudo add-apt-repository ppa:ondrej/php -y
  sudo apt update
  sudo apt upgrade
  sudo apt install php7.4-fpm php7.4-common libapache2-mod-fcgid php7.4-cli php7.4-gd php7.4-curl php7.4-dev php7.4-xml php7.4-xmlrpc
  sudo a2enmod proxy_fcgi setenvif && sudo a2enconf php7.4-fpm

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
  echo MYSQL service is $(systemctl show -p ActiveState --value mysqld)

  echo LAMP setup installed on ubuntu Successfully
  exit 0

}

nginx_reverse_proxy_check() {
  URL=
  a=nginx
  echo "Input URL of website to check Reverse Proxy: "
  read URL
  RESPONSE_MESSAGE=$(curl -S -I ${URL} 2>/dev/null | grep "Server" | awk '{print $2}')
  if [ -z "$RESPONSE_MESSAGE" ]; then
    echo -e "Server not installed Reverse Proxy yet\n"
    install_nginx_as_rp

  elif [ "$RESPONSE_MESSAGE" == "^nginx$" ]; then
    echo -e "Server already installed Reverse Proxy\n"

  else
    echo -e "WARNING - Server not installed Reverse Proxy yet\n"
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
  echo -n "Enter name of file Reverse-Proxy(/etc/nginx/site_available/___.conf): "
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
  sudo yum install -y epel-release >/dev/null 2>&1
  sudo yum -y install nginx >/dev/null 2>&1
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
  }" | sudo tee -a $block
  echo "Listen 8080" | sudo tee /etc/apache2/ports.conf >/dev/null 2>&1
  sudo iptables -t raw -I PREROUTING -p tcp --dport 80 -j ACCEPT
  sudo iptables-save >/dev/null 2>&1
  echo "Reload the Server....."
  sudo nginx -t && sudo service nginx reload
  echo "Finished install Reverse Proxy!!!."
}

create_databases() {

  Q1="CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
  Q2="CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
  Q3="GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
  Q4="FLUSH PRIVILEGES;"
  SQL="${Q1}${Q2}${Q3}${Q4}"

  echo "Please enter root user MySQL password!"
  read rootPassword
  mysql -u root -p${rootPassword} -e "$SQL"

  echo "MySQL DB / User creation completed!"
  echo " >> Host      : ${DB_HOST}"
  echo " >> Database  : ${DB_NAME}"
  echo " >> User      : ${DB_USER}"
  echo " >> Pass      : ${DB_PASS}"

}

create_user_group() {
  echo "Enter a new user: "
  read USERNAME
  echo "Enter a new group for user: "
  read USERGROUP

  groupadd $USERGROUP
  useradd -d /home/$USERNAME -g $USERGROUP -s /bin/bash -m $USERNAME
  passwd $USERNAME
  id $USERNAME

  echo "Add a user successfully"
}

setup_vhost() {


}



create_new_domain() {
  name=
  IP=
  user=
  group=
  echo "Enter name user of Domain : "
  read user
  #sudo useradd $user
  echo "Enter a name of Domain: "
  read name
  WEB_ROOT_DIR='/home/'$user'/'
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
<VirtualHost *:8080>
      ServerName $name
      DocumentRoot $WEB_ROOT_DIR$name
      access_log /var/log/httpd/access.log
      error_log /var/log/httpd/error.log
      <Directory $WEB_ROOT_DIR>
        Options -Indexes +FollowSymLinks +MultiViews
        AllowOverride All
        Require all granted
      </Directory>
</VirtualHost>" >$sitesAvailableDomain
  echo -e $"\nNew Virtual Host Created\n"
  sudo ln -s $sitesAvailableDomain $sitesEnabled
  sudo systemctl restart httpd 2>/dev/null
  echo "Done, please browse to http://$name to check!"

}

function menu() {
  PS3=" ===> Enter the option: "
  cal=("install_service" "Check reverse-proxy and install (if not)" "secure_mysql" "setup_vhost" "create_vhost" "Exit the program")
  echo " ------------  Manage Domain Menu ----------- "
  select i in "${cal[@]}"; do
    case $i in
    ${cal[0]})
      echo -e "You chose Install Service\n"
      install_service
      menu
      ;;

    ${cal[1]})
      echo -e "You chose Check reverse-proxy and install\n"
      nginx_reverse_proxy_check
      ;;

    ${cal[2]})
      echo -e "You chose Secure MySQL\n"

      ;;

    ${cal[3]})
      echo -e "You chose Setup VHost\n"
      ;;

    ${cal[4]})
      echo -e "You chose Create VHost\n"
      ;;

    ${cal[5]})
      echo "Exiting the program...."
      break
      ;;

    *)
      echo -e "Option no valadition!!\n"
      ;;
    esac
    REPLY=
  done
}

main() {
  menu

}

main
