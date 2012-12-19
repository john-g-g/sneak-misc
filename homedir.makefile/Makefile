JUNKFILES = .bash_history .irb_history .pip .ScanSnap .nbems .fldigi .cpan
JUNKFILES += .gdb_history .mysql_history .sqlite_history
YYYYMM := $(shell date +%Y%m)

default: backup

backup: clean
	mbsync eeqjgmail
	mbsync acidhousegmail
	-rsync -avPhz --delete sneak@datavibe.net:.maildir/ \
		$(HOME)/Documents/Secure/datavibe.maildir/
	@internalbackup.command # to 1tb
	@externalbackup.command # to fw800

clean:
	-rm -rfv ~/tmp/*
	-rm -rfv ~/Library/Caches/*
	-rm -rfv ~/.Trash/*
	-rm -rfv $(JUNKFILES)
	-mkdir -p $(HOME)/Documents/$(YYYYMM)
	-mv $(HOME)/Desktop/* $(HOME)/Documents/$(YYYYMM)

size:
	du -sh $(HOME)
