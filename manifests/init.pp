class core {
    exec { "apt-update":
      command => "/usr/bin/sudo apt-get -y update"
    }
  
    package { 
      [ "vim", "git-core", "build-essential" ]:
        ensure => installed,
        require => Exec['apt-update'];
    }
}

class python {
    package { 
      [ "python", "python-setuptools", "python-dev", "python-pip",
        "python-matplotlib", "python-imaging", "python-numpy", "python-scipy",
        "python-pandas", "ipython-notebook", "python-nose" ]:
        ensure => installed,
        require => Exec['apt-update'];
    }

    package {
      [ "virtualenv", "virtualenvwrapper" ]:
      ensure => installed,
      provider => pip;
    }

    package {
      ["ipython"]:
      ensure => "0.13.1",
      provider => pip;
    }
}

class web {
    package { 
      [ "apache2", "postgresql", "sqlite3", "libapache2-mod-wsgi", 
        "snmp", "curl", "wget" ]:
          ensure => installed
    }

    package {
      "django":
        ensure => installed,
        provider => pip,
        require => Package['python-pip'];
    }

    file {
      "/etc/apache2/sites-available/flyscript_portal":
        content => template("portal/flyscript_portal.erb"),
        ensure => file,
        require => Package["apache2"];
      "/etc/apache2/sites-enabled/001-flyscript_portal":
        ensure => "/etc/apache2/sites-available/flyscript_portal",
        require => Package["apache2"];
      "/etc/apache2/sites-enabled/000-default":
        ensure => absent,
        require => Package["apache2"];
      "/flyscript/wsgi/flyscript_portal.wsgi":
        content => template("portal/flyscript_portal.wsgi"),
        require => File["/flyscript/wsgi"],
        ensure => file;
      "/var/www":
        ensure => directory,
        owner => "www-data",
        group => "www-data",
        recurse => true;
    }

    service {
        "apache2":
            enable => true,
            ensure => running,
            hasstatus => true,
            require => Package["apache2"],
            subscribe => [ Package[ "apache2", "libapache2-mod-wsgi" ] ],
    }

}

class flyscript_portal {
    file {
      "/flyscript":
        ensure => directory,
        mode => 775,
        require => Package[ 'apache2' ],
        notify => Exec[ 'portal_checkout' ];
      "/flyscript/wsgi":
        ensure => directory,
        mode => 775,
        require => Package[ 'apache2' ];
      "/flyscript/flyscript_portal":
        ensure => directory,
        owner => "www-data",
        group => "www-data",
        recurse => true;
      ### This is temp only until configs committed
      "/flyscript/flyscript_portal/project/settings.py":
        content => template("portal/settings.py"),
        require => Exec['portal_checkout'],
        owner => "www-data",
        group => "www-data",
        ensure => file;
    }

    exec {
      'portal_checkout':
        cwd => '/flyscript',
        command => 'git clone git://github.com/riverbed/flyscript-portal.git flyscript_portal',
        path => '/usr/local/bin:/usr/bin:/bin',
        creates => '/flyscript/flyscript_portal/.git',
        notify => [ Exec['portal_setup'], 
                    File['/flyscript/flyscript_portal/project/settings.py'],
        ],
        refreshonly => true;
    }

    exec {
      'portal_setup':
        cwd => '/flyscript/flyscript_portal',
        command => 'clean',
        path => '/flyscript/flyscript_portal:/usr/local/bin:/usr/bin:/bin',
        creates => '/flyscript/flyscript_portal/project.db',
        notify => [ Exec['portal_static_files'], 
        ],
        refreshonly => true;
    }

    exec {
      'portal_static_files':
        cwd => '/flyscript/flyscript_portal',
        command => 'sudo python manage.py collectstatic --noinput',
        path => '/flyscript/flyscript_portal:/usr/local/bin:/usr/bin:/bin',
        creates => '/flyscript/flyscript_portal/static/bootstrap',
        require => File['/flyscript/flyscript_portal/project/settings.py'],
        notify => [ Exec['portal_permissions'], 
        ],
        refreshonly => true;
    }

    exec {
      'portal_permissions':
        cwd => '/flyscript/flyscript_portal',
        command => 'chown -R www-data:www-data *',
        path => '/flyscript/flyscript_portal:/usr/local/bin:/usr/bin:/bin',
        notify => [ Service['apache2'],
        ],
        refreshonly => true;
    }
}

class flyscript {
    package {
      "flyscript":
        ensure => latest,
        provider => pip;
    }

    package {
      "jsonfield":
        ensure => "0.9.5",
        provider => pip;
    }

    package {
      [ "djangorestframework", "markdown", "django-model-utils", 
        "pygeoip", "django-extensions" ]:
        ensure => installed,
        provider => pip;
    }
}


include core
include python
include web
include flyscript
include flyscript_portal

