DESTDIR = 

BOOT = normal
# BOOT=normal : /boot is a directory
# BOOT=flat : / is /boot
# BOOT=none : no /boot

with_libraries64 = no
with_usr_games = no
with_local_games = no
with_multilib = yes
with_extended = yes


utmp = 20
ftp = 11
games = 50



# Build rules

.PHONY: default
default: info

.PHONY: all
all: doc

.PHONY: doc
doc: info pdf ps dvi

.PHONY: info
info: filesystem.info
%.info: info/%.texinfo info/fdl.texinfo
	makeinfo "$<"

.PHONY: pdf
pdf: filesystem.pdf
%.pdf: info/%.texinfo info/fdl.texinfo
	mkdir -p obj
	cd obj ; yes X | texi2pdf ../$<
	mv obj/$@ $@

.PHONY: dvi
dvi: filesystem.dvi
%.dvi: info/%.texinfo info/fdl.texinfo
	mkdir -p obj
	cd obj ; yes X | $(TEXI2DVI) ../$<
	mv obj/$@ $@

.PHONY: ps
ps: filesystem.ps
%.ps: info/%.texinfo info/fdl.texinfo
	mkdir -p obj
	cd obj ; yes X | texi2pdf --ps ../$<
	mv obj/$@ $@


# Install rules

.PHONY: install
install: install-base install-usr install-local install-var install-files install-extended
	[ ! "$$ARCH" = "x86_64" ] || make "DESTDIR=$(DESTDIR)" install-64

.PHONY: install-base
install-base:
	install -d -m755 -- "$(DESTDIR)"/bin
	if [ $(BOOT) = normal ]; then               \
	    install -d -m755 -- "$(DESTDIR)"/boot;  \
	elif [ $(BOOT) = flat ]; then               \
	    ln -s . -- "$(DESTDIR)"/boot;           \
	fi
	install -d -m755 -- "$(DESTDIR)"/dev
	install -d -m755 -- "$(DESTDIR)"/dev/pts
	install -d -m755 -- "$(DESTDIR)"/dev/shm
	install -d -m755 -- "$(DESTDIR)"/etc
	install -d -m755 -- "$(DESTDIR)"/etc/alternatives
	install -d -m755 -- "$(DESTDIR)"/etc/alternatives.providers
	install -d -m755 -- "$(DESTDIR)"/etc/opt
	install -d -m755 -- "$(DESTDIR)"/etc/skel
	install -d -m755 -- "$(DESTDIR)"/etc/profile.d
	install -d -m755 -- "$(DESTDIR)"/etc/ld.so.conf.d
	install -d -m755 -- "$(DESTDIR)"/home
	install -d -m755 -- "$(DESTDIR)"/lib
	install -d -m755 -- "$(DESTDIR)"/lib/pkgconfig
	install -d -m755 -- "$(DESTDIR)"/media
	install -d -m755 -- "$(DESTDIR)"/mnt
	install -d -m755 -- "$(DESTDIR)"/opt
	install -d -m555 -- "$(DESTDIR)"/proc
	install -d -m750 -- "$(DESTDIR)"/root
	install -d -m755 -- "$(DESTDIR)"/run
	install -d -m755 -- "$(DESTDIR)"/sbin
	install -d -m755 -- "$(DESTDIR)"/srv
	install -d -m755 -- "$(DESTDIR)"/srv/db
	install -d -m755 -- "$(DESTDIR)"/srv/ftp
	chgrp $(ftp) -- "$(DESTDIR)"/srv/ftp
	install -d -m755 -- "$(DESTDIR)"/srv/http
	install -d -m555 -- "$(DESTDIR)"/sys
	install -d -m1755 -- "$(DESTDIR)"/tmp

.PHONY: install-usr
install-usr:
	install -d -m755 -- "$(DESTDIR)"/usr
	install -d -m755 -- "$(DESTDIR)"/usr/bin
	ln -s . -- "$(DESTDIR)"/usr/games
	ln -s share/doc -- "$(DESTDIR)"/usr/doc
	ln -s ../lib -- "$(DESTDIR)"/usr/lib
	install -d -m755 -- "$(DESTDIR)"/usr/libexec
	install -d -m755 -- "$(DESTDIR)"/usr/include
	install -d -m755 -- "$(DESTDIR)"/usr/sbin
	install -d -m755 -- "$(DESTDIR)"/usr/share
	install -d -m755 -- "$(DESTDIR)"/usr/share/applications
	install -d -m755 -- "$(DESTDIR)"/usr/share/changelogs
	install -d -m755 -- "$(DESTDIR)"/usr/share/dict
	install -d -m755 -- "$(DESTDIR)"/usr/share/doc
	install -d -m755 -- "$(DESTDIR)"/usr/share/info
	install -d -m755 -- "$(DESTDIR)"/usr/share/licenses
	install -d -m755 -- "$(DESTDIR)"/usr/share/man
	install -d -m755 -- "$(DESTDIR)"/usr/share/man/man{1..8}
	install -d -m755 -- "$(DESTDIR)"/usr/share/misc
	install -d -m755 -- "$(DESTDIR)"/usr/src

