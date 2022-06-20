# Task 5 

# Reverse-proxy

1. Download and config nginx as a reverse proxy 
- In Nginx, create and edit file reverse-proxy to act as a reverse proxy between Apache host server and my local machine.
![](src/reverse_pro_1.png)

![](src/reverse_pro_2.png)

![](src/reverse_pro_3.png)


2. Install MySQL (remote)
- Install MySQL with wget command
```
sudo wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
```

- To update the software repositories, use the command:
``` 
sudo rpm -ivh mysql80-community-release-el7-3.noarch.rpm
```

![](src/mysql_2.png)

- Install MySQL on CentOS:
```
sudo yum install mysql-server
```

![](src/mysql_3.png)

- To launch MySQL from the command line, use the command:
```
mysql -u root -p
```
![](src/mysql_4.png)

- Create new database for wordpress and laravel:

![](src/mysql_5.png)


![](src/lrv_1.png)

- Edit File configure data of **wordpress** 
```
vi /var/www/html/wordpress/wp-config.php
```

![](src/mysql_7.png)

- Edit file configure database of **laravel**
```
vi /var/www/html/laravel/.env
```

![](src/lrv_2.png)


- Enable remote MySQL in CentOS 7
```
vi /etc/my.cnf
```

![](src/mysql_6.png)

![](src/mysql_8.png)

![](src/lrv_3.png)