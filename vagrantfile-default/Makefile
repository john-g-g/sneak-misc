UPKGS := build-essential 

default: login

login: up
	vagrant ssh -c 'sudo envdir /etc/env su - root'

up:
	vagrant up

provision:
	vagrant provision

clean:
	vagrant destroy -f
	rm -rf .vagrant

inside:
	apt-get remove -y chef* puppet*
	apt-get install -y $(UPKGS)
	# DO STUFF HERE
