# ssl::certificate
define ssl::certificate($sslhostname) {
    file { "ssl_${name}_crt" :
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        path   => "/etc/ssl/${sslhostname}.crt",
        source => "${::ssl_ca_base_path}/${sslhostname}.crt"
    }
    file { "ssl_${name}_key" :
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        path   => "/etc/ssl/${sslhostname}.key",
        source => "${::ssl_ca_base_path}/${sslhostname}.key"
    }
    file { "ssl_${name}_pem" :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        path    => "/etc/ssl/${sslhostname}.pem",
        content => generate('/bin/cat',
                            "${::ssl_ca_base_path}/${sslhostname}.key",
                            "${::ssl_ca_base_path}/${sslhostname}.crt",
                            '/etc/ssl/ca-bundle.pem'),
        require => [ File["ssl_${name}_crt"], File["ssl_${name}_key"] ]
    }
}

