define ssl_certificate($sslhostname) {
	file { "ssl_${name}_crt": 
		ensure => present,
		owner => "root",
		group => "root",
		mode => 644,
		path => "/etc/ssl/${sslhostname}.crt",
		source => "puppet:///modules/ssl/${sslhostname}.crt"
	}
	file { "ssl_${name}_key": 
		ensure => present,
		owner => "root",
		group => "root",
		mode => 644,
		path => "/etc/ssl/${sslhostname}.key",
		source => "puppet:///modules/ssl/${sslhostname}.key"
	}
	file { "ssl_${name}_pem": 
		ensure => present,
		owner => "root",
		group => "root",
		mode => 644,
		path => "/etc/ssl/${sslhostname}.pem",
		content => generate("/bin/cat", "/etc/puppet/modules/ssl/files/${sslhostname}.key", "/etc/puppet/modules/ssl/files/${sslhostname}.crt", "/etc/ssl/ca-bundle.pem"),
		require => [ File["ssl_${name}_crt"], File["ssl_${name}_key"] ]
	}
}

class ssl_common {
    file { "/etc/ssl" : 
        ensure  => directory,
        owner  => "root",
        group  => "root",
        mode   => 755,
    }
    file { "/etc/ssl/ca-bundle.pem" : 
        ensure => present,
        owner  => "root",
        group  => "root",
        mode   => 644,
        source => "puppet:///modules/ssl/ca-bundle.pem",
    }

    ssl_certificate { "hostname": sslhostname => $fqdn }
}

