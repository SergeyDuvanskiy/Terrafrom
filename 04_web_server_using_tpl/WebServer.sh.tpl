#!/bin/bash
yum -y update
yum -y install httpd
myip = `curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title></title>
  </head>
  <body>
    <h4>Build by Terrform v0.14</h4>
    <p>Owner ${f_name}, ${l_name} </p>

    <p>
      %{for i in names ~}
      Hello to ${i} from ${f_name}} <br>
      %{endfor ~}
    </p>
  </body>
</html>
EOF

sudo service httpd start
chkconfig httpd on
