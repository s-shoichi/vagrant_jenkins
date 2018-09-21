Vagrant.configure("2") do |config|
  # box名
  config.vm.box = "centos/7"

  # 仮想マシンのネットワーク環境設定
  # "private_network"を指定するとホストOSからのみアクセス可
  # ネットワークの設定
  config.vm.network :private_network, ip: "192.168.32.21"

  # プロバイダの指定
  config.vm.provider "virtualbox" do |vb|
    # guiはいらない
    vb.gui = false
    # 仮想マシンの名前
    vb.name = "jenkins"
    # 仮想マシンが使うメモリ(MB)
    vb.memory = "2048"
  end

  # autoアップデートを無効にする
  if Object.const_defined? 'VagrantVbguest'
    config.vbguest.auto_update = false
    config.vbguest.no_remote = true
  end

  config.vm.provision "shell", :path => "provision.sh", :privileged => false
end
