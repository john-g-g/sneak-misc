JUNKFILES = .bash_history .irb_history .pip .ScanSnap .nbems .fldigi .cpan
JUNKFILES += .gdb_history .mysql_history .sqlite_history

default: backup

backup: clean
	@mbsync -X eeqjgmail
	@mbsync -X acidhousegmail
	-rsync -avPhz --delete sneak@datavibe.net:.maildir/ \
		$(HOME)/Documents/Secure/datavibe.maildir/
	@internalbackup.command # to 1tb
	@externalbackup.command # to fw800

clean:
	-rm -rfv ~/tmp/*
	-rm -rfv ~/Library/Caches/*
	-rm -rfv ~/.Trash/*
	-rm -rfv $(JUNKFILES)

size:
	du -sh $(HOME)
