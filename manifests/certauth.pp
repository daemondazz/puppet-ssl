# ssl::certauth
define ssl::certauth($ssl_country,
                     $ssl_state,
                     $ssl_organisation,
                     $ssl_emailaddress) {

    $ssl_ca_config_file = "${::ssl_ca_base_path}/openssl.cnf"

    file { 'ssl_certificatedir' :
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        path   => $::ssl_ca_base_path
    }
    file { 'ssl_ca_config_file' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        path    => $ssl_ca_config_file,
        content => template('ssl/openssl.cnf.erb')
    }
    file { 'ssl_mkcert_script' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
        path    => "${::ssl_ca_base_path}/0mkcert.sh",
        content => template('ssl/mkcert.sh.erb')
    }
}
