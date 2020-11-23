# Vagrant Provision LAMP Stack 

- Code comments and explanation

As can see in the file **Vagrantfile** every line is commented in order to specify what i'm trying to do. There are lots of lines that we aleready know, this are specs of vagrant configuration and the virtual machine is going to run/execute for exmaple:

> `config.vm.box = "ubuntu/trusty64"`

> `config.vm.hostname = hostname`

> `config.vm.network "private_network", ip: server_ip`

> `vb.name = "Vagrant Dev"`

> `vb.memory = "1024"`

> `vb.cpus = 1`

I am goning to remark the important lines (*shell commands to install lamp stack*)

***

- Important lines in the _Vagrantfile_

The important lines are basically the instalation of **Apache - MySQL - PHP** these are the elements that make up the Lamp Stack.

 > Installing Apache
~~~
config.vm.provision "shell", inline: "sudo apt-get install -qq apache2"

config.vm.provision "shell", inline: "sudo a2enmod rewrite"

config.vm.provision "shell", inline: "sudo service apache2 restart"
~~~
>

>> **mod_rewrite** provides a flexible and powerful way to manipulate URLs using an unlimited number of rules.

>

>> The **mod_rewrite** module uses a rule-based rewriting engine, based on a PCRE regular-expression parser, to rewrite requested URLs on the fly.

>

>> **-q, --quiet** > *Quiet. Produces output suitable for logging, omitting progress indicators.*

>

> We have to **restart** apache in order to *reload* the configuration

---

> Installing PHP

~~~
config.vm.provision "shell", inline: "sudo apt-get install -qq php5 php5-mysql php5-curl php5-gd php5-gmp php5-mcrypt php5-intl"

config.vm.provision "shell", inline: "sudo php5enmod mcrypt"

config.vm.provision "shell", inline: "sudo service apache2 restart"
~~~

>

> **php5enmod mcrypt** > reload Apache to make use of the extension
sudo service apache2 reload

>

---

> Installing MySQL

+ First... We have to set the **username and password** to 'root', these parameters are declared in the beginning of the *Vagrantfile*

  ~~~
  hostname            = "vagrant.dev"
  server_ip           = "IP-Address"
  mysql_root_password = "root"
  ~~~

+ Setting the username and password...
~~~
config.vm.provision "shell", inline: "sudo debconf-set-selections <<< \"mysql-server mysql-server/root_password password #{mysql_root_password}\""

config.vm.provision "shell", inline: "sudo debconf-set-selections <<< \"mysql-server mysql-server/root_password_again password #{mysql_root_password}\""
~~~

>

> Now we can install MySQL
~~~
config.vm.provision "shell", inline: "sudo apt-get install -qq mysql-server"
~~~
