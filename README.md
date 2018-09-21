jenkins:192.168.32.21:8080  
cakephp:192.168.32.21  

 # 前提
・VirtualBox  
・vagrant  
・GitBashもしくはputty等  

 # 初期設定
 * cd ~/project/app

 #zipダウンロードして配置の場合
 * project配下に解答した中身を配置

 #git cloneの場合
 * git clone https://github.com/s-shoichi/vagrant_jenkins.git

 * vagrant init
 * vagrant up(自動で設定)

 # jenkins
 ### ログイン後～
1.Jenkinsの管理>プラグインの管理  
2.タブの利用可能を選択
* php
* Phing
* Checkstyle(phpcs)
* PMD(phpmd)
* DRY(phpcpd)

をインストール

3.新規ジョブ作成
 * フリースタイル

4.「ビルド」  
 * シェルの実行・・・  
 */var/lib/jenkins/vendor/phing/phing/bin/phing -buildfile /var/lib/jenkins/build.xml*  
もしくは、  
 */var/lib/jenkins/vendor/phing/phing/bin/phing -logger phing.listener.DefaultLogger*  
これのどちらか。

5.「ビルド後の処理」
 * Checkstyle警告の集計・・・reports/phpcs.xml
 * PMD警告の集計・・・reports/phpmd.xml
 * 重複コードの分析・・・reports/phpcpd.xml


 # configファイルの中身（vagrant up時に使用）
 * httpd.conf・・・Apacheの設定ファイル。conf.dに追加で配置
 * virtualhost.conf・・・Apacheの設定ファイル。conf.dに追加で配置
 * app.php・・・phpのMySQLの設定ファイル。
 * build.xml・・・Jenkinsの設定ファイル。
 * init.sql・・・MysqlのDatabase作成ファイル。