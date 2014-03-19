# ssl::certificate
define ssl::certificate($sslhostname,
                        $owner='root',
                        $path_dir='/etc/ssl',
                        $path_filename=false,
                        $include_pem=true) {

    if (! $path_filename) {
        $path = "${path_dir}/${sslhostname}"
    } else {
        $path = "${path_dir}/${path_filename}"
    }

    file { "ssl_${name}_crt" :
        ensure => present,
        owner  => $owner,
        group  => 'root',
        mode   => '0644',
        path   => "${path}.crt",
        content => template("${::ssl_ca_base_path}/${sslhostname}.crt")
    }
    file { "ssl_${name}_key" :
        ensure => present,
        owner  => $owner,
        group  => 'root',
        mode   => '0640',
        path   => "${path}.key",
        content => template("${::ssl_ca_base_path}/${sslhostname}.key")
    }
    if ($include_pem) {
        file { "ssl_${name}_pem" :
            ensure  => present,
            owner  => $owner,
            group   => 'root',
            mode    => '0640',
            path    => "${path}.pem",
            content => template("${::ssl_ca_base_path}/${sslhostname}.key",
                                "${::ssl_ca_base_path}/${sslhostname}.crt",
                                '/etc/ssl/ca-bundle.pem'),
            require => [ File["ssl_${name}_crt"], File["ssl_${name}_key"] ]
        }
    }
}

