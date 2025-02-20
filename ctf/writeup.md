# HTTP Carrier Pigeons

## Description
Challenge category: forensics

Challenge rating: easy

Give the following to competitors:
```
In the modern world many threat actors using MitM proxies, specialized versions of reverse/transparent proxies, to phish credentials and session tokens from unsuspecting victims. 

Little do they know, their proxies leave faint traces of evidence behind that defenders can use to identify them. Each proxy modifies HTTP header requests in slightly different ways. By identifying these "fingerprints" we can determine which proxy a request passed through before it reached the server. 

We recently received the following request and believe it passed through a proxy, but you need to identify which one. To help, we've set up a variety of transparent proxies and an echo server for testing header modifications. Each link below will pass your request through a different proxy, and the echo server will reflect back the request that it received. 

fingerprint.byu.edu
evilginx.httpcarrierpigeons.xyz
modliska.httpcarrierpigeons.xyz
maurena.httpcarrierpigeons.xyz
traefik.httpcarrierpigeons.xyz
mitmproxy.httpcarrierpigeons.xyz
squid.httpcarrierpigeons.xyz
haproxy.httpcarrierpigeons.xyz
tinyproxy.httpcarrierpigeons.xyz

Flag format: (this can be changed) pearlctf{proxy_name}
```
Limit the number of guesses to 2 in order to prevent brute forcing. 

Also give competitors `header.log`, which contains the request. 

## Solve Theory
Competitors need to send a request through each proxy and identify what changes each time. As they start to develop a rulelist they can narrow the proxy down to modliska. This is based on the capitalization of the Dnt header, the Sec-Ch headers, and the change in the host header. 

## Hosting
Hosting for this challenge is pretty complex. It requires no less than 9 dedicated public IP addresses so that the web traffic doesn't need to pass through any extra proxies. 

For Pearl CTF the challenge is being hosted by BYU Cyberia. The following servers, domain names, and IP addresses are being used:
<ul>
<li>Apache Web Server - fingerprint.byu.edu - 128.187.49.100</li>
<li>Evilginx - evilginx.httpcarrierpigeons.xyz - not yet assigned</li>
<li>Modlishka - modliska.httpcarrierpigeons.xyz - not yet assigned</li>
<li>Maurena - maurena.httpcarrierpigeons.xyz - not yet assigned</li>
<li>Traefik - traefik.httpcarrierpigeons.xyz - not yet assigned</li>
<li>Mitmproxy - mitmproxy.httpcarrierpigeons.xyz - not yet assigned</li>
<li>Squid - squid.httpcarrierpigeons.xyz - not yet assigned</li>
<li>HAProxy - haproxy.httpcarrierpigeons.xyz - not yet assigned</li>
<li>Tinyproxy - tinyproxy.httpcarrierpigeons.xyz - not yet assigned</li>
</ul>

The Apache server is set up to echo back as the response whatever HTTP request it receives. The rest of the servers are acting as reverse proxies to the Apache server. 