.PHONY: install-local
install-local:
	install -d -m755 -- "$(DESTDIR)"/usr/local
	install -d -m755 -- "$(DESTDIR)"/usr/local/bin
	ln -s share/doc -- "$(DESTDIR)"/usr/local/doc
	install -d -m755 -- "$(DESTDIR)"/usr/local/etc
	ln -s . -- "$(DESTDIR)"/usr/local/games
	install -d -m755 -- "$(DESTDIR)"/usr/local/include
	install -d -m755 -- "$(DESTDIR)"/usr/local/lib
	install -d -m755 -- "$(DESTDIR)"/usr/local/libexec
	ln -s share/man -- "$(DESTDIR)"/usr/local/man
	ln -s share/info -- "$(DESTDIR)"/usr/local/info
	install -d -m755 -- "$(DESTDIR)"/usr/local/sbin
	install -d -m755 -- "$(DESTDIR)"/usr/local/share
	install -d -m755 -- "$(DESTDIR)"/usr/local/share/changelog
	install -d -m755 -- "$(DESTDIR)"/usr/local/share/doc
	install -d -m755 -- "$(DESTDIR)"/usr/local/share/info
	install -d -m755 -- "$(DESTDIR)"/usr/local/share/licenses
	install -d -m755 -- "$(DESTDIR)"/usr/local/share/man
	install -d -m755 -- "$(DESTDIR)"/usr/local/share/man/man{1..8}
	install -d -m755 -- "$(DESTDIR)"/usr/local/share/misc
	install -d -m755 -- "$(DESTDIR)"/usr/local/src

.PHONY: install-var
install-var:
	install -d -m755 -- "$(DESTDIR)"/var
	install -d -m755 -- "$(DESTDIR)"/var/cache
	install -d -m755 -- "$(DESTDIR)"/var/empty
	install -d -m775 -- "$(DESTDIR)"/var/games
	chgrp $(games) -- "$(DESTDIR)"/var/games
	install -d -m755 -- "$(DESTDIR)"/var/lib
	install -d -m755 -- "$(DESTDIR)"/var/local
	install -d -m755 -- "$(DESTDIR)"/var/local/cache
	install -d -m775 -- "$(DESTDIR)"/var/local/games
	chgrp $(games) -- "$(DESTDIR)"/var/local/games
	install -d -m755 -- "$(DESTDIR)"/var/local/lib
	install -d -m755 -- "$(DESTDIR)"/var/local/lock
	install -d -m755 -- "$(DESTDIR)"/var/local/log
	ln -s ../../run -- "$(DESTDIR)"/var/local/run
	install -d -m755 -- "$(DESTDIR)"/var/local/spool
	install -d -m755 -- "$(DESTDIR)"/var/lock
	install -d -m755 -- "$(DESTDIR)"/var/log
	install -d -m755 -- "$(DESTDIR)"/var/opt
	install -d -m1755 -- "$(DESTDIR)"/var/mail
	ln -s ../run -- "$(DESTDIR)"/var/run
	install -d -m755 -- "$(DESTDIR)"/var/spool
	ln -s ../mail -- "$(DESTDIR)"/var/spool/mail
	install -d -m1755 -- "$(DESTDIR)"/var/tmp

.PHONY: install-files
install-files:
	touch -- "$(DESTDIR)"/var/log/{btmp,wtmp,lastlog}
	chmod 644 -- "$(DESTDIR)"/var/log/lastlog
	chgrp $(utmp) -- "$(DESTDIR)"/var/log/lastlog
	chmod 644 -- "$(DESTDIR)"/var/log/wtmp
	chmod 600 -- "$(DESTDIR)"/var/log/btmp
	ln -s /proc/self/mounts -- "$(DESTDIR)"/etc/mtab

.PHONY: install-64
install-64:
	ln -s lib -- "$(DESTDIR)"/lib64
	ln -s ../lib64 -- "$(DESTDIR)"/usr/lib64
	install -d -m755 -- "$(DESTDIR)"/usr/libmulti
	install -d -m755 -- "$(DESTDIR)"/usr/local/libmulti


.PHONY: install-extended
install-extended:
	install -d -m755 -- "$(DESTDIR)"/info
	install -d -m1755 -- "$(DESTDIR)"/shared


.PHONY: install-hide
install-hide:
	install -m644 extension-hide -- "$(DESTDIR)"/.hidden


.PHONY: install-slim-extension
install-slim-extension:
	ln -s ./usr/share/applications -- "$(DESTDIR)"/Applications
	ln -s ./home -- "$(DESTDIR)"/Users
	ln -s ./media -- "$(DESTDIR)"/Volumes
	install -d -m755 -- "$(DESTDIR)"/Temporary
	ln -s ../var/tmp -- "$(DESTDIR)"/Temporary/Persistent
	ln -s ../tmp -- "$(DESTDIR)"/Temporary/Transient
	ln -s ../var/cache -- "$(DESTDIR)"/Temporary/Cache
	[ ! $(with_extended) == yes ] || \
	    ln -s ./shared -- "$(DESTDIR)"/Shared\ File


