TARGETS := \
	$(HOME)/Library/Local/bin/update-location-json.sh

.PHONY: install $(TARGETS)

default: install

install: $(TARGETS)

$(HOME)/Library/Local/bin:
	mkdir -p $@

$(HOME)/Library/Local/bin/update-location-json.sh:
	cp $(PWD)/update-workstation-location/update-location-json.sh $@
	chmod +x $@
