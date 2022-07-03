#!/bin/bash

install_nginx_as_rp(){
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
     sudo mkdir /home/$PROXY_USER

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
           proxy pass http://$PROXY_IP:$PROXY_POST;
      }
 }
"

 echo "$apt_conf_proxy" | sudo tee -a $block > /dev/null

 echo ""
 sudo ln -s $block /etc/nginx/sites-enabled/
 
 echo "Reload the Server"
 sudo nginx -t && sudo service nginx reload
 
 echo "Proxy enabled."
}


nginx_reverse_proxy_check(){
        echo "Input URL of website to check Reverse Proxy: "
        read URL
        RESPONSE_MESSAGE=`curl -S -I ${URL} 2> /dev/null | grep "Server" | awk '{print $2}'`
        if [ -z "$RESPONSE_MESSAGE" ] 
        then
            echo "Server not installed Reverse Proxy yet"
            install_nginx_as_rp
         
        elif [ "$RESPONSE_MESSAGE"=="nginx"* ] 
        then
            echo "Server already installed Reverse Proxy - ${RESPONSE_MESSAGE}"
           
        else
            echo "WARNING - Server not installed Nginx Reverse Proxy yet"
            install_nginx_as_rp
            
        fi
}


create_new_domain(){
name=
WEB_ROOT_DIR=
IP=

echo "Enter a name of Domain"
read name
     echo "Enter a root directory of Domain: "
     read WEB_ROOT_DIR
     echo "Enter the IP of Domain: "
     read IP

 sitesEnable='/etc/apache2/sites-enabled/'
 sitesAvailable='/etc/apache2/sites-available/'
 sitesAvailabledomain=$sitesAvailable$name.conf
 echo "Creating a vhost for $sitesAvailabledomain with a webroot $WEB_ROOT_DIR"

 ### create virtual host rules file
 echo "
    <VirtualHost *:80>
      ServerName $name'$host';
      <Directory $WEB_ROOT_DIR/>
        Options Indexes FollowSymLinks
        AllowOverride all
      </Directory>
    </VirtualHost>" > $sitesAvailabledomain
 echo -e $"\nNew Virtual Host Created\n"

 sudo tee -a $IP $name\n > /etc/hosts

 sudo a2ensite $name
 service apache2 reload

 echo "Done, please browse to http://$name to check!"       

}

# Start_service 
start_service(){
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl start mysqld 2> /dev/null

}
function menu() {
echo " ------------  Manage Domain Menu ----------- "
PS3=" ==> Enter the option: "
cal=("Install_service" "Start_service" "Secure_mysql" "Setup_vhost" "Create_vhost" "Exit_the_program")
select i in "${cal[@]}" ; do
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
      echo "You chose Setup VHost "
      ;;

    ${cal[4]}) 
      echo "You chose Create VHost "
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
  nginx_reverse_proxy_check
  menu

}

main