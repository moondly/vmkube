build: 
	rm output.box || true
	vagrant destroy
	vagrant up
	vagrant ssh -c "minikube stop"
	vagrant ssh -c "sudo apt-get clean"
	vagrant ssh -c "cat /dev/null > ~/.bash_history && history -c"
	vagrant ssh -c "sudo dd if=/dev/zero of=/EMPTY bs=1M || sudo rm -f /EMPTY" 
	vagrant package --output output.box
	shasum output.box
