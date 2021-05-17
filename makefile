#!

.PHONY: clean guile

default: guile
	kaldiwhg.scm

kaldiwhg.scm: kaldiwhg.guile guile.scm kaldiwhg.dscm kaldiwhg.pscm
	cat $^ > $@
	echo "(asr->graph-main (command-line))" >> $@
	chmod 755 $@


guile: kaldiwhg.scm

kaldiwhg.dscm: #kaldiwhg.dep
	scmdeploy kaldiwhg

clean:
	rm kaldiwhg.bin kaldiwhg.o kaldiwhg.scm

realclean:
	rm kaldiwhg.dscm

# internal targets:

kaldiwhg.bin: kaldiwhg.bgl kaldiwhg.pscm
	bigloo -I ~/parser -g2 -O5 -o $@ -srfi debug -srfi srfi-1 -ldopt "-static" $<