.PHONY: install-extension
install-extension:
	install -d -m755 -- "$(DESTDIR)"/localhost
	install -d -m755 -- "$(DESTDIR)"/localhost/system
	install -d -m755 -- "$(DESTDIR)"/localhost/system/essentials
	ln -s ../../../bin -- "$(DESTDIR)"/localhost/system/essentials/maintenance
	ln -s ../../../sbin -- "$(DESTDIR)"/localhost/system/essentials/system
	ln -s ../../../lib -- "$(DESTDIR)"/localhost/system/essentials/libraries
	[ ! $(with_libraries64) == yes ] || \
	    ln -s ../../../lib64 -- "$(DESTDIR)"/localhost/system/essentials/libraries64
	install -d -m755 -- "$(DESTDIR)"/localhost/system/application
	ln -s ../../../usr/bin -- "$(DESTDIR)"/localhost/system/application/commands
	ln -s ../../../usr/sbin -- "$(DESTDIR)"/localhost/system/application/system
	ln -s ../../../usr/lib -- "$(DESTDIR)"/localhost/system/application/libraries
	[ ! $(with_libraries64) == yes ] || \
	    ln -s ../../../usr/lib64 -- "$(DESTDIR)"/localhost/system/application/libraries64
	[ ! $(with_multilib) == yes ] || \
	    ln -s ../../../usr/libmulti -- "$(DESTDIR)"/localhost/system/application/multilibraries
	ln -s ../../../usr/libexec -- "$(DESTDIR)"/localhost/system/application/execlibraries
	ln -s ../../../usr/include -- "$(DESTDIR)"/localhost/system/application/headers
	ln -s ../../../var/mail -- "$(DESTDIR)"/localhost/system/application/mail
	ln -s ../../../var/games -- "$(DESTDIR)"/localhost/system/application/games
	ln -s ../../boot -- "$(DESTDIR)"/localhost/system/boot
	install -d -m755 -- "$(DESTDIR)"/localhost/system/kernel
	ln -s ../../../dev -- "$(DESTDIR)"/localhost/system/kernel/devices
	ln -s ../../../proc -- "$(DESTDIR)"/localhost/system/kernel/processes
	ln -s ../../../sys -- "$(DESTDIR)"/localhost/system/kernel/access
	ln -s ../../../run -- "$(DESTDIR)"/localhost/system/kernel/state
	ln -s ../../root -- "$(DESTDIR)"/localhost/system/admininstrator
	ln -s ../../var/log -- "$(DESTDIR)"/localhost/system/logs
	ln -s ../../usr/src -- "$(DESTDIR)"/localhost/system/source
	ln -s ../../var/empty -- "$(DESTDIR)"/localhost/system/empty
	ln -s ../../usr/share -- "$(DESTDIR)"/localhost/system/resources
	install -d -m755 -- "$(DESTDIR)"/localhost/system/runtime
	ln -s ../../../var/lock -- "$(DESTDIR)"/localhost/system/runtime/locks
	ln -s ../../../var/lib -- "$(DESTDIR)"/localhost/system/runtime/state
	install -d -m755 -- "$(DESTDIR)"/localhost/temporary
	ln -s ../../var/tmp -- "$(DESTDIR)"/localhost/temporary/persistent
	ln -s ../../tmp -- "$(DESTDIR)"/localhost/temporary/transient
	ln -s ../../dev/shm -- "$(DESTDIR)"/localhost/temporary/shared
	ln -s ../../var/cache -- "$(DESTDIR)"/localhost/temporary/cache
	ln -s ../../var/spool -- "$(DESTDIR)"/localhost/temporary/spool
	ln -s ../../var/opt -- "$(DESTDIR)"/localhost/temporary/large
	install -d -m755  -- "$(DESTDIR)"/localhost/temporary/host
	ln -s ../../../var/local/cache -- "$(DESTDIR)"/localhost/temporary/host/cache
	ln -s ../../../var/local/spool -- "$(DESTDIR)"/localhost/temporary/host/spool
	ln -s ../../mnt -- "$(DESTDIR)"/localhost/temporary/mount
	install -d -m755 -- "$(DESTDIR)"/localhost/applications
	ln -s ../../usr/bin -- "$(DESTDIR)"/localhost/applications/commands
	[ ! $(with_usr_games) == yes ] || \
	    ln -s ../../usr/games -- "$(DESTDIR)"/localhost/applications/games
	ln -s ../../usr/doc -- "$(DESTDIR)"/localhost/applications/documentations
	ln -s ../../usr/share/licenses -- "$(DESTDIR)"/localhost/applications/licenses
	ln -s ../../usr/share/changelog -- "$(DESTDIR)"/localhost/applications/changelogs
	ln -s ../../opt -- "$(DESTDIR)"/localhost/applications/large
	install -d -m755 -- "$(DESTDIR)"/localhost/host
	install -d -m755 -- "$(DESTDIR)"/localhost/host/configurations
	ln -s ../../../etc -- "$(DESTDIR)"/localhost/host/configurations/system
	ln -s ../../../usr/local/etc -- "$(DESTDIR)"/localhost/host/configurations/local
	ln -s ../../../etc/opt -- "$(DESTDIR)"/localhost/host/configurations/large
	ln -s ../../srv -- "$(DESTDIR)"/localhost/host/service
	install -d -m755 -- "$(DESTDIR)"/localhost/host/applications
	ln -s ../../../usr/local/bin -- "$(DESTDIR)"/localhost/host/applications/commands
	[ ! $(with_local_games) == yes ] || \
	    ln -s ../../../usr/local/games -- "$(DESTDIR)"/localhost/host/applications/games
	ln -s ../../../usr/local/doc -- "$(DESTDIR)"/localhost/host/applications/documentations
	ln -s ../../../usr/local/share/licenses -- "$(DESTDIR)"/localhost/host/applications/licenses
	ln -s ../../../usr/local/share/changelogs -- "$(DESTDIR)"/localhost/host/applications/changelogs
	install -d -m755 -- "$(DESTDIR)"/localhost/host/system
	ln -s ../../../usr/local/sbin -- "$(DESTDIR)"/localhost/host/system/commands
	ln -s ../../../usr/local/lib -- "$(DESTDIR)"/localhost/host/system/libraries
	[ ! $(with_multilib) == yes ] || \
	    ln -s ../../../usr/local/libmulti -- "$(DESTDIR)"/localhost/host/system/multilibraries
	ln -s ../../../usr/local/libexec -- "$(DESTDIR)"/localhost/host/system/execlibraries
	ln -s ../../../usr/local/include -- "$(DESTDIR)"/localhost/host/system/headers
	ln -s ../../../usr/local/src -- "$(DESTDIR)"/localhost/host/system/source
	ln -s ../../../usr/local/share -- "$(DESTDIR)"/localhost/host/system/resources
	ln -s ../../../var/local/games -- "$(DESTDIR)"/localhost/host/system/games
	install -d -m755 -- "$(DESTDIR)"/localhost/host/system/runtime
	ln -s ../../../../var/local/lock -- "$(DESTDIR)"/localhost/host/system/runtime/locks
	ln -s ../../../../var/local/lib -- "$(DESTDIR)"/localhost/host/system/runtime/state
	install -d -m755 -- "$(DESTDIR)"/localhost/users
	ln -s ../../home -- "$(DESTDIR)"/localhost/users/private
	install -d -m755 -- "$(DESTDIR)"/localhost/users/public
	[ ! $(with_extended) == yes ] || \
	    ln -s ../../../shared -- "$(DESTDIR)"/localhost/users/public/shared
	[ ! $(with_extended) == yes ] || \
	    ln -s ../../../info -- "$(DESTDIR)"/localhost/users/public/administrated
	ln -s ../../../media -- "$(DESTDIR)"/localhost/users/public/mounted


