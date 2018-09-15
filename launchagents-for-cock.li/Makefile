default: install

install:
	cp *.plist $(HOME)/Library/LaunchAgents/
	launchctl load -w $(HOME)/Library/LaunchAgents/cloud.sneak.launchagent.*.plist

uninstall:
	cd $(HOME)/Library/LaunchAgents && launchctl unload cloud.sneak.launchagent.*.plist
	cd $(HOME)/Library/LaunchAgents && rm cloud.sneak.launchagent.*.plist
