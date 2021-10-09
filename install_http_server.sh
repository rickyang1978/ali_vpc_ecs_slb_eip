#!/bin/bash
sudo apt update
sudo apt -y install nginx

echo "<html>
 <head>
   <title>
   The title of your page
   </title>
 </head>
 <body>" >> test1.html
echo `curl -s http://100.100.100.200/latest/meta-data/private-ipv4` >> test1.html
echo "</body>
 </html>" >> test1.html

 mv test1.html /var/www/html/index.html