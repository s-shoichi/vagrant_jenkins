# emacsインストール
sudo yum -y install gcc
sudo yum -y install ncurses-devel
sudo yum -y install wget.x86_64
cd /usr/local/src
sudo wget http://ftp.gnu.org/pub/gnu/emacs/emacs-25.3.tar.gz
sudo tar zxvf emacs-25.3.tar.gz
cd emacs-25.3
./configure --without-x
sudo make
sudo make install
cd ~/

# Apache、git、unzipのインストール
sudo yum -y install httpd unzip gityosigai

# PHPのインストール。Epel, Remiリポジトリから行います。
sudo yum -y install epel-release
sudo yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo yum -y install --enablerepo=remi,remi-php71 php php-devel php-mbstring php-intl php-mysql php-xml

# MySQLのインストール
sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
sudo yum -y install mysql-community-server

# Cakephpコンポーザーのダウンロートとコンポーザーを/bin下に移動
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# cakephp作成
sudo mkdir /var/www/html/php_training
sudo chown vagrant:vagrant /var/www/html/php_training
chmod 777 /var/www/html/php_training
composer create-project --prefer-dist cakephp/app /var/www/html/php_training/cake_app

# 設定変更
chmod 777 -R /var/www/html/php_training/cake_app/tmp /var/www/html/php_training/cake_app/logs
sudo mv /vagrant/config/httpd.conf /etc/httpd/conf.d/00httpd.conf
sudo mv /vagrant/config/virtualhost.conf /etc/httpd/conf.d/virtualhost.conf
sudo rm /var/www/html/php_training/cake_app/config/app.php
sudo mv /vagrant/config/app.php /var/www/html/php_training/cake_app/config/app.php

# seLinuxを無効化
sudo setenforce 0

#MySQLをVagrant起動時に起動するように設定と起動
sudo systemctl enable mysqld.service
sudo systemctl start mysqld.service

# database作成
mysql -u root < /vagrant/config/init.sql

# ApcheをVagrant起動時に起動するように設定と起動
sudo systemctl enable httpd.service
sudo systemctl start httpd.service


# jenkinsをインストール
# javaインストール
sudo yum install -y java-1.8.0-openjdk
# jenkinsのyumリポジトリ追加
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
# RPMパッケージの公開鍵をインポート
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
# jenkinsのインストール
sudo yum install -y jenkins
#jenkinsをVagrant起動時に起動するように設定と起動(local:8080)
sudo systemctl enable jenkins.service
sudo service jenkins start

# 静的解析ツールのインストール
php /usr/local/bin/composer require "phpmd/phpmd=@stable"
php /usr/local/bin/composer require "phing/phing: *"
php /usr/local/bin/composer require "squizlabs/php_codesniffer=2.*"
vendor/bin/phpcs --config-set vendor/cakephp/cakephp-codesniffer
composer require --dev sebastian/phpcpd
composer install
sudo mv /vagrant/config/build.xml /var/lib/jenkins/build.xml
sudo mv vendor /var/lib/jenkins/vendor
sudo chown jenkins:jenkins -R /var/lib/jenkins/vendor
sudo chown jenkins:jenkins -R /var/lib/jenkins/build.xml
