#!/bin/bash

### Set default parameters
action=$1
domain=$2
rootDir=$3
exitsConf=$4
owner=$(who am i | awk '{print $1}')
email='tidiay@gmail.com'

DEFAULT_SERVERIP=
DEFAULT_SERVERPORT="80"
NGINX_USER=
NGINX_DIR='/etc/nginx'
NGINX_SSL_DIR='/etc/nginx/ssl'
NGINX_VHOST_DIR='/etc/nginx/sites-available'
NGINX_VHOST_SITE_ENABLED_DIR='/etc/nginx/sites-enabled'
NGINX_TEMPLATE=""
PHP_FPM_POOL_DIR='/etc/php5/fpm/pool.d'
PHP_FPM_SOCK_DIR='/var/lib/php5-fpm'
PHP_FPM_RUN_SCRIPT='/etc/init.d/php5-fpm'
#PHP_DEFAULT_VERSION_DEBIAN=7.3
#PHP_DEFAULT_VERSION_DEBIAN=7.0
DEFAULT_SITE_DIR='/var/www'
DEFAULT_TEMPLATE_DIR='/etc/nginx/template'

### Check if Server is installed Reverse-proxy yet??
check_if_server_installed_rp(){
  echo -en "$Checking if Reverse Proxy is already installed ...\t\t\t"
  reversePath='etc/nginx/sites-enabled/'
  #for file in reversePath
}

check_root_user() {
CURRENT_USER=$(whoami)
if [[ "${CURRENT_USER}" = "root" ]]; then
	_logging "[CHECK] Checking your privileges... OK"
else
	_logging "[ERROR] root access is required."
	_logging "[END] Script '${SCRIPT_DIR}/${SCRIPT_NAME}'"
	exit 1
fi
}


function install_service() 
{
    create_linux_user_and_group() 
    {
      command_exists () {
	      type "${1}" &> /dev/null ;
      }

      user_in_group(){
	      groups "${1}" | grep "$2" >/dev/null 2>&1
      }

      user_exists() {
	      id -u "${1}" &> /dev/null;
      }
      local USERLOGINNAME="${1}"
	    local GROUPNAME="${2}"
	    local USER_CNT=1
	    local GROUP_CNT=1
      echo -en "Adding new user '${USERLOGINNAME}'...\t\t\t"
	    USER_CNT=$(getent passwd | grep -c "${USERLOGINNAME}")
	    if [ ${USER_CNT} -gt 0 ]; then
		    echo -e "Error, user '${USERLOGINNAME}' already exists"
		    exit 1;
	    fi
      useradd -d "${SITEDIR}" -s /bin/false "${USERLOGINNAME}" >/dev/null 2>&1
      USER_CNT=$(getent passwd | grep -c "${USERLOGINNAME}")
      if [ ${USER_CNT} -ne 0]; then 
        echo -e "Done"
        NEXTWEBUSER_NUM=$(cat "${NGINX_DIR}/settings.conf" | grep NEXTWEBUSER | cut -d "=" -f 2 | sed s/[^0-9]//g)
		    NEXTWEBUSER_NAME=$(cat "${NGINX_DIR}/settings.conf" | grep NEXTWEBUSER | cut -d "=" -f 2 | sed s/[^a-zA-Z]//g)
		    NEXTWEBUSER_NUM_INC=$(expr ${NEXTWEBUSER_NUM} + 1)
		    sed -i "s@${USERLOGINNAME}@${NEXTWEBUSER_NAME}${NEXTWEBUSER_NUM_INC}@g" "${NGINX_DIR}/settings.conf"
      else
        if
          echo -e "Error, the user ${USERLOGINNAME} does not exist"
          exit 1;
        fi
        echo -en "Adding new group ${GROUPNAME}...\t\t\t"
        GROUP_CNT=$(getent group | grep -c "${GROUPNAME}")
        if [ ${GROUP_CNT} -ne 0 ]; then 
          echo -e "Done"
          local NEXTWEBGROUP_NUM=$(cat "${NGINX_DIR}/settings.conf" | grep NEXTWEBGROUP | cut -d "=" -f 2 | sed s/[^0-9]//g)
			    local NEXTWEBGROUP_NAME=$(cat "${NGINX_DIR}/settings.conf" | grep NEXTWEBGROUP | cut -d "=" -f 2 | sed s/[^a-zA-Z]//g)
		  	  NEXTWEBGROUP_NUM_INC=$(expr ${NEXTWEBGROUP_NUM} + 1)
		  	  sed -i "s@${GROUPNAME}@${NEXTWEBGROUP_NAME}${NEXTWEBGROUP_NUM_INC}@g" "${NGINX_DIR}/settings.conf" >/dev/null 2>&1
        else  
          echo -e "$Error, the group ${GROUPNAME} does not exits"
          exit 1;
        fi
      fi

      echo -en "Adding user ${USERLOGINNAME} to group ${GROUPNAME}...\t\t\t"
      usermod -a -G ${GROUPNAME} ${USERLOGINNAME} > dev/null 2>&1
      if user_in_group "${USERLOGINNAME}" "${GROUPNAME}"; then
		    echo -e "Done"
	    else
		    echo -e "${RED}Error: User ${USERLOGINNAME} not adding in group ${GROUPNAME}"
		    exit 1;
	    fi    
	    
      echo -en "${GREEN}Adding user ${NGINX_USER} to group ${GROUPNAME}...\t"
	    usermod -a -G ${GROUPNAME} ${NGINX_USER} >/dev/null 2>&1
	    if user_in_group "${NGINX_USER}" "${GROUPNAME}"; then
		    echo -e "Done"
	    else
		    echo -e "Error: User ${NGINX_USER} not adding in group ${GROUPNAME}"
		    exit 1;
	    fi
    }
}

function menu() {
echo " ------------  Manage Domain Menu ----------- "
PS3=" ==> Enter the option: "
cal=("Install_service" "Start_service" "Secure_mysql" "Setup_vhost" "Create_vhost" "Exit_the_program")
select i in "${cal[@]}" ; do
  case $i in
    ${cal[0]})
      echo "You chose Install service"

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
menu