JUNKFILES = .bash_history .irb_history .pip .ScanSnap .nbems .fldigi .cpan
JUNKFILES += .gdb_history .mysql_history .sqlite_history
YYYYMM := $(shell date +%Y%m)

NO_COLOR = \033[0m
O1_COLOR = \033[0;01m
O2_COLOR = \033[32;01m

PREFIX = "$(O2_COLOR)==>$(O1_COLOR)"
SUFFIX = "$(NO_COLOR)"

default: backup

backup: clean
	@echo $(PREFIX) $@ $(SUFFIX)
	cd ~/Documents/datavibe/backup && make
	offlineimap
	rsync -e "ssh -c arcfour -o Compression=no -x" \
		-avPhzy --delete sneak@datavibe.net:.maildir/ \
		$(HOME)/Documents/Archival/mail/sneak.datavibe.net.maildir/
	rsync -e "ssh -c arcfour -o Compression=no -x" \
		-avPhzy --delete $(HOME)/Documents/Archival/mail/ \
		sneak@datavibe.net:.mailbackup/
	backup.command

clean:
	@echo $(PREFIX) $@ $(SUFFIX)
	@-rm -rf ~/tmp/*
	@-rm -rf ~/Library/Caches/*
	@-rm -rf ~/.Trash/*
	@-rm -rf $(JUNKFILES)
	-mkdir -p $(HOME)/Documents/$(YYYYMM)
	-mv $(HOME)/Desktop/* $(HOME)/Documents/$(YYYYMM)

size:
	du -sh $(HOME)
