# HTTP Fingerprinting for Proxy Detection

## Background

This is the developmental home for the BYU-Sandia 2024 Capstone project. This project is focused on server side detection of malicious proxies such as evilginx based on HTTP header fingerprinting. 

## Apache Server Setup

Begin with an up to date version of apache on Debian.  
Run the following command: `sudo a2enmod log_forensic`  
Restart apache: `sudo service apache2 restart`  
Add the following line to `/etc/apache2/apache2.conf`: `ForensicLog ${APACHE_LOG_DIR}/headers.log`  
Restart apache again: `sudo service apache2 restart`  

Full request headers are now being saved in `/var/log/apache2/headers.log`.  

## Evilginx setup  

Begin with an up to date version of Kali Linux. 

TODO: Finish this