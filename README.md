
# html-shell-cgi-demo

## What is this

It is just a web page with cgi script written in Shell Script and HTML Language. I create this to add user for lighttpd auth module without `apache2-utils` installed.

## How to use it

Upload these files to your webserver, enable cgi in your webserver and restart it, add execute permission for `core.sh`, then you can try to view this web page. You may set `.sh` interpreter to `/bin/ash` or you may get 500 Error on OpenWrt.
