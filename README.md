# vmkube
Vagrant definition to configure a minikube lab

## Vagrant box
https://app.vagrantup.com/moondly/boxes/vmkube

## Start minikube using existing vagrant box
```
vagrant up
vagrant ssh
sudo -E minikube start
```

## Build a new vagrant box
```
make
```
The box will be available in `output.box`