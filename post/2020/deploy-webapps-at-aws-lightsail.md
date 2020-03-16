<meta name="date" content="2020-3-15" />
<meta name="image" content="https://github.com/cjortegon/camiloortegon-public/raw/master/seo/lambda_js.png" />
<meta name="language" content="en" />
<meta name="tags" content="lightsail,ec2,aws,server" />

# Deploy webapps using AWS Lightsail

Lightsail is one of my favorite tools from the AWS environment. I would like to say first that other options like Beanstalk or ECS for docker containers are good tools as well, but for developing fast solutions and not having to take care about many of the set-ups needed to run a machine in the cloud, Lightsail offers a very good service for a low price.

Lightsail was acquired by AWS, previously known as Bitnami. This service offers the option to have everything you need to deploy a web application: a public IP, free DNS and the actual server with all the tools installed out of the box. Some of the supported services are the following:

![80;;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2020/media/lightsail-flavors.png)

### Instruccions to deploy a NodeJS server

I will describe the steps to deploy an application run with NodeJS, but the set-up for other applications is very similar.

1. Go to AWS console and select Lightsail.

2. Select the "Create instance" button, and choose "Apps + OS".

3. Choose the instance that you want to have, the cheapest one costs $3.5 per month.

4. Create an SSH key pair (this will be used to connect from the terminal of your computer). This is a .pem file.

5. Tap the create instance button and wait some minutes for it to launch. You can connect using the browser, but I prefer to use the CLI from my computer because the connection is more stable and feels more smooth.

6. Add the key pair (my-key.pem) using the following command:

>   
    $ chmod 0600 my-key.pem
    $ ssh-add -K my-key.pem

7. Your instance will have by default a public dynamic IP, but you will need to create a static-ip in order to connect from your computer with the same address and set-up your DNS using a fixed IP. Lightsail gives you the option to acquire a free static-ip. Go to the `Networking` menu and press "Create static IP". After this, you can attach it to your instance.

8. Connect to your instance using this command:

>   
    $ ssh bitnami@[my-static-ip]

9. Run the following commands for NodeJS instances after connecting:

>   
    $ cd stack
    $ sudo ./use_nodejs

10. Create an apps folder and clone your repository, you can have as many apps as you want in the same server and redirect using the /my-app-1 subfolder level.

>   
    $ mkdir apps
    $ git clone git@my-git-repository
    $ cd my-git-repository
    $ npm install

11. Now let's create the configuration that will make the apache server expose your application. Go to your `apps` folder created before, add a `conf` sub-folder and create a file inside named "`httpd-prefix.conf`". This file will contain the rules for all your hosted apps:

>   
    ProxyPass /api/ http://127.0.0.1:2000/
    ProxyPassReverse /api/ http://127.0.0.1:2000/
    ProxyPass /api http://127.0.0.1:2000/
    ProxyPassReverse /api http://127.0.0.1:2000/
    ProxyPass / http://127.0.0.1:3000/
    ProxyPassReverse / http://127.0.0.1:3000/

- Let me explain these rules:
    - The last 2 rules should be the ones that point the root /.
    - `ProxyPass` and `ProxyPassReverse` should be added for each application.
    - For those applications that are hosted inside a subfolder, there will be added 2 rules for each descriptor. i.e. `/api` and `/api/`.
    - 

12. Edit the file "`/opt/bitnami/apache2/conf/bitnami/bitnami-apps-prefix.conf`" to add this line:

>   
    Include "/opt/bitnami/apps/conf/httpd-prefix.conf"

13. Create your environment variables (if needed):

>   
    $ sudo nano /opt/bitnami/nodejs/bin/node

- Make sure to put all the environment variables before this line:

>   
    exec /opt/bitnami/nodejs/bin/.node.bin  "$@"

14. And finally restart the apache server:

>   
    $ sudo /opt/bitnami/ctlscript.sh restart apache

### Set up your included DNS

1. Go to the `Networking` menu and press "Create DNS zone" with your purchased domain. Remeber you have a limit of 3 free DNS zones.

![;250;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2020/media/create-dns-zone.png)

2. Create an `A record` to point the IP of your machine:

![;100;](https://github.com/cjortegon/camiloortegon-public/raw/master/post/2020/media/dns-a-record.png)

3. In the platform where you purchased your domain name, remember to copy the nameservers to make your domain is managed by the Lightsail DNS.

You are all set to consume your application using `http`. To install an SSL certificate and redirect your traffic to `https`, read this [tutorial](/blog/2020/install-free-ssl-certificate).
