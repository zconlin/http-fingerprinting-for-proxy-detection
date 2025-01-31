# HTTP Fingerprinting for Proxy Detection

## Background

This is the developmental home for the BYU-Sandia 2024 Capstone project. This project is focused on server side detection of malicious proxies such as evilginx based on HTTP header fingerprinting. 

## Overview

Our infrastructure consists of the following:
<ul>
<li>Two DNS records, one to point to the legitimate website and one to point to the phishing proxy.</li>
<li>A web server running a default Wordpress Site on Apache. We're running this on Ubuntu 24.</li>
<li>A Kali Linux machine running Evilginx.</li>
</ul>

## DNS Setup  

The DNS record for the legitimate web server domain needs an A record pointing to the IP address of the web server. For our project we're using `fingerprint.byu.edu`, which points to `128.187.49.100`.  

The DNS record for the phishing proxy needs an A record for both the standalone domain and all subdomains that points to the IP address of the Kali box. This requires two different A records: one with the name '@' and another with the name '*'. For our project we're using `httpcarrierpigeons.xyz`, which points to `128.187.49.101`.

## Hardware & Operating Systems

The most important parts of this project are the applications; therefore the hardware and base operating systems used are less important. We're using Ubuntu 24.10 for our web server and Kali 2024.3 for our phishing server. Both of these are running on Proxmox VE 8.2, which is installed on a Dell PowerEdge R630 (ST: C84SR52). This documentation will assume that this hardware and these virtual machines are already set up and configured with the correct IP addresses. 

## Apache Setup (web server)

### Install Apache 

```
sudo apt install apache2
```

### Basic Apache Security

Remove `Indexes` from the `apache2.conf` file. 
TODO: Finish this

### Set up HTTPS

You will first need an SSL certificate for the domain the web server will be running under. You can obtain one of these for free from Let's Encrypt. We obtained one for `fingerprint.byu.edu` by sending a CSR to the BYU Networking team. If you are just using a self signed certificate you can skip to the step called "Enable the default ssl configuration".  

After storing the certificate file and the key file on the server, edit `/etc/apache2/sites-available/ssl-default.conf` with the following two lines based on where you stored the files:
```
SSLCertificateFile /your/path/to/domain.crt
SSLCertificateKeyFile /your/path/to/domain.key
```

If a chain file is also needed, edit the following line as well:  
```
SSLCertificateChainFile /your/path/to/CA.crt
```

In our case the three lines look like this:
```
SSLCertificateFile /etc/ssl/certs/fingerprint_byu_edu.crt
SSLCertificateKeyFile /etc/ssl/private/fingerprint_byu_edu.key
SSLCertificateChainFile /etc/apache2/ssl.cert/DigiCertCA.crt
```

Enable the default ssl configuration:  
```
sudo a2ensite default-ssl
```

Enable https on apache:  
```
sudo a2enmod ssl
```

Restart apache to apply changes:
```
sudo systemctl restart apache2
```

### Set Up Header Logging

Install mod log forensic:  
```
sudo a2enmod log_forensic
```  

Add the following line to the end of `/etc/apache2/apache2.conf`:  
```
ForensicLog ${APACHE_LOG_DIR}/headers.log
```

Restart apache to apply changes:  
```
sudo systemctl restart apache2
```  

Full request headers are now being saved in `/var/log/apache2/headers.log`.  

### Install Wordpress And Dependencies

The following command can be used to install the wordpress dependencies:  
```
sudo apt install ghostscript \
                 libapache2-mod-php \
                 mysql-server \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip
```

TODO: Setting up the database

Download the latest version of wordpress, then unzip it and copy it to `/var/www`:  
```
wget https://wordpress.org/latest.zip

unzip latest.zip

sudo cp wordpress /var/www/
```

Navigate to `/var/www`, then remove the existing html folder, and replace it with a symbolic link to the wordpress folder (210 shoutout):  
```
cd /var/www

sudo rm -rf html

sudo ln -s wordpress html
```

Make the www-data user the owner and group of the files:
```
sudo chgrp -R www-data wordpress

sudo chown -R www-data wordpress
```

### Set Up Wordpress

TODO: editing the config files and then accessing the site (from https using the domain name)

## Logging

TODO: Set up for logging solution

## Set up Echo Server

This echo server is built in a Flask app that runs on top of Apache using wSGI.  

Install the necessary packages:  
```
sudo apt install python3-flask libapache2-mod-wsgi-py3
```

Add the following lines to the end of `/etc/apache2/sites-available/ssl-default.conf`:  
```
WSGIDaemonProcess flaskapp threads=5
WSGIScriptAlias /echo /var/www/html/echo/flaskapp.wsgi

<Directory /var/www/html/echo>
    SSLOptions +StdEnvVars
        WSGIProcessGroup flaskapp
        WSGIApplicationGroup %{GLOBAL}
        Order deny,allow
        Allow from all
</Directory>
```

Copy `flaskapp.py` & `flaskapp.wsgi` from this repository to `/var/www/html/echo/` on the web server.

## Evilginx setup (Kali)  

### Install Go

Install wget:  
```
sudo apt install wget
```  

Download the go installation files:  
```
wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
```  

Install go from the installation files:  
```
sudo tar -zxvf go1.17.linux-amd64.tar.gz -C /usr/local/
```  

Configure the PATH variable:
```
echo "export PATH=/usr/local/go/bin:${PATH}" | sudo tee /etc/profile.d/go.sh

source /etc/profile.d/go.sh
```

### Install and Configure Evilginx

Clone the evilginx github repo, then navigate into it and make:
```
git clone https://github.com/BakkerJan/evilginx2.git

cd evilginx2

make

sudo make install
```

The phishlet needed for this project can be found in this github repository, under the file name `fingerprint.yaml`. Copy this file into `/usr/share/evilginx/phishlets` on the phishing server. This will allow Evilginx to use it. 

Run evilginx:
```
sudo evilginx
```

Set up the domain and IP address, then blacklist search bots:
```
config domain <domain>

config ip <IP>

blacklist unauth
```

Set the fingerprint phishlet to use your domain name, then turn it on:  
```
phishlets hostname fingerprint fingerprint.byu.edu

phishlets enable fingerprint
```

This will automatically request an SSL certificate from Let's Encrypt as long as you've done the DNS step properly. 

Now create a lure, or a link that will be used to access the proxy site:  
```
lures create fingerprint

lures edit 0 redirect_url https://fingerprint.byu.edu/wp-admin

lures get-url 0
```

This will return a URL that can not be used to send requests through the proxy!