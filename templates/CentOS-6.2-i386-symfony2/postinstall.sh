#http://chrisadams.me.uk/2010/05/10/setting-up-a-centos-base-box-for-development-and-testing-with-vagrant/

date > /etc/vagrant_box_build_time

cat > /etc/yum.repos.d/puppetlabs.repo << EOM
[puppetlabs]
name=puppetlabs
baseurl=http://yum.puppetlabs.com/el/6/products/\$basearch
enabled=1
gpgcheck=0
EOM

cat > /etc/yum.repos.d/epel.repo << EOM
[epel]
name=epel
baseurl=http://download.fedoraproject.org/pub/epel/6/\$basearch
enabled=1
gpgcheck=0
EOM

rpm -Uvh http://download.fedora.redhat.com/pub/epel/6/i386/epel-release-6-5.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

yum -y install puppet facter ruby-devel rubygems 
yum -y erase wireless-tools gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y --enablerepo=remi install httpd httpd-devel php php-devel php-common php-pecl-apc php-cli php-pear php-pdo php-mysql php-pgsql php-pecl-mongo php-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml php-intl php-pecl-xdebug mysql mysql-server ImageMagick ImageMagick-devel pcre pcre-devel git clamav-devel clamd  
yum -y clean all

gem install --no-ri --no-rdoc chef

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Install Clam PHP Extension
cd /tmp
wget http://kent.dl.sourceforge.net/project/php-clamav/0.15/php-clamav_0.15.6.tar.gz
tar -xvzf php-clamav_0.15.6.tar.gz
cd php-clamav-0.15.6/
phpize
./configure --with-clamav
make
cp modules/clamav.so /usr/lib/php/modules/

cat > /etc/php.d/clamav.ini << EOM
extension=clamav.so
EOM

# Install PHPUnit
pear config-set auto_discover 1
pear install pear.phpunit.de/PHPUnit phpunit/DbUnit phpunit/PHPUnit_Selenium phpunit/PHPUnit_Story phpunit/PHPUnit_SkeletonGenerator phpunit/PHP_Invoker

service httpd start
service mysqld start
service clamd start

chkconfig --levels 235 httpd on
chkconfig --levels 235 mysqld on
chkconfig --levels 235 clamd on

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm VBoxGuestAdditions_$VBOX_VERSION.iso

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

dd if=/dev/zero of=/tmp/clean || rm /tmp/clean

exit