# Infrastructure Overview
We tested 8 proxies. Some of them were malicious and others were benign. Some were reverse proxies (meaning they have their own url) and others were forward proxies (all the forward proxies were benign as they are typically not used maliciously). 


## Testing
We did some manual tests, testing for different browsers and operating systems. From these we generated yara rules. Then we plan on exposing the reverse proxy URLs to some CTFs to generate large amounts of traffic. The CTF traffic is likely to have less variety, perhaps most of it will be firefox in a kali box. 

We created a custom logging module for the Apache wordpress server as well. This log includes the source IP. Since we know which proxy has which IP, we will use these IPs to verify the accuracy of our yara rules.
## Security/Legal
The default configurations for some proxies harvest credentials. Make sure to turn these off. Users could put us in legal trouble if we do not do so.
## Website Certificates blocked by BYU's firewall
BYU's firewall, and quirks within some proxies, caused some difficulties getting TLS certificates. See [Certificates.md](Certificates.md) for more info.

# CTFs in Digital Ocean
We are setting up our proxies using VMs in Digital Ocean for the CTFs. 