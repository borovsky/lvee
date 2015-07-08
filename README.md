== Conference engine

Originally it was created for support http://lvee.org:"LVEE conference"

Now it is been rewriting to support running any conference.


== Installation

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install $(cat .ruby-version)
rvm use $(cat .ruby-version)