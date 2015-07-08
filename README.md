Conference engine
=================

Originally created for [LVEE conference](http://lvee.org)

Installation
------------

System:

    sudo apt-get install git curl

RVM (Ruby Version Manager):

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm

Source code, Ruby, Gems:

    git clone https://github.com/lvee/lvee-engine
    cd lvee
    rvm install $(cat .ruby-version)
    rvm use $(cat .ruby-version)
    bundle install

License
-------

[GPL 2.0](https://gnu.org/licenses/old-licenses/gpl-2.0-standalone.html)
