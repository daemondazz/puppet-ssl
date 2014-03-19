# SSL module for Puppet

This is puppet module for configuring SSL certificates on servers, as well as
managing scripts to assist with the generation of private keys and certificate
signing requests.

It does not provide any scripts for signing certificates at present, it is
assumed that CSRs will be sent to an external CA.

## Puppet Classes

The following classes are defined in this modules.

1. `ssl::common`

    This should be included in all nodes that require an SSL certificate,
    generally within the base or default node. It handles ensuring there is a
    certificate installed with the FQDN of the node.

    TODO: Note that puppet runs for a node run before a certificate is
    generated will generate an error `Could not retrieve catalog from remote
    server: wrong header line format`. This is a known issue and the work
    around at present it to ensure that a certificate has been generated for
    the node before adding to puppet.

## Puppet Types

The following new types are defined:

* `ssl::certauth`

   Object that includes the certificate authority scripts on the node. Supports
   the following options:

   * `ssl_country` (string)

      The two letter country code of the system is located in.

   * `ssl_state` (string)

      The full name of the state the system is located in.

   * `ssl_organisation` (string)

      The full name of the organisation that runs the system.

   * `ssl_emailaddress` (string)

      The email address of the system administrator responsible for the SSL
      certificates.

* `ssl::certificate`

   Object that adds an SSL certificate to the node. Supports the following
   options:

   * `include_pem` (boolean)

      A flag indicating whether the PEM file should be built by concatenating
      the private key and certificate files. Defaults to true.

   * `owner` (string)

      The username of the user that should own the certificate, private key and
      PEM file. Defaults to root if not provided.

   * `path_dir` (string)

      The directory where the certificate, private key and PEM file should be
      saved. Defaults to /etc/ssl if not provided.

   * `path_filename` (string)

      The base filename of the certificate, private key and PEM file. Defaults
      to the value of `$sslhostname` if not provided.

   * `sslhostname` (string)

      The full common name of the certificate, generally a hostname.

## Puppet Variables

The following variables are required by this module and included templates.
These variables should set either globally in the site.pp file.

1. `$ssl_ca_base_path` (string)

    The location on the certificate master node where the certificates are to
    be stored. Do not include the trailing slash.

## Examples

### site.pp

This example sets up the path to the certificates on the master and ensure that
every node includes their FQDN certificate.

    $ssl_ca_base_path = '/etc/ssl/master-certificates'
    node default {
        include 'ssl::common'
    }

### node

This example shows a node that could be a web server and includes an extra
certificate and also a node that is acting as the certificate master server.

    node "web.example.com" inherits default {
        ssl::certificate { 'examplecom': sslhostname => 'example.com' }
        service { 'nginx':
            ensure    => running,
            enable    => true,
            subscribe => Ssl::Certificate['examplecom'],
        }
    }
    
    node "ssl-master.example.com" inherits default {
        ssl::certauth { 'ssl-certificates' :
            ssl_country      => 'AU',
            ssl_state        => 'South Australia',
            ssl_organisation => 'Example Corp',
            ssl_emailaddress => 'root@example.com'
        }
    }
