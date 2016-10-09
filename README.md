Conference engine
=================

Originally created for [LVEE conference](http://lvee.org)

Installation
------------

System:

    sudo apt-get install git curl
    sudo apt-get install libmysqlclient-dev libpq-dev libev-dev

RVM (Ruby Version Manager):

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm

Source code, Ruby:

    git clone https://github.com/lvee/lvee-engine
    cd lvee-engine
    rvm install $(cat .ruby-version)
    rvm use $(cat .ruby-version)

Ruby Gems:

    gem install bundler
    bundle install

License
-------

[GPL 2.0](https://www.gnu.org/licenses/gpl-2.0.en.html)
