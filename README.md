# certbot Cookbook

This cookbook configure and install ssl certificates throught letsencrypt for a provided domain using nginx.

### Platforms

- Ubuntu 16.04 LTS

### Chef

- Chef 12.0 or later

## Resources and Providers
###certbot_certificate
#### Actions
<table>
    <tr>
        <th>Action</th>
        <th>Description</th>
        <th>Default</th>
    </tr>
    <tr>
        <td>:install</td>
        <td>Configure and install an ssl certificate for the provided domain</td>
        <td>true</td>
    </tr>
</table>

#### Attributes
<table>
    <tr>
        <th>Attribute</th>
        <th>Description</th>
        <th>Default value</th>
    </tr>
    <tr>
        <td>domain</td>
        <td>The domain to certificate</td>
        <td>nil</td>
    </tr>
    <tr>
        <td>renew_policy</td>
        <td>
            Set the renew policy.<br />
            Permitted values:<br />
            <b>:renew_by_default</b>: request a new certificate and install it;<br />
            <b>:keep_until_expiring</b>: request and install a new certificate if the current is less then 30 days from expiring.
            </td>
        <td>:renew_until_expiring</td>
    </tr>
    <tr>
        <td>install_cron</td>
        <td>If true, install a cronjob that automatically try to renew the certificate</td>
        <td>true</td>
    </tr>
    <tr>
        <td>frequency</td>
        <td>Set the frequency the cron must run.<br />Permitted values: <b>:daily, :weekly, :monthly.</b></td>
        <td>:daily</td>
    </tr>
    <tr>
        <td>test</td>
        <td>If true, request the certificate through Acme Staging server</td>
        <td>false</td>
    </tr>
</table>

## Libraries

    letsencrypt_certificates_dir(domain)

    letsencrypt_cert_path(domain)

    letsencrypt_chain_path(domain)

    letsencrypt_fullchain_path(domain)

    letsencrypt_privatekey_path(domain)
    
    
Throught this methods it's possible to retrieve the Let's Encrypt generated files path.
## Usage
In your recipe you simply need to call the provider!

```ruby
  certbot_certificate "mydomain_letsencrypt" do
    domain "www.esample.com"
    action :create
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

Authors: TODO: List authors
