function menu {
echo -e "Manage Domain Menu"
echo -e "1. Install_service"
echo -e "2. Start_service"
echo -e "3. Secure_mysql"
echo -e "4. Setup_vhost"
echo -e "5. Create_vhost"
echo -e "6. Exit"
echo -en "Enter option"

read -b 1 option
}


### Check if Server is installed Reverse-proxy yet??
reversePath='etc/nginx/sites-enabled/'


### Set default parameters
action=$1
domain=$2
rootDir=$3
exitsConf=$4
owner=$(who am i | awk '{print $1}')
email='tidiay@gmail.com'
sitesEnable='/etc/httpd/sites-enabled/'
sitesAvailable='/etc/httpd/sites-available/'
userDir='/var/www/'


if [ "$exitsConf" == "" ]; then
      conf=$domain
    else
      conf=$exitsConf
    fi
    

sitesAvailabledomain=$sitesAvailable$conf.conf    


if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo" 
		exit 1;
fi




menu
case $option in
0)
break;;

1)
abc;;


2)