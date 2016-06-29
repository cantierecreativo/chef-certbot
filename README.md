# certbot Cookbook

This cookbook configure and install ssl certificates throught letsencrypt for a provided.

### Platforms

- Ubuntu 16.04 LTS

### Chef

- Chef 12.0 or later

## Attributes
###default

* `node['certbot']['webroot_dir']` - Path for the webroots main directory. Defaults on '/var/www/letsencrypt'
* `node['certbot']['working_dir']` - Path for self signed certificate and currents working directoy. Defaults on '/etc/letsencrypt'
* `node['certbot']['rsa_key_size']` - Size for the rsa key. Defaults on 4096

## Resources and Providers
###activate_certificate
Set the provided certificate and private key as current certificate, creating 2 symlinks under **/etc/letsencrypt/current/#{domain}/**.

For example, for domain "www.example.com" it will create:

* /etc/letsencrypt/current/www.example.com/cert.pem
* /etc/letsencrypt/current/www.example.com/key.pem


##### Actions
<table>
    <tr>
        <th>Action</th>
        <th>Description</th>
        <th>Default</th>
    </tr>
    <tr>
        <td>:install</td>
        <td>Set the provided certificate as current certificates for domain</td>
        <td>true</td>
    </tr>
</table>

##### Attributes
<table>
    <tr>
        <th>Attribute</th>
        <th>Description</th>
        <th>Default value</th>
        <th>Required</th>
    </tr>
    <tr>
        <td>domain</td>
        <td>The domain to certificate</td>
        <td>nil</td>
        <td>true</td>
    </tr>
    <tr>
        <td>cert_path</td>
        <td>File system path of the certificate file you want to use</td>
        <td>nil</td>
        <td>true</td>
    </tr>
    <tr>
        <td>key_path</td>
        <td>File system path of the private key file you want to use</td>
        <td>nil</td>
        <td>true</td>
    </tr>
</table>

###Certificate
Generate a new valid ssl certifivate through the **certbot** service, and activate it


##### Actions
<table>
    <tr>
        <th>Action</th>
        <th>Description</th>
        <th>Default</th>
    </tr>
    <tr>
        <td>:install</td>
        <td>Generate a new valid ssl certificate for provided domain</td>
        <td>true</td>
    </tr>
</table>

##### Attributes
<table>
    <tr>
        <th>Attribute</th>
        <th>Description</th>
        <th>Default value</th>
        <th>Required</th>
    </tr>
    <tr>
        <td>email</td>
        <td>The admin email in order to registrate to acme servers</td>
        <td>nil</td>
        <td>true</td>
    </tr>
    <tr>
        <td>renew_policy</td>
        <td>Choose the letsencrypt option for renew. When <b>:keep_until_expiring</b>, it will renew starting from 30 days to expire. When <b>:renew_by_default</b> it will renew immediately</td>
        <td>:keep_until_expiring</td>
        <td>false</td>
    </tr>
    <tr>
        <td>install_cron</td>
        <td>If true, a cron with renew command will be added with provided <b>frequency</b></td>
        <td>true</td>
        <td>false</td>
    </tr>
    <tr>
        <td>frequency</td>
        <td>Choose the cron frequency to run the renew command. One of <b>:daily</b>, <b>:weekly</b>, <b>:monthly</b></td>
        <td>:daily</td>
        <td>false</td>
    </tr>
    <tr>
        <td>test</td>
        <td>If true, it will generate a fake certificate throught acme-staging server instead a valid one from production server</td>
        <td>false</td>
        <td>false</td>
    </tr>
</table>

### self\_signed\_certificate
It create a new self signed certificate for provided domain and activate it.

#### Actions
<table>
    <tr>
        <th>Action</th>
        <th>Description</th>
        <th>Default</th>
    </tr>
    <tr>
        <td>:install</td>
        <td>Create a self signed certificate</td>
        <td>true</td>
    </tr>
</table>

#### Attributes
<table>
    <tr>
        <th>Attribute</th>
        <th>Description</th>
        <th>Default value</th>
        <th>Required</th>
    </tr>
    <tr>
        <td>domain</td>
        <td>The domain to certificate with the self signed certificate</td>
        <td>nil</td>
        <td>true</td>
    </tr>
    <tr>
        <td>force_reinstall</td>
        <td>If true, the self signed certificate will be overridden by a new one</td>
        <td>false</td>
        <td>false</td>
    </tr>
 </table>


## Libraries
```
certbot_certificates_dir(domain)    #provide the letsencrypt live directory for domain

certbot_cert_path_for(domain)       #provide letsencrypt cert.pem filepath

certbot_chain_path_for(domain)      #provide letsencrypt chain.pem filepath

certbot_fullchain_path_for(domain)  #provide letsencrypt fullchain.pem filepath

certbot_privatekey_path_for(domain) #provide letsencrypt privatekey.pem filepath

certbot_webroot_path_for(domain)    #provide the webroot directory path for domain

certbot_well_known_path_for(domain) #provide the well-known directory path for domain



certbot_self_signed_directory(domain) #provide the directory in which the self signed certificate will be installed

certbot_self_signed_cert_path_for(domain) #provide filepath for the self signed certificate

certbot_self_signed_key_path_for(domain) #provide filepath for the self signed private key

certbot_self_signed_pair       #provide a new pair of key/certificate file string



certbot_current_directory(domain)    #provide the directory path for currents certificate for domain

certbot_current_cert_path_for(domain) #the current certificate path for domain

certbot_current_key_path_for(domain)  #the current key path for domain

```

Throught this methods it's possible to retrieve the Let's Encrypt generated files path.
## Usage
In your recipe you simply need to call the provider!

```ruby
  certbot_certificate "mydomain_letsencrypt" do
    domain "www.example.com"
    action :create
  end
```

#### The meaning of current directory
Suppose you want to add ssl to a new server or an existing one.

Your server cookbook could have an nginx or apache template that expect to find an ssl certificate in a certain path. You could think to write something like this:

```
# File /etc/nginx/sites-available/www.example.com

server {
  listen 443;
  ssl on;
  ssl_certificate /etc/letsencrypt/live/www.example.com/cert.pem;
  ssl_certificate_key /etc/letsencrypt/live/www.example.com/privatekey.pem;
  
  location ^~ /.well-known {
    alias /var/www/letsencrypt/www.example.com/.well-known;
  }
```

It works if those file already exists on the server. But the first time? 

The first time nginx maybe will not restarted, due to a failing configuration, and then letsencrypt will not works because the well-known directive is not loaded.

To avoid this, use the **self\_signed\_certificate** resource to create a self signed certificate and install it under **/etc/letsencrypt/current/www.example.com/** directory

Then, use this server configuration

```
server {
  listen 443;
  ssl on;
  ssl_certificate /etc/letsencrypt/current/www.example.com/cert.pem;
  ssl_certificate_key /etc/letsencrypt/current/www.example.com/key.pem;
  
  location ^~ /.well-known {
    alias /var/www/letsencrypt/www.example.com/.well-known;
  }
```

In a recipe, you can write something like this:

```
  self_signed_certificate "www.example.com" do
    domain "www.example.com"
  end
  
  template "/etc/nginx/sites-enabled/www.example.com.conf" do
    ...
    notifies :reload, "service[nginx]", :immediately                #now nginx are reloaded with a self signed certificate, and letsencrypt is able to validate the domain
  end
  
  certbot_certificate "www.example.com" do
    domain "www.example.com"
    notifies :reload, "service[nginx]", :immediately                #when nginx is reloaded, it will point to the new valid certificates
  end
  
```


## Contributing

TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: David Librera
