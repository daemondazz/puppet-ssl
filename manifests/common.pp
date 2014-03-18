# ssl::common
class ssl::common {
    file { '/etc/ssl' :
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
    file { '/etc/ssl/ca-bundle.pem' :
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/ssl/ca-bundle.pem',
    }
    ssl::certificate { 'hostname': sslhostname => $::fqdn }
}

