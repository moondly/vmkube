DOCKER_VERSION = '5:19.03.7~3-0~ubuntu-bionic'
KUBERNETES_VERSION = '1.17.3'
MINIKUBE_VERSION = '1.8.0'

CPUS = '4'
MEMORY = '8192'

#------------------ No need to change anything below this line -----------
$dockerscript = <<-SCRIPT
echo I am provisioning docker...
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce=#{DOCKER_VERSION} docker-ce-cli=#{DOCKER_VERSION} containerd.io
sudo usermod -aG docker vagrant

SCRIPT

$minikubescript = <<SCRIPT
#!/bin/bash
#Install minikube
echo "Downloading Minikube"
curl -q -Lo minikube https://storage.googleapis.com/minikube/releases/v#{MINIKUBE_VERSION}/minikube-linux-amd64 2>/dev/null
chmod +x minikube 
sudo mv minikube /usr/local/bin/

#Install kubectl
echo "Downloading Kubectl"
curl -q -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v#{KUBERNETES_VERSION}/bin/linux/amd64/kubectl 2>/dev/null
chmod +x kubectl 
sudo mv kubectl /usr/local/bin/

#Setup minikube
echo "127.0.0.1 minikube minikube." | sudo tee -a /etc/hosts
mkdir -p $HOME/.minikube
mkdir -p $HOME/.kube
touch $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# Permissions
sudo chown -R $USER:$USER $HOME/.kube
sudo chown -R $USER:$USER $HOME/.minikube
export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
export KUBECONFIG=$HOME/.kube/config

# Disable SWAP since is not supported on a kubernetes cluster
sudo swapoff -a
sudo sed -i '/swap_1/d' /etc/fstab
sudo rm -rf /dev/dm-1

## Start minikube 
sudo -E minikube config set memory #{MEMORY}
sudo -E minikube start -v 4 --vm-driver none --kubernetes-version v#{KUBERNETES_VERSION} --bootstrapper kubeadm 

## Addons 
#sudo -E minikube addons enable ingress

## Configure vagrant clients dir
printf "export MINIKUBE_WANTUPDATENOTIFICATION=false\n" >> /home/vagrant/.bashrc
printf "export MINIKUBE_WANTREPORTERRORPROMPT=false\n" >> /home/vagrant/.bashrc
printf "export MINIKUBE_HOME=/home/vagrant\n" >> /home/vagrant/.bashrc
printf "export CHANGE_MINIKUBE_NONE_USER=true\n" >> /home/vagrant/.bashrc
printf "export KUBECONFIG=/home/vagrant/.kube/config\n" >> /home/vagrant/.bashrc
printf "source /etc/bash_completion\n" >> /home/vagrant/.bashrc
printf "source <(kubectl completion bash)\n" >> /home/vagrant/.bashrc

# extras
sudo apt-get -y install bash-completion

# Permissions
sudo chown -R $USER:$USER $HOME/.kube
sudo chown -R $USER:$USER $HOME/.minikube

# Enforce sysctl 
sudo sysctl -w vm.max_map_count=262144
sudo echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.d/90-vm_max_map_count.conf
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "#{CPUS}"] # set number of vcpus
    vb.customize ["modifyvm", :id, "--memory", "#{MEMORY}"] # set amount of memory allocated vm memory
  end

  config.vm.provision "shell", inline: $dockerscript, privileged: false
  config.vm.provision "shell", inline: $minikubescript, privileged: false

end