.PHONY: install-initram
install-initram:
	mkdir -p -- "$(DESTDIR)"/new_root
	mkdir -p -- "$(DESTDIR)"/sbin
	mkdir -p -- "$(DESTDIR)"/lib
	mkdir -p -- "$(DESTDIR)"/hooks
	mkdir -p -- "$(DESTDIR)"/etc
	mkdir -p -- "$(DESTDIR)"/proc
	mkdir -p -- "$(DESTDIR)"/dev
	mkdir -p -- "$(DESTDIR)"/sys
	mkdir -p -- "$(DESTDIR)"/run
	mkdir -p -- "$(DESTDIR)"/tmp
	ln -s sbin -- "$(DESTDIR)"/bin
	ln -s lib -- "$(DESTDIR)"/libexec
	ln -s lib -- "$(DESTDIR)"/lib64
	ln -s . -- "$(DESTDIR)"/usr
	ln -s . -- "$(DESTDIR)"/local
	touch -- "$(DESTDIR)"/etc/fstab
	ln -s /proc/self/mounts -- "$(DESTDIR)"/etc/mtab


.PHONY: install-private
install-private:
	install -d -m755 "$(DESTDIR)$$HOME"/.local
	install -d -m755 "$(DESTDIR)$$HOME"/.config
	install -d -m755 "$(DESTDIR)$$HOME"/.cache
	install -d -m755 "$(DESTDIR)$$HOME"/.spool
	install -d -m755 "$(DESTDIR)$$HOME"/.local/opt
	ln -s ../.config "$(DESTDIR)$$HOME"/.local/etc
	install -d -m755 "$(DESTDIR)$$HOME"/.local/bin
	ln -s bin "$(DESTDIR)$$HOME"/.local/sbin
	ln -s . "$(DESTDIR)$$HOME"/.local/games
	install -d -m755 "$(DESTDIR)$$HOME"/.local/lib
	install -d -m755 "$(DESTDIR)$$HOME"/.local/libexec
	[ ! "$$ARCH" = "x86_64" ] || install -d -m755 "$(DESTDIR)$$HOME"/.local/libmulti
	install -d -m755 "$(DESTDIR)$$HOME"/.local/include
	install -d -m755 "$(DESTDIR)$$HOME"/.local/src
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share/dict
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share/changelog
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share/info
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share/licenses
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share/misc
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share/man
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share/man/man{1..8}
	install -d -m755 "$(DESTDIR)$$HOME"/.local/share/doc
	ln -s share/doc "$(DESTDIR)$$HOME"/.local/doc
	install -d -m755 "$(DESTDIR)$$HOME"/.local/var
	install -d -m755 "$(DESTDIR)$$HOME"/.local/var/games
	install -d -m755 "$(DESTDIR)$$HOME"/.local/var/lib
	install -d -m755 "$(DESTDIR)$$HOME"/.local/var/lock
	install -d -m755 "$(DESTDIR)$$HOME"/.local/var/log
	install -d -m755 "$(DESTDIR)$$HOME"/.local/var/spool
	install -d -m755 "$(DESTDIR)$$HOME"/.local/var/cache


