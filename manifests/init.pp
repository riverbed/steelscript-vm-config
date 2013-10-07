# Copyright (c) 2013 Riverbed Technology, Inc.
# This software is licensed under the terms and conditions of the MIT License set
# forth at https://github.com/riverbed/flyscript-vm-config/blob/master/LICENSE
# ("License").  This software is distributed "AS IS" as set forth in the License.

stage { 'first': before => Stage['main'] }

class setup {
    file {
      "/root/.pip":
        ensure => directory;

      "/root/.pip/pip.conf":
        content => template("portal/pip.conf"),
        require => File["/root/.pip"],
        recurse => true,
        ensure => file;
    }

    exec { "apt-update":
      command => "/usr/bin/sudo apt-get -y update",
      require => File["/root/.pip/pip.conf"];
    }
}
class { "setup": stage => first }
  
class core {
    package { 
      [ "vim", "git-core", "build-essential" ]:
        ensure => installed,
        require => Exec['apt-update'];
    }
}

class python {
    package { 
      [ "python", "python-setuptools", "python-dev", "python-pip", "sqlite3", 
        "python-matplotlib", "python-imaging", "python-numpy", "python-scipy",
        "python-pandas", "ipython-notebook", "python-nose", "snmpd" ]:
        ensure => installed;
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
      [ "apache2", "libapache2-mod-wsgi", 
        "snmp", "curl", "wget" ]:
          ensure => installed,
          require => Exec['apt-update'];
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

class flyscript {
    package {
      "flyscript":
        ensure => latest,
        provider => pip;
    }

    package { 
      [ "wireshark", "tshark" ]:
        ensure => installed,
        require => Exec['apt-update'];
    }
}

class flyscript_portal {
    package {
      [ "django", "djangorestframework", "markdown", "django-model-utils", 
        "pygeoip", "django-extensions", "pysnmp" ]:
        ensure => installed,
        provider => pip,
        require => Package['python-pip', 'python-dev'];
    }

    package {
      "jsonfield":
        ensure => "0.9.5",
        provider => pip,
        require => Package['python-pip'];
    }

    package {
      # we need to update pandas past what is provided by Ubuntu packages
      "pandas":
        ensure => "0.10.1",
        provider => pip,
        require => Package['python-pip', 'python-pandas'];
    }

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
    }

    exec {
      'portal_checkout':
        cwd => '/flyscript',
        command => 'git clone https://github.com/riverbed/flyscript-portal.git flyscript_portal',
        path => '/usr/local/bin:/usr/bin:/bin',
        creates => '/flyscript/flyscript_portal/.git',
        require => Package[ "django", "djangorestframework", "markdown", "django-model-utils", 
        "pygeoip", "django-extensions" ],
        notify => [ Exec['portal_setup'], 
        ],
        refreshonly => true;
    }

    exec {
      'portal_setup':
        cwd => '/flyscript/flyscript_portal',
        command => 'sudo python manage.py syncdb --noinput',
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
        notify => [ Exec['portal_reload'], 
        ],
        refreshonly => true;
    }

    exec {
      'portal_reload':
        cwd => '/flyscript/flyscript_portal',
        command => 'sudo python manage.py reload',
        path => '/flyscript/flyscript_portal:/usr/local/bin:/usr/bin:/bin',
        notify => [ Exec['portal_permissions'], 
        ],
        refreshonly => true;
    }

    exec {
      'portal_permissions':
        cwd => '/flyscript/flyscript_portal',
        command => 'sudo chown -R www-data:www-data *',
        path => '/flyscript/flyscript_portal:/usr/local/bin:/usr/bin:/bin',
        notify => [ Service['apache2'],
        ],
        refreshonly => true;
    }
}



include core
include python
include web
include flyscript
include flyscript_portal

