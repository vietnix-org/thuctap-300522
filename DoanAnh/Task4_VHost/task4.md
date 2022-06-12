# **Task4**

1. <a href='#1'> LAMP stack: wordpress and laravel in centos7 and Vhost
2. <a href='#2'> LEMP stack: wordpress and laravel in ubuntu 20.04


****

<div id='1'></div>

## **1. LAMP stack: wordpress and laravel in centos 7**

### Wordpress 
**Step 1: Install the Apache Web Server** 

![](src1/sudo_yum_install_httpd.png)

![](src1/task1_httpd_ins.png)

1. Next, start Apache by running the following command:
```
sudo systemctl start httpd.service
```
2. Check whether the service is running by going to your server’s public IP address. The browser should display the test CentOS 7 Apache web page:

![](src1/httpd_test.png)

3. Finnaly, start httpd service to start at boot
```
sudo systemctl enable httpd.service
```

**Step 2: Install MariaDB and Create Database:**
1. Install MariaDB with the command:
```
sudo yum install mariadb-server mariadb
```
2. Now start MariaDB using the command:
```
sudo systemctl start mariadb
```
3. Check version of mariadb service:

![](src1/checkversion_mysql.png)

**Step 4: Run MySQL Security Script**
MariaDB does not have secure settings by default. Therefore, you need to configure settings, test the database, and remove anonymous users.
```
sudo mysql_secure_installation
```
![](src1/secure_mysql.png)

1. You will be prompted to provide your MariaDB root password (this is not the root password for your server). As you do not have a password yet, pressing Enter allows you to continue configuration.

2. Next, it will ask you a series of queries. To ensure your database is protected, answer the questions as follows:
- Set root password? [y/n] Y
- New password: Type in a password you would like to use
- Re-enter new password: Retype the password from the previous field
- Remove anonymous users? [y/n] Y
- Disallow root login remotely? [y/n] Y
- Remove test database and access to it? [y/n] Y
- Reload privilege tables now? [y/n] Y

3. Lastly, enable MariaDB to start up when you boot the system:
```
sudo systemctl enable mariadb.service
```

4. When you’re finished, log in to the MariaDB console by entering:
```
mysql -u root -p 
```
![](src1/create_database.png)


**Step 5: Download and install php:**
1. 
```
sudo yum install php php-mysql
```

![](src1/install_php.png)

1. Change the ownership of the default Apache document root to your user and group:
```
sudo chown -R tidiay:tidiay /var/www/html/
```

**Step 6: Download Wordpress:**

![](src1/download_wordpress.png)

2. After download, use **tar -xzvf** to unzip tar file. That should create a file named WordPress in our home directory. Next, we want to move that file and its contents to our public_html folder, so it can serve up the content for our website. We want to keep the same file permission, so we use the following rsync command. 

![](src1/untar.png)

![](src1/rsync.png)

3. For WordPress to be able to upload files, we need to create an uploads directory. Go ahead and use the following:
```
mkdir /var/www/html/wordpress/wp-content/uploads
```

4. Lastly, update the Apache permissions for new WordPress files 
```
sudo chown -R tidiay:tidiay /var/www/html/*
```

![](src1/chown.png)