.PHONY: install-skel
install-skel:
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.config
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.cache
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.spool
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/opt
	ln -s ../.config -- "$(DESTDIR)"/etc/skel/.local/etc
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/bin
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/sbin
	ln -s . -- "$(DESTDIR)"/etc/skel/.local/games
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/lib
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/libexec
	[ ! "$$ARCH" = "x86_64" ] || install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/libmulti
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/include
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/src
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share/dict
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share/changelog
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share/info
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share/licenses
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share/misc
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share/man
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share/man/man{1..8}
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/share/doc
	ln -s share/doc -- "$(DESTDIR)"/etc/skel/.local/doc
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/var
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/var/games
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/var/lib
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/var/lock
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/var/log
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/var/spool
	install -d -m755 -- "$(DESTDIR)"/etc/skel/.local/var/cache


.PHONY: install-license
install-license:
	install -d -m755 -- "$(DESTDIR)"/usr/share/licenses/filesystem
	install -m644 COPYING LICENSE -- "$(DESTDIR)"/usr/share/licenses/filesystem

.PHONY: install-doc
install-doc: install-info install-pdf install-ps install-dvi

.PHONY: install-info
install-info: filesystem.info
	install -d -m755 -- "$(DESTDIR)"/usr/share/info
	install -m644 "$<" -- "$(DESTDIR)"/usr/share/info

.PHONY: install-pdf
install-pdf: filesystem.pdf
	install -d -m755 -- "$(DESTDIR)"/usr/share/doc
	install -m644 "$<" -- "$(DESTDIR)"/usr/share/doc

.PHONY: install-ps
install-ps: filesystem.ps
	install -d -m755 -- "$(DESTDIR)"/usr/share/doc
	install -m644 "$<" -- "$(DESTDIR)"/usr/share/doc

.PHONY: install-dvi
install-dvi: filesystem.dvi
	install -d -m755 -- "$(DESTDIR)"/usr/share/doc
	install -m644 "$<" -- "$(DESTDIR)"/usr/share/doc


# Uninstall rules

.PHONY: uninstall
uninstall: uninstall-base uninstall-usr uninstall-local uninstall-var uninstall-files uninstall-extended uninstall-64

.PHONY: uninstall-base
uninstall-base:
	-rmdir -- "$(DESTDIR)"/tmp
	-rmdir -- "$(DESTDIR)"/sys
	-rmdir -- "$(DESTDIR)"/srv/http
	-rmdir -- "$(DESTDIR)"/srv/ftp
	-rmdir -- "$(DESTDIR)"/srv/db
	-rmdir -- "$(DESTDIR)"/srv
	-rmdir -- "$(DESTDIR)"/sbin
	-rmdir -- "$(DESTDIR)"/run
	-rmdir -- "$(DESTDIR)"/root
	-rmdir -- "$(DESTDIR)"/proc
	-rmdir -- "$(DESTDIR)"/opt
	-rmdir -- "$(DESTDIR)"/mnt
	-rmdir -- "$(DESTDIR)"/media
	-rmdir -- "$(DESTDIR)"/lib/pkgconfig
	-rmdir -- "$(DESTDIR)"/lib
	-rmdir -- "$(DESTDIR)"/home
	-rmdir -- "$(DESTDIR)"/etc/ld.so.conf.d
	-rmdir -- "$(DESTDIR)"/etc/profile.d
	-rmdir -- "$(DESTDIR)"/etc/skel
	-rmdir -- "$(DESTDIR)"/etc/opt
	-rmdir -- "$(DESTDIR)"/etc/alternatives.providers
	-rmdir -- "$(DESTDIR)"/etc/alternatives
	-rmdir -- "$(DESTDIR)"/etc
	-rmdir -- "$(DESTDIR)"/dev/shm
	-rmdir -- "$(DESTDIR)"/dev/pts
	-rmdir -- "$(DESTDIR)"/dev
	-rm -- "$(DESTDIR)"/boot
	-rmdir -- "$(DESTDIR)"/boot
	-rmdir -- "$(DESTDIR)"/bin

.PHONY: uninstall-usr
uninstall-usr:
	-rmdir -- "$(DESTDIR)"/usr/src
	-rmdir -- "$(DESTDIR)"/usr/share/misc
	-rmdir -- "$(DESTDIR)"/usr/share/man/man{1..8}
	-rmdir -- "$(DESTDIR)"/usr/share/man
	-rmdir -- "$(DESTDIR)"/usr/share/licenses
	-rmdir -- "$(DESTDIR)"/usr/share/info
	-rmdir -- "$(DESTDIR)"/usr/share/doc
	-rmdir -- "$(DESTDIR)"/usr/share/dict
	-rmdir -- "$(DESTDIR)"/usr/share/changelogs
	-rmdir -- "$(DESTDIR)"/usr/share/applications
	-rmdir -- "$(DESTDIR)"/usr/share
	-rmdir -- "$(DESTDIR)"/usr/sbin
	-rmdir -- "$(DESTDIR)"/usr/include
	-rmdir -- "$(DESTDIR)"/usr/libexec
	-rm -- "$(DESTDIR)"/usr/lib
	-rm -- "$(DESTDIR)"/usr/doc
	-rm -- "$(DESTDIR)"/usr/games
	-rmdir -- "$(DESTDIR)"/usr/bin
	-rmdir -- "$(DESTDIR)"/usr

