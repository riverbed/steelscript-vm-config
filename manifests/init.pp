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
        "ipython-notebook" ]:
        ensure => installed,
        require => Exec['apt-update'];
    }

    package {
      [ "virtualenv", "virtualenvwrapper" ]:
      ensure => installed,
      provider => pip;
    }

    package {
      "ipython":
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

    service {
        "apache2":
            enable => true,
            ensure => running,
            hasstatus => true,
            require => Package["apache2"],
            subscribe => [ Package[ "apache2", "libapache2-mod-wsgi" ] ],
    }

    package {
      "django":
        ensure => installed,
        provider => pip,
        require => Package['python-pip'];
    }

    package {
      "flask":
        ensure => installed,
        require => Package['python-pip'],
        provider => pip;
    }
}

class flyscript {
    package {
      "flyscript":
        ensure => installed,
        provider => pip;
    }

    package {
      "markdown":
        ensure => installed,
        provider => pip;
    }
}


include core
include python
include web
include flyscript

