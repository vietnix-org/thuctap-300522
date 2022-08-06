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

**Step 7: Configuring WordPress**
1. Create a wp-config.php file by copying the sample file WordPress has provided. 
``` 
cp wp-config-sample.php wp-config.php
```

After that config this file with your database:

![](src1/config_wp.png)

#### Setup VHost
1. Config file http.conf in **/etc/httpd/conf/**

![](src1/vhost_1.png)

![](src1/httpd_conf.png)

![](src1/httpdconf.png)

2. Create 2 file sites-available and sites-enabled 
![](src1/mkdir_file.png)

3. Create file config vhost in /etc/httpd/sites-availabe/

![](src1/site_available.png)

4. After that, create symlink to /etc/httpd/sites-enabled/

#### Finish and go to you website to check

![](src1/finish.png)


### Laravel
1. Setup Yum Repositories
First, we need to add the REMI and EPEL rpm repositories in your system. These repositories contain the updated packages. You can use the following commands to set up the rpm repositories
```
rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-12.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
```
2. Setup LAMP (finished)
3. Setup Composer
Composer is a command-line program that installs packages and libraries available on the packagist.org repository – Composer's main repository.
Composer is a very useful tool for developers when they need and want to manage and combine packages for their PHP project.

![](src2/composer_setup.png)

4. Setup Laravel with Git

![](src2/laravel_setup.png)

Install php8.1.7 and extension 

![](src2/php-extention.png)

![](src2/php-xml.png)

**Remember to change owner of file laravel**

![](src2/owner.png)

- Set encryption key

![](src2/encrypt.png)

- Update composer: 

![](src2/composer_update.png)

- Install laravel:

![](src2/install_laravel.png)


#### Setup VHost (Same with wordpress)

- Config file **/etc/httpd/conf/httpd.conf**
  
 ![](src2/httpd_conf.png)

- Create new file **laravel.training.vn** in /etc/httpd/sites-available/ and config:
  
![](src2/laravel_conf.png)

- After that, create symlink to sites-enabled 

![](src2/ln-s.png)

- Edit file /etc/hosts to add your domain

![](src2/hosts.png)


#### Finish and go to website to check:

![](src2/laravel.png)




<div id='2'></div>

## **2. LEMP stack: wordpress and laravel in ubuntu 22.04**

### LEMP stack, wordpress and vhost in ubuntu 22.04

1. Update sudo and Install nginx 

![](src3/install_nginx.png)

- If you have the ufw firewall enabled, as recommended in our initial server setup guide, you will need to allow connections to Nginx. Nginx registers a few different UFW application profiles upon installation. To check which UFW profiles are available, run:

![](src3/ufw.png)

- Check status ufw:
  
![](src3/ufw_status.png)

2. Install MySQL
```
sudo apt install mysql-server
sudo mql_secure_installation
```

![](src3/mysql_installation.png)

- Then config mysql in wordpress folder:
  
![](src3/config_sql.png)

![](src3/mysql.png)


3. Install PHP

```
sudo apt install php8.1-mysql php8.1-curl php8.1-xml php8.1-cli
```

![](src3/php-v.png)

**Config file /etc/php/8.1/fpm/pool.d/www.conf**

![](src3/www-conf.png)

4. Configuring Nginx to Use the PHP Processor

![](src3/wordpress_file.png)

Then, open a new configuration file in Nginx’s sites-available directory using your preferred command-line editor.
```
sudo vim /etc/nginx/sites-available/wordpress.training.vn.conf
```
And config this file like that:

![](src3/real.png)

Activate your configuration by linking to the configuration file from Nginx’s sites-enabled directory:

![](src3/ln-s.png)

5. Download and install wordpress:
```
wget https://wordpress.org/latest.zip
```

![](src3/wordpress_install.png)

![](src3/chmod-own.png)


- Test nginx and restart nginx service:

![](src3/nginx-t.png)

- Finally, edit file /etc/hosts
  
![](src3/hosts.png)

- Go to website and check the result:

![](src3/result.png)


<div id='2'></div>

### Laravel 
We already installed LEMP on Ubuntu 22.04. Now we will install Laravel and Vhost.

1. Create new database:
```
sudo mysql -u root -p
```
After create new database, we install composer: 
```
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
```

![](src4/composer.png)

![](src4/composer-v.png)

2. Download and install Laravel

![](src4/install_laravel.png)

![](src4/env.png)

![](src4/env_1.png)

3. Config VHost:

- First, create new file **laravel.training.vn.conf** in /etc/nginx/sites-available/ and write: 

![](src4/config_la.png)

- Create symlink to /etc/nginx/sites-enabled/
  
![](src4/symlink.png)

- Edit file /etc/hosts

![](src4/etc.png)

![](src4/last.png)

4. Finished
- Go to your website with your domain and check
  
![](src4/finish.png)