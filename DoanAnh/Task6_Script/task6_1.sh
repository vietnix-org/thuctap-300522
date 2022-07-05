#!/bin/bash

install_nginx_as_rp() {
  # Configuration
  rvdomain=""
  PROXY_IP=""
  PROXY_PORT=""
  WEB_PORT=""
  echo "[ Setup proxy ]"
  echo -n "Enter name of file Reverse-Proxy(/etc/nginx/site_available/....): "
  read rvdomain
  sudo mkdir -p /etc/nginx/sites-available/
  sudo mkdir -p /etc/nginx/sites-enabled/
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

create_new_domain() {
  name=
  IP=
  user=
  group=
  echo "Enter name user of Domain : "
  read user
  sudo useradd $user
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
<<<<<<< HEAD
<VirtualHost *:8080>
=======
<VirtualHost *:80>
>>>>>>> origin/doananh
      ServerName $name
      DocumentRoot $WEB_ROOT_DIR$name
      access_log /var/log/httpd/access.log
      error_log /var/log/httpd/error.log
      <Directory $WEB_ROOT_DIR>
        Options -Indexes +FollowSymLinks +MultiViews
        AllowOverride All
        Require all granted
      </Directory>
</VirtualHost>" > $sitesAvailableDomain 
  echo -e $"\nNew Virtual Host Created\n"
  sudo ln -s $sitesAvailableDomain $sitesEnabled
  sudo systemctl restart httpd 2> /dev/null
  echo "Done, please browse to http://$name to check!"

<<<<<<< HEAD
=======
  menu
>>>>>>> origin/doananh
}

# Start_service
start_service() {
  sudo systemctl start httpd 2>/dev/null
  sudo systemctl enable httpd
  sudo systemctl start nginx 2>/dev/null
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
