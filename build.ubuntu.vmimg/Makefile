default: gen

gen:
	vagrant destroy -f
	vagrant up

sync:
	rsync -avP ./make.sh root@nue1d0.datavibe.net:/storage/buildimage/make.sh
