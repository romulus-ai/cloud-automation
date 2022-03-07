Vagrant.configure("2") do |config|

  public_key = File.read("/Users/thomasbruckmann/.ssh/id_rsa.pub")

  config.vm.provision :shell, :inline =>"
    echo 'Copying public SSH Keys to the VM'
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    echo '#{public_key}' >> /root/.ssh/authorized_keys
    chmod -R 600 /root/.ssh/authorized_keys
    ", privileged: true

  config.vm.define "cloudtest" do |cloudtest|
    cloudtest.vm.hostname = "cloudtest"
    cloudtest.vm.network "public_network", bridge: "en0: WLAN (Wireless)", ip: "192.168.178.201"
    cloudtest.vm.box = "bento/ubuntu-20.04"
    cloudtest.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
    end
    cloudtest.vm.disk :disk, name: "data1", size: "2GB"
    cloudtest.vm.disk :disk, name: "data2", size: "2GB"
    cloudtest.vm.disk :disk, name: "cache", size: "1GB"
    cloudtest.vm.disk :disk, name: "backup", size: "2GB"
  end
end