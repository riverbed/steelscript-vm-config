class core {
  
    exec { "apt-update":
      command => "/usr/bin/sudo apt-get -y update"
    }
  
    package { 
      [ "vim", "git-core", "build-essential" ]:
        ensure => ["installed"],
        require => Exec['apt-update']    
    }
}

class python {

    package { 
      [ "python", "python-setuptools", "python-dev", "python-pip",
        "python-matplotlib", "python-imaging", "python-numpy", "python-scipy",
        "ipython-notebook" ]:
        ensure => ["installed"],
        require => Exec['apt-update']    
    }

    exec {
      "virtualenv":
      command => "/usr/bin/sudo pip install virtualenv",
      require => Package["python-dev", "python-pip"]
    }

}

class networking {
    package { 
      [ "snmp", "curl", "wget" ]:
        ensure => ["installed"],
        require => Exec['apt-update']    
    }
    
}

class web {

    package { 
      [ "apache2", "postgresql", "sqlite3" ]:
        ensure => ["installed"],
        require => Exec['apt-update']    
    }

    exec {
      "django":
      command => "/usr/bin/sudo pip install django",
      require => Package["python-pip"],
    }

    exec {
      "flask":
      command => "/usr/bin/sudo pip install django",
      require => Package["python-pip"],
    }
}

include core
include python
include networking
include web