.PHONY: uninstall-local
uninstall-local:
	-rmdir -- "$(DESTDIR)"/usr/local/src
	-rmdir -- "$(DESTDIR)"/usr/local/share/misc
	-rmdir -- "$(DESTDIR)"/usr/local/share/man/man{1..8}
	-rmdir -- "$(DESTDIR)"/usr/local/share/man
	-rmdir -- "$(DESTDIR)"/usr/local/share/licenses
	-rmdir -- "$(DESTDIR)"/usr/local/share/info
	-rmdir -- "$(DESTDIR)"/usr/local/share/doc
	-rmdir -- "$(DESTDIR)"/usr/local/share/changelog
	-rmdir -- "$(DESTDIR)"/usr/local/share
	-rmdir -- "$(DESTDIR)"/usr/local/sbin
	-rm -- "$(DESTDIR)"/usr/local/info
	-rm -- "$(DESTDIR)"/usr/local/man
	-rmdir -- "$(DESTDIR)"/usr/local/libexec
	-rmdir -- "$(DESTDIR)"/usr/local/lib
	-rmdir -- "$(DESTDIR)"/usr/local/include
	-rm -- "$(DESTDIR)"/usr/local/games
	-rmdir -- "$(DESTDIR)"/usr/local/etc
	-rm -- "$(DESTDIR)"/usr/local/doc
	-rmdir -- "$(DESTDIR)"/usr/local/bin
	-rmdir -- "$(DESTDIR)"/usr/local

.PHONY: uninstall-var
uninstall-var:
	-rmdir -- "$(DESTDIR)"/var/tmp
	-rm -- "$(DESTDIR)"/var/spool/mail
	-rmdir -- "$(DESTDIR)"/var/spool
	-rm -- "$(DESTDIR)"/var/run
	-rmdir -- "$(DESTDIR)"/var/mail
	-rmdir -- "$(DESTDIR)"/var/opt
	-rmdir -- "$(DESTDIR)"/var/log
	-rmdir -- "$(DESTDIR)"/var/lock
	-rmdir -- "$(DESTDIR)"/var/local/spool
	-rm -- "$(DESTDIR)"/var/local/run
	-rmdir -- "$(DESTDIR)"/var/local/log
	-rmdir -- "$(DESTDIR)"/var/local/lock
	-rmdir -- "$(DESTDIR)"/var/local/lib
	-rmdir -- "$(DESTDIR)"/var/local/games
	-rmdir -- "$(DESTDIR)"/var/local/cache
	-rmdir -- "$(DESTDIR)"/var/local
	-rmdir -- "$(DESTDIR)"/var/lib
	-rmdir -- "$(DESTDIR)"/var/games
	-rmdir -- "$(DESTDIR)"/var/empty
	-rmdir -- "$(DESTDIR)"/var/cache
	-rmdir -- "$(DESTDIR)"/var

.PHONY: uninstall-files
uninstall-files:
	-rm -- "$(DESTDIR)"/etc/mtab
	-rm -- "$(DESTDIR)"/var/log/{btmp,wtmp,lastlog}

.PHONY: uninstall-64
uninstall-64:
	-rmdir -- "$(DESTDIR)"/usr/local/libmulti
	-rmdir -- "$(DESTDIR)"/usr/libmulti
	-rm -- "$(DESTDIR)"/usr/lib64
	-rm -- "$(DESTDIR)"/lib64


.PHONY: uninstall-extended
uninstall-extended:
	-rmdir -- "$(DESTDIR)"/shared
	-rmdir -- "$(DESTDIR)"/info


.PHONY: uninstall-hide
uninstall-hide:
	-rm -- "$(DESTDIR)"/.hidden


.PHONY: uninstall-slim-extension
uninstall-slim-extension:
	-rm -- "$(DESTDIR)"/Shared\ File
	-rm -- "$(DESTDIR)"/Temporary/Cache
	-rm -- "$(DESTDIR)"/Temporary/Transient
	-rm -- "$(DESTDIR)"/Temporary/Persistent
	-rmdir -- "$(DESTDIR)"/Temporary
	-rm -- "$(DESTDIR)"/Volumes
	-rm -- "$(DESTDIR)"/Users
	-rm -- "$(DESTDIR)"/Applications


