#!/bin/bash
yum -y update
yum -y install httpd


myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hi from Terraform</title>
</head>
<body>
  <h2><font color = "gold"> Build by Terraform <font color = "red">v0.14.5</font></font></h2><br>

  <p><font color = "gold">Server private IP :$myip </font></p><br>

  <p>Version 3.0</p>

</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on
