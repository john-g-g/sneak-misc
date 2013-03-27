JUNKFILES = .bash_history .irb_history .pip .ScanSnap .nbems .fldigi .cpan
JUNKFILES += .gdb_history .mysql_history .sqlite_history
YYYYMM := $(shell date +%Y%m)

NO_COLOR = \033[0m
O1_COLOR = \033[0;01m
O2_COLOR = \033[32;01m

PREFIX = "$(O2_COLOR)==>$(O1_COLOR)"
SUFFIX = "$(NO_COLOR)"

default: backup

backup: clean mailoffsite databackup

dvbackup:
	@echo $(PREFIX) $@ $(SUFFIX)
	cd ~/Documents/datavibe/backup && make

imapbackup:
	offlineimap
	rsync -e "ssh -c arcfour -o Compression=no -x" \
		-avPhzy --delete sneak@datavibe.net:.maildir/ \
		$(HOME)/Documents/Archival/mail/sneak.datavibe.net.maildir/

mailoffsite: imapbackup
	rsync -e "ssh -c arcfour -o Compression=no -x" \
		-avPhzy --delete $(HOME)/Documents/Archival/mail/ \
		sneak@datavibe.net:.mailbackup/

databackup: dvbackup imapbackup
	backup.command

cleanup:
	-mkdir -p $(HOME)/Documents/$(YYYYMM)
	-mv $(HOME)/Desktop/* $(HOME)/Documents/$(YYYYMM)

clean: cleanup
	@echo $(PREFIX) $@ $(SUFFIX)
	@-rm -rf ~/tmp/*
	@-rm -rf ~/Library/Caches/*
	@-rm -rf ~/.Trash/*
	@-rm -rf $(JUNKFILES)

size:
	du -sh $(HOME)