.PHONY: uninstall-extension
uninstall-extension:
	-rm -- "$(DESTDIR)"/localhost/users/public/mounted
	-rm -- "$(DESTDIR)"/localhost/users/public/administrated
	-rm -- "$(DESTDIR)"/localhost/users/public/shared
	-rmdir -- "$(DESTDIR)"/localhost/users/public
	-rm -- "$(DESTDIR)"/localhost/users/private
	-rmdir -- "$(DESTDIR)"/localhost/users
	-rm -- "$(DESTDIR)"/localhost/host/system/runtime/state
	-rm -- "$(DESTDIR)"/localhost/host/system/runtime/locks
	-rmdir -- "$(DESTDIR)"/localhost/host/system/runtime
	-rm -- "$(DESTDIR)"/localhost/host/system/games
	-rm -- "$(DESTDIR)"/localhost/host/system/resources
	-rm -- "$(DESTDIR)"/localhost/host/system/source
	-rm -- "$(DESTDIR)"/localhost/host/system/headers
	-rm -- "$(DESTDIR)"/localhost/host/system/execlibraries
	-rm -- "$(DESTDIR)"/localhost/host/system/multilibraries
	-rm -- "$(DESTDIR)"/localhost/host/system/libraries
	-rm -- "$(DESTDIR)"/localhost/host/system/commands
	-rmdir -- "$(DESTDIR)"/localhost/host/system
	-rm -- "$(DESTDIR)"/localhost/host/applications/changelogs
	-rm -- "$(DESTDIR)"/localhost/host/applications/licenses
	-rm -- "$(DESTDIR)"/localhost/host/applications/documentations
	-rm -- "$(DESTDIR)"/localhost/host/applications/games
	-rm -- "$(DESTDIR)"/localhost/host/applications/commands
	-rmdir -- "$(DESTDIR)"/localhost/host/applications
	-rm -- "$(DESTDIR)"/localhost/host/service
	-rm -- "$(DESTDIR)"/localhost/host/configurations/large
	-rm -- "$(DESTDIR)"/localhost/host/configurations/local
	-rm -- "$(DESTDIR)"/localhost/host/configurations/system
	-rmdir -- "$(DESTDIR)"/localhost/host/configurations
	-rmdir -- "$(DESTDIR)"/localhost/host
	-rm -- "$(DESTDIR)"/localhost/applications/large
	-rm -- "$(DESTDIR)"/localhost/applications/changelogs
	-rm -- "$(DESTDIR)"/localhost/applications/licenses
	-rm -- "$(DESTDIR)"/localhost/applications/documentations
	-rm -- "$(DESTDIR)"/localhost/applications/games
	-rm -- "$(DESTDIR)"/localhost/applications/commands
	-rmdir -- "$(DESTDIR)"/localhost/applications
	-rm -- "$(DESTDIR)"/localhost/temporary/mount
	-rm -- "$(DESTDIR)"/localhost/temporary/host/spool
	-rm -- "$(DESTDIR)"/localhost/temporary/host/cache
	-rmdir  -- "$(DESTDIR)"/localhost/temporary/host
	-rm -- "$(DESTDIR)"/localhost/temporary/large
	-rm -- "$(DESTDIR)"/localhost/temporary/spool
	-rm -- "$(DESTDIR)"/localhost/temporary/cache
	-rm -- "$(DESTDIR)"/localhost/temporary/shared
	-rm -- "$(DESTDIR)"/localhost/temporary/transient
	-rm -- "$(DESTDIR)"/localhost/temporary/persistent
	-rmdir -- "$(DESTDIR)"/localhost/temporary
	-rm -- "$(DESTDIR)"/localhost/system/runtime/state
	-rm -- "$(DESTDIR)"/localhost/system/runtime/locks
	-rmdir -- "$(DESTDIR)"/localhost/system/runtime
	-rm -- "$(DESTDIR)"/localhost/system/resources
	-rm -- "$(DESTDIR)"/localhost/system/empty
	-rm -- "$(DESTDIR)"/localhost/system/source
	-rm -- "$(DESTDIR)"/localhost/system/logs
	-rm -- "$(DESTDIR)"/localhost/system/admininstrator
	-rm -- "$(DESTDIR)"/localhost/system/kernel/state
	-rm -- "$(DESTDIR)"/localhost/system/kernel/access
	-rm -- "$(DESTDIR)"/localhost/system/kernel/processes
	-rm -- "$(DESTDIR)"/localhost/system/kernel/devices
	-rmdir -- "$(DESTDIR)"/localhost/system/kernel
	-rm -- "$(DESTDIR)"/localhost/system/boot
	-rm -- "$(DESTDIR)"/localhost/system/application/games
	-rm -- "$(DESTDIR)"/localhost/system/application/mail
	-rm -- "$(DESTDIR)"/localhost/system/application/headers
	-rm -- "$(DESTDIR)"/localhost/system/application/execlibraries
	-rm -- "$(DESTDIR)"/localhost/system/application/multilibraries
	-rm -- "$(DESTDIR)"/localhost/system/application/libraries64
	-rm -- "$(DESTDIR)"/localhost/system/application/libraries
	-rm -- "$(DESTDIR)"/localhost/system/application/system
	-rm -- "$(DESTDIR)"/localhost/system/application/commands
	-rmdir -- "$(DESTDIR)"/localhost/system/application
	-rm -- "$(DESTDIR)"/localhost/system/essentials/libraries64
	-rm -- "$(DESTDIR)"/localhost/system/essentials/libraries
	-rm -- "$(DESTDIR)"/localhost/system/essentials/system
	-rm -- "$(DESTDIR)"/localhost/system/essentials/maintenance
	-rmdir -- "$(DESTDIR)"/localhost/system/essentials
	-rmdir -- "$(DESTDIR)"/localhost/system
	-rmdir -- "$(DESTDIR)"/localhost


