<meta name="date" content="2020-3-16" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/lightsail_default.png" />
<meta name="language" content="en" />
<meta name="tags" content="lightsail,ec2,aws,ssl" />

# Install free SSL certificate

One of the tools I recommend the most if you don't have time to learn much about server administration is AWS Lightsail. These machines come with everything you need to deploy your web application without knowing too much about servers. If you want to deploy your application follow the tutorial at this [post](/blog/2020/deploy-webapps-at-aws-lightsail). Here I will cover the process of installing a free SSL certificate in order to redirect the traffic to a safe https connection.

### Generate a free SSL certificate:

1. Install certbot using the following commands:

>   
    $ sudo apt-get update
    $ sudo apt-get install software-properties-common
    $ sudo apt-add-repository ppa:certbot/certbot -y
    $ sudo apt-get update -y
    $ sudo apt-get install certbot -y

2. Declare these 2 variables before generating the free SSL-certificate:

>   
    $ DOMAIN=example.com
    $ WILDCARD=*.$DOMAIN

- And print them to check if they were asigned correctly:

>   
    $ echo $DOMAIN && echo $WILDCARD

3. We have reached the generation step:

>   
    $ sudo certbot -d $DOMAIN -d $WILDCARD --manual --preferred-challenges dns certonly

- It will prompt some messages to request you an email address, and agree to share your public IP address. Before ending the program will ask you to create a DNS record:

>   
    Please deploy a DNS TXT record under the name
    _acme-challenge.example.com with the following value:
    ******************************************* (copy this)

4. Create a TXT record pointing to _acme-challenge.example.com with the given value and wait for arround 5 minutes.

- To confirm the TXT records have propagated to the internet’s DNS use this service [https://mxtoolbox.com/TXTLookup.aspx](https://mxtoolbox.com/TXTLookup.aspx).

5. Press enter when you confirm that the TXT has propaged and it will display the following message:

>   
    - Congratulations! Your certificate and chain have been saved at:
    /etc/letsencrypt/live/example.com/fullchain.pem
    Your key file has been saved at:
    /etc/letsencrypt/live/example.com/privkey.pem
    Your cert will expire on (90 days after today). To obtain a new or tweaked
    version of this certificate in the future, simply run certbot
    again. To non-interactively renew *all* of your certificates, run
    "certbot renew"

- The final location where the certificate and private key were saved is "`/etc/letsencrypt/live/velavida.co`".

6. Copy all the files from that folder into the following location:

>   
    $ cd /opt/bitnami/apache2/conf
    $ cp /etc/letsencrypt/live/example.co/* .

7. Remove the old certificates and rename the new ones:

>   
    $ rm server.cert
    $ rm server.key
    $ mv cert.pem server.cert
    $ mv privkey.pem server.key

8. Now is time to configure the certificate at Lightsail machine. Redirect trafic from 80 port (http) to 443 (https). To achieve this modify this file: "`/opt/bitnami/apache2/conf/bitnami/bitnami.conf`".

>   
    <VirtualHost _default_:80>
        DocumentRoot "/opt/bitnami/apache2/htdocs"
        RewriteEngine On
        RewriteCond %{HTTPS} !=on
        RewriteRule ^/(.*) https://%{SERVER_NAME}/$1 [R,L]
        ...

- Make sure to modify only the configuration for the port 80.

9. Finally to make the new settings take effect, restart apache server:

>   
    $ sudo /opt/bitnami/ctlscript.sh restart apache
