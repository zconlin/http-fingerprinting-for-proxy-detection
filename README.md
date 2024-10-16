# HTTP Fingerprinting for Proxy Detection

## Background

This is the developmental home for the BYU-Sandia 2024 Capstone project. This project is focused on server side detection of malicious proxies such as evilginx based on HTTP header fingerprinting. 

## DNS Setup  

TODO: put information about glue records. 

## Apache Server Setup

Begin with an up to date version of apache on Debian.  

Run the following command:  
```
sudo a2enmod log_forensic
```  

Restart apache:  
```
sudo service apache2 restart
```  

Add the following line to `/etc/apache2/apache2.conf`:  
```
ForensicLog ${APACHE_LOG_DIR}/headers.log
```

Restart apache again:  
```
sudo service apache2 restart
```  

Full request headers are now being saved in `/var/log/apache2/headers.log`.  

## Evilginx setup  

Begin with an up to date version of Kali Linux. This documentation assumes that the device is assigned a public IP address, as that will be necessary for the proxy to function. You will also need the DNS name set up earlier in this guide.  

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

Clone the evilginx github repo, then navigate into it and `make`:
```
git clone https://github.com/BakkerJan/evilginx2.git

cd evilginx2

make
```

Finish the install and run evilginx:
```
sudo make install

sudo evilginx
```

Set up the domain and IP address, then blacklist search bots:
```
config domain <domain>

config ip <IP>

blacklist unauth
```

TODO: we may need to make our own phishlet for OWASP juice shop. Will come back to this

TODO: Finish this