.PHONY: uninstall-initram
uninstall-initram:
	-rm -- "$(DESTDIR)"/etc/mtab
	-rm -- "$(DESTDIR)"/etc/fstab
	-rm -- "$(DESTDIR)"/local
	-rm -- "$(DESTDIR)"/usr
	-rm -- "$(DESTDIR)"/lib64
	-rm -- "$(DESTDIR)"/libexec
	-rm -- "$(DESTDIR)"/bin
	-rmdir -- "$(DESTDIR)"/tmp
	-rmdir -- "$(DESTDIR)"/run
	-rmdir -- "$(DESTDIR)"/sys
	-rmdir -- "$(DESTDIR)"/dev
	-rmdir -- "$(DESTDIR)"/proc
	-rmdir -- "$(DESTDIR)"/etc
	-rmdir -- "$(DESTDIR)"/hooks
	-rmdir -- "$(DESTDIR)"/lib
	-rmdir -- "$(DESTDIR)"/sbin
	-rmdir -- "$(DESTDIR)"/new_root


.PHONY: uninstall-private
uninstall-private:
	-rmdir -- "$(DESTDIR)$$HOME"/.local/var/cache
	-rmdir -- "$(DESTDIR)$$HOME"/.local/var/spool
	-rmdir -- "$(DESTDIR)$$HOME"/.local/var/log
	-rmdir -- "$(DESTDIR)$$HOME"/.local/var/lock
	-rmdir -- "$(DESTDIR)$$HOME"/.local/var/lib
	-rmdir -- "$(DESTDIR)$$HOME"/.local/var/games
	-rmdir -- "$(DESTDIR)$$HOME"/.local/var
	-rm -- "$(DESTDIR)$$HOME"/.local/doc
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share/doc
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share/man/man{1..8}
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share/man
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share/misc
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share/licenses
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share/info
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share/changelog
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share/dict
	-rmdir -- "$(DESTDIR)$$HOME"/.local/share
	-rmdir -- "$(DESTDIR)$$HOME"/.local/src
	-rmdir -- "$(DESTDIR)$$HOME"/.local/include
	-rmdir -- "$(DESTDIR)$$HOME"/.local/libmulti
	-rmdir -- "$(DESTDIR)$$HOME"/.local/libexec
	-rmdir -- "$(DESTDIR)$$HOME"/.local/lib
	-rm -- "$(DESTDIR)$$HOME"/.local/games
	-rm -- "$(DESTDIR)$$HOME"/.local/sbin
	-rmdir -- "$(DESTDIR)$$HOME"/.local/bin
	-rm -- "$(DESTDIR)$$HOME"/.local/etc
	-rmdir -- "$(DESTDIR)$$HOME"/.local/opt
	-rmdir -- "$(DESTDIR)$$HOME"/.spool
	-rmdir -- "$(DESTDIR)$$HOME"/.cache
	-rmdir -- "$(DESTDIR)$$HOME"/.config
	-rmdir -- "$(DESTDIR)$$HOME"/.local


.PHONY: uninstall-skel
uninstall-skel:
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/var/cache
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/var/spool
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/var/log
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/var/lock
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/var/lib
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/var/games
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/var
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/doc
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share/doc
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share/man/man{1..8}
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share/man
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share/misc
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share/licenses
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share/info
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share/changelog
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share/dict
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/share
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/src
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/include
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/libmulti
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/libexec
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/lib
	-rm -- "$(DESTDIR)"/etc/skel/.local/games
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/sbin
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/bin
	-rm -- "$(DESTDIR)"/etc/skel/.local/etc
	-rmdir -- "$(DESTDIR)"/etc/skel/.local/opt
	-rmdir -- "$(DESTDIR)"/etc/skel/.spool
	-rmdir -- "$(DESTDIR)"/etc/skel/.cache
	-rmdir -- "$(DESTDIR)"/etc/skel/.config
	-rmdir -- "$(DESTDIR)"/etc/skel/.local


.PHONY: uninstall-license
uninstall-license:
	-rm -- "$(DESTDIR)"/usr/share/licenses/filesystem/COPYING
	-rm -- "$(DESTDIR)"/usr/share/licenses/filesystem/LICENSE
	-rmdir -- "$(DESTDIR)"/usr/share/licenses/filesystem

.PHONY: uninstall-doc
uninstall-doc: uninstall-info uninstall-pdf uninstall-ps uninstall-dvi

.PHONY: uninstall-info
uninstall-info:
	-rm -- "$(DESTDIR)"/usr/share/info/filesystem.info

.PHONY: uninstall-pdf
uninstall-pdf:
	-rm -- "$(DESTDIR)"/usr/share/doc/filesystem.pdf

.PHONY: uninstall-ps
uninstall-ps:
	-rm -- "$(DESTDIR)"/usr/share/doc/filesystem.ps

.PHONY: uninstall-dvi
uninstall-dvi:
	-rm -- "$(DESTDIR)"/usr/share/doc/filesystem.dvi


# Clean rules

.PHONY: clean
clean:
	-rm -f obj {*,*/*}.{aux,cp,fn,info,ky,log,pdf,ps,dvi,pg,toc,tp,vr,gz}

