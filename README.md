## DESCRIPTION

Command-line Python Development Environment with FlyScript


## REQUIREMENTS

* [VirtualBox](http://www.virtualbox.org/)
* [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://www.vagrantup.com/)
* [git](http://git-scm.com/downloads)
or one of the Github GUI clients: [OSX](http://mac.github.com/), [Windows] (http://windows.github.com/), [Eclipse](http://eclipse.github.com/)

        Clone this repo: $ git clone git@github.com:riverbed/flyscript-vm.git
        Or, using one of the Github GUI clients, click the button: Clone in {platform}

## BASIC USAGE

1. Assuming you have met the above requirements. 
2. Provision a new Vagrant VM (using FlyscriptVM as example):

        $ vagrant box add FlyscriptVM http://files.vagrantup.com/precise32.box
        $ cd flyscript-vm (Wherever your cloned path is for this repo)
        $ vagrant up

3. A fresh install will take between 10-20 minutes depending on your internet connection.
4. Once installed, login to the machine, and start a fresh IPython notebook instance:

        $ vagrant ssh
        vagrant@precise32:~$ ipython notebook --ip=`facter ipaddress` --pylab=inline
        [NotebookApp] Created profile dir: u'/home/vagrant/.ipython/profile_default'
        [NotebookApp] Serving notebooks from /home/vagrant
        [NotebookApp] The IPython Notebook is running at: http://<ipaddress>:8888/
        [NotebookApp] Use Control-C to stop this server and shut down all kernels.
        [NotebookApp] No web browser found: could not locate runnable browser.

5. On a browser on the host machine, head to the following url: [http://127.0.0.1:38888](http://127.0.0.1:38888).
6. A notebook instance should be visible.

Note: this notebook will be accessible to anyone on your LAN, if additional security is required, learn 
more about adding passwords and encryption [here in the documentation](http://ipython.org/ipython-doc/dev/interactive/htmlnotebook.html#security).

