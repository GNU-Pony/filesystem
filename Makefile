DESTDIR = 

BOOT = normal
# BOOT=normal : /boot is a directory
# BOOT=flat : / is /boot
# BOOT=none : no /boot

utmp = 20
ftp = 11
games = 50


install: install-base install-usr install-local install-var install-logs install-extended
	[ ! "$$ARCH" = "x86_64" ] || make "DESTDIR=$(DESTDIR)" install-64

install-base:
	install -d -m755 "$(DESTDIR)"/bin
	if [ $BOOT = normal ]; then                 \
	    install -d -m755 "$(DESTDIR)"/boot;     \
	elif [ $BOOT = flat ]; then                 \
	    ln -s . "$(DESTDIR)"/boot;              \
	fi
	install -d -m755 "$(DESTDIR)"/dev
	install -d -m755 "$(DESTDIR)"/dev/shm
	install -d -m755 "$(DESTDIR)"/etc
	install -d -m755 "$(DESTDIR)"/etc/opt
	install -d -m755 "$(DESTDIR)"/etc/skel
	install -d -m755 "$(DESTDIR)"/etc/profile.d
	install -d -m755 "$(DESTDIR)"/etc/ld.so.conf.d
	install -d -m755 "$(DESTDIR)"/home
	install -d -m755 "$(DESTDIR)"/lib
	install -d -m755 "$(DESTDIR)"/lib/pkgconfig
	install -d -m755 "$(DESTDIR)"/media
	install -d -m755 "$(DESTDIR)"/mnt
	install -d -m755 "$(DESTDIR)"/opt
	install -d -m555 "$(DESTDIR)"/proc
	install -d -m750 "$(DESTDIR)"/root
	install -d -m755 "$(DESTDIR)"/run
	install -d -m755 "$(DESTDIR)"/sbin
	install -d -m755 "$(DESTDIR)"/srv
	install -d -m755 "$(DESTDIR)"/srv/db
	install -d -m755 "$(DESTDIR)"/srv/ftp
	chgrp $(ftp) "$(DESTDIR)"/srv/ftp
	install -d -m755 "$(DESTDIR)"/srv/http
	install -d -m555 "$(DESTDIR)"/sys
	install -d -m1755 "$(DESTDIR)"/tmp

install-usr:
	install -d -m755 "$(DESTDIR)"/usr
	install -d -m755 "$(DESTDIR)"/usr/bin
	ln -s bin "$(DESTDIR)"/usr/games
	install -d -m755 "$(DESTDIR)"/usr/doc
	ln -s ../lib "$(DESTDIR)"/usr/lib
	install -d -m755 "$(DESTDIR)"/usr/libexec
	install -d -m755 "$(DESTDIR)"/usr/include
	install -d -m755 "$(DESTDIR)"/usr/sbin
	install -d -m755 "$(DESTDIR)"/usr/share
	install -d -m755 "$(DESTDIR)"/usr/share/changelogs
	install -d -m755 "$(DESTDIR)"/usr/share/dict
	ln -s ../doc "$(DESTDIR)"/usr/share/doc
	install -d -m755 "$(DESTDIR)"/usr/share/info
	install -d -m755 "$(DESTDIR)"/usr/share/licenses
	install -d -m755 "$(DESTDIR)"/usr/share/man
	install -d -m755 "$(DESTDIR)"/usr/share/man/man{1..8}
	install -d -m755 "$(DESTDIR)"/usr/share/misc
	install -d -m755 "$(DESTDIR)"/usr/src

install-local:
	install -d -m755 "$(DESTDIR)"/usr/local
	install -d -m755 "$(DESTDIR)"/usr/local/bin
	install -d -m755 "$(DESTDIR)"/usr/local/doc
	install -d -m755 "$(DESTDIR)"/usr/local/etc
	ln -s bin "$(DESTDIR)"/usr/local/games
	install -d -m755 "$(DESTDIR)"/usr/local/include
	install -d -m755 "$(DESTDIR)"/usr/local/lib
	install -d -m755 "$(DESTDIR)"/usr/local/libexec
	ln -s share/man "$(DESTDIR)"/usr/local/man
	ln -s share/info "$(DESTDIR)"/usr/local/info
	install -d -m755 "$(DESTDIR)"/usr/local/sbin
	install -d -m755 "$(DESTDIR)"/usr/local/share
	install -d -m755 "$(DESTDIR)"/usr/local/share/changelog
	ln -s ../doc "$(DESTDIR)"/usr/local/share/doc
	install -d -m755 "$(DESTDIR)"/usr/local/share/info
	install -d -m755 "$(DESTDIR)"/usr/local/share/licenses
	install -d -m755 "$(DESTDIR)"/usr/local/share/man
	install -d -m755 "$(DESTDIR)"/usr/local/share/man/man{1..8}
	install -d -m755 "$(DESTDIR)"/usr/local/src

install-var:
	install -d -m755 "$(DESTDIR)"/var
	install -d -m755 "$(DESTDIR)"/var/cache
	install -d -m755 "$(DESTDIR)"/var/empty
	install -d -m775 "$(DESTDIR)"/var/games
	chgrp $(games) "$(DESTDIR)"/var/games
	install -d -m755 "$(DESTDIR)"/var/lib
	install -d -m755 "$(DESTDIR)"/var/local
	install -d -m755 "$(DESTDIR)"/var/lock
	install -d -m755 "$(DESTDIR)"/var/log
	install -d -m755 "$(DESTDIR)"/var/opt
	install -d -m1755 "$(DESTDIR)"/var/mail
	ln -s ../run "$(DESTDIR)"/var/run
	install -d -m755 "$(DESTDIR)"/var/spool
	ln -s ../mail "$(DESTDIR)"/var/spool/mail
	install -d -m1755 "$(DESTDIR)"/var/tmp

install-logs:
	touch "$(DESTDIR)"/var/log/{btmp,wtmp,lastlog}
	chmod 644 "$(DESTDIR)"/var/log/lastlog
	chgrp $(utmp) "$(DESTDIR)"/var/log/lastlog
	chmod 644 "$(DESTDIR)"/var/log/wtmp
	chmod 600 "$(DESTDIR)"/var/log/btmp

install-64:
	ln -s lib "$(DESTDIR)"/lib64
	ln -s ../lib64 "$(DESTDIR)"/usr/lib64
	install -d -m755 "$(DESTDIR)"/usr/libmulti
	install -d -m755 "$(DESTDIR)"/usr/local/libmulti

install-extended:
	install -d -m755 "$(DESTDIR)"/info
	install -d -m1755 "$(DESTDIR)"/share


with_libraries64 = no
with_usr_games = no
with_local_games = no
with_multilib = yes
with_extended = yes

install-extension:
	install -m644 extension-hide "$(DESTDIR)"/.hidden
	install -d -m755 "$(DESTDIR)"/localhost
	install -d -m755 "$(DESTDIR)"/localhost/system
	install -d -m755 "$(DESTDIR)"/localhost/system/essentials
	ln -s ../../../bin "$(DESTDIR)"/localhost/system/essentials/maintainance
	ln -s ../../../sbin "$(DESTDIR)"/localhost/system/essentials/system
	ln -s ../../../lib "$(DESTDIR)"/localhost/system/essentials/libraries
	[ ! $(with_libraries64) == yes ] || \
	    ln -s ../../../lib64 "$(DESTDIR)"/localhost/system/essentials/libraries64
	install -d -m755 "$(DESTDIR)"/localhost/system/application
	ln -s ../../../usr/bin "$(DESTDIR)"/localhost/system/application/commands
	ln -s ../../../usr/sbin "$(DESTDIR)"/localhost/system/application/system
	ln -s ../../../usr/lib "$(DESTDIR)"/localhost/system/application/libraries
	[ ! $(with_libraries64) == yes ] || \
	    ln -s ../../../usr/lib64 "$(DESTDIR)"/localhost/system/application/libraries64
	[ ! $(with_multilib) == yes ] || \
	    ln -s ../../../usr/libmulti "$(DESTDIR)"/localhost/system/application/multilibraries
	ln -s ../../../usr/libexec "$(DESTDIR)"/localhost/system/application/execlibraries
	ln -s ../../../usr/include "$(DESTDIR)"/localhost/system/application/headers
	ln -s ../../../var/mail "$(DESTDIR)"/localhost/system/application/mail
	ln -s ../../../var/games "$(DESTDIR)"/localhost/system/application/games
	ln -s ../../boot "$(DESTDIR)"/localhost/system/boot
	install -d -m755 "$(DESTDIR)"/localhost/system/kernel
	ln -s ../../../dev "$(DESTDIR)"/localhost/system/kernel/devices
	ln -s ../../../proc "$(DESTDIR)"/localhost/system/kernel/processes
	ln -s ../../../sys "$(DESTDIR)"/localhost/system/kernel/access
	ln -s ../../../run "$(DESTDIR)"/localhost/system/kernel/state
	ln -s ../../root "$(DESTDIR)"/localhost/system/admininstrator
	ln -s ../../var/log "$(DESTDIR)"/localhost/system/logs
	ln -s ../../usr/src "$(DESTDIR)"/localhost/system/source
	ln -s ../../var/empty "$(DESTDIR)"/localhost/system/empty
	ln -s ../../usr/share "$(DESTDIR)"/localhost/system/resources
	install -d -m755 "$(DESTDIR)"/localhost/system/runtime
	ln -s ../../../var/lock "$(DESTDIR)"/localhost/system/runtime/locks
	ln -s ../../../var/lib "$(DESTDIR)"/localhost/system/runtime/state
	install -d -m755 "$(DESTDIR)"/localhost/temporary
	ln -s ../../../var/tmp "$(DESTDIR)"/localhost/temporary/persistent
	ln -s ../../../tmp "$(DESTDIR)"/localhost/temporary/transient
	ln -s ../../../dev/shm "$(DESTDIR)"/localhost/temporary/shared
	ln -s ../../../var/cache "$(DESTDIR)"/localhost/temporary/cache
	ln -s ../../../var/spool "$(DESTDIR)"/localhost/temporary/spool
	ln -s ../../../var/opt "$(DESTDIR)"/localhost/temporary/large
	ln -s ../../../ "$(DESTDIR)"/localhost/temporary/host
	ln -s ../../../var/local/cache "$(DESTDIR)"/localhost/temporary/host/cache
	ln -s ../../../var/local/spool "$(DESTDIR)"/localhost/temporary/host/spool
	ln -s ../../mnt "$(DESTDIR)"/localhost/temporary/mount
	install -d -m755 "$(DESTDIR)"/localhost/applications
	ln -s ../../usr/bin "$(DESTDIR)"/localhost/applications/commands
	[ ! $(with_usr_games) == yes ] \
	    ln -s ../../usr/bin "$(DESTDIR)"/localhost/applications/games
	ln -s ../../usr/doc "$(DESTDIR)"/localhost/applications/documentations
	ln -s ../../usr/share/licenses "$(DESTDIR)"/localhost/applications/licenses
	ln -s ../../usr/share/changelog "$(DESTDIR)"/localhost/applications/changelogs
	ln -s ../../opt "$(DESTDIR)"/localhost/applications/large
	install -d -m755 "$(DESTDIR)"/localhost/host
	install -d -m755 "$(DESTDIR)"/localhost/host/configurations
	ln -s ../../../etc "$(DESTDIR)"/localhost/host/configurations/system
	ln -s ../../../usr/local/etc "$(DESTDIR)"/localhost/host/configurations/local
	ln -s ../../../etc/opt "$(DESTDIR)"/localhost/host/configurations/large
	ln -s ../../srv "$(DESTDIR)"/localhost/host/service
	install -d -m755 "$(DESTDIR)"/localhost/host/applications
	ln -s ../../../usr/local/bin "$(DESTDIR)"/localhost/host/applications/commands
	[ ! $(with_local_games) == yes ] \
	    ln -s ../../../usr/local/games "$(DESTDIR)"/localhost/host/applications/games
	ln -s ../../../usr/local/doc "$(DESTDIR)"/localhost/host/applications/documentations
	ln -s ../../../usr/local/share/licenses "$(DESTDIR)"/localhost/host/applications/licenses
	ln -s ../../../usr/local/share/changelog "$(DESTDIR)"/localhost/host/applications/changelogs
	install -d -m755 "$(DESTDIR)"/localhost/host/system
	ln -s ../../../usr/local/sbin "$(DESTDIR)"/localhost/host/system/commands
	ln -s ../../../usr/local/lib "$(DESTDIR)"/localhost/host/system/libraries
	[ ! $(with_multilib) == yes ] || \
	    ln -s ../../../usr/local/libmulti "$(DESTDIR)"/localhost/host/system/multilibraries
	ln -s ../../../usr/local/libexec "$(DESTDIR)"/localhost/host/system/execlibraries
	ln -s ../../../usr/local/include "$(DESTDIR)"/localhost/host/system/headers
	ln -s ../../../usr/local/src "$(DESTDIR)"/localhost/host/system/source
	ln -s ../../../usr/local/share "$(DESTDIR)"/localhost/host/system/resources
	ln -s ../../../var/local/games "$(DESTDIR)"/localhost/host/system/games
	install -d -m755 "$(DESTDIR)"/localhost/host/system/runtime
	ln -s ../../../../var/local/lock "$(DESTDIR)"/localhost/host/system/runtime/locks
	ln -s ../../../../var/local/lib "$(DESTDIR)"/localhost/host/system/runtime/state
	install -d -m755 "$(DESTDIR)"/localhost/users
	ln -s ../../home "$(DESTDIR)"/localhost/users/private
	install -d -m755 "$(DESTDIR)"/localhost/users/public
	ln -s ../../../share "$(DESTDIR)"/localhost/users/public/shared
	ln -s ../../../info "$(DESTDIR)"/localhost/users/public/administrated
	ln -s ../../../media "$(DESTDIR)"/localhost/users/public/mounted


install-initram:
	mkdir -p "$(DESTDIR)"/new_root
	mkdir -p "$(DESTDIR)"/sbin
	mkdir -p "$(DESTDIR)"/lib
	mkdir -p "$(DESTDIR)"/hooks
	mkdir -p "$(DESTDIR)"/etc
	mkdir -p "$(DESTDIR)"/proc
	mkdir -p "$(DESTDIR)"/dev
	mkdir -p "$(DESTDIR)"/sys
	mkdir -p "$(DESTDIR)"/run
	mkdir -p "$(DESTDIR)"/tmp
	ln -s sbin "$(DESTDIR)"/bin
	ln -s lib "$(DESTDIR)"/libexec
	ln -s lib "$(DESTDIR)"/lib64
	ln -s . "$(DESTDIR)"/usr
	ln -s . "$(DESTDIR)"/local
	touch "$(DESTDIR)"/etc/fstab
	ln -s /proc/self/mount "$(DESTDIR)"/etc/mtab


install-private:
	install -d -m755 "$(DESTDIR)$$HOME"/.local
	install -d -m755 "$(DESTDIR)$$HOME"/.config
	install -d -m755 "$(DESTDIR)$$HOME"/.cache
	install -d -m755 "$(DESTDIR)$$HOME"/.spool
	install -d -m755 "$(DESTDIR)$$HOME"/.local/opt
	ln -s ../.config "$(DESTDIR)$$HOME"/.local/etc
	ln -s ../.config "$(DESTDIR)$$HOME"/.local/dict
	install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/bin
	install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/sbin
	install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/lib
	install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/libexec
	[ ! "$$ARCH" = "x86_64" ] || install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/libmulti
	[ ! "$$ARCH" = "x86_64" ] || ln -s lib "$(DESTDIR)$$HOME"/.local/lib64
	[ ! "$$ARCH" = "x86_64" ] || ln -s lib "$(DESTDIR)$$HOME"/.local/local/lib64
	install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/include
	install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/share
	install -d -m755 "$(DESTDIR)$$HOME"/.local/.local{,/local}/share/changelog
	install -d -m755 "$(DESTDIR)$$HOME"/.local/.local{,/local}/share/info
	install -d -m755 "$(DESTDIR)$$HOME"/.local/.local{,/local}/share/licenses
	install -d -m755 "$(DESTDIR)$$HOME"/.local/.local{,/local}/share/man
	install -d -m755 "$(DESTDIR)$$HOME"/.local/.local{,/local}/share/man/man{1..8}
	ln -s ../doc "$(DESTDIR)$$HOME"/etc/skel/.local/share/doc
	ln -s ../doc "$(DESTDIR)$$HOME"/etc/skel/.local/local/share/doc
	install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/src
	install -d -m755 "$(DESTDIR)$$HOME"/.local{,/local}/doc


install-skel:
	install -d -m755 "$(DESTDIR)"/etc/skel/.local
	install -d -m755 "$(DESTDIR)"/etc/skel/.config
	install -d -m755 "$(DESTDIR)"/etc/skel/.cache
	install -d -m755 "$(DESTDIR)"/etc/skel/.spool
	install -d -m755 "$(DESTDIR)"/etc/skel/.local/opt
	ln -s ../.config "$(DESTDIR)"/etc/skel/.local/etc
	ln -s ../.config "$(DESTDIR)"/.local/dict
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/bin
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/sbin
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/lib
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/libexec
	[ ! "$$ARCH" = "x86_64" ] || install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/libmulti
	[ ! "$$ARCH" = "x86_64" ] || ln -s lib "$(DESTDIR)"/etc/skel/.local/lib64
	[ ! "$$ARCH" = "x86_64" ] || ln -s lib "$(DESTDIR)"/etc/skel/.local/local/lib64
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/include
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/share
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/share/changelog
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/share/info
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/share/licenses
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/share/man
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/share/man/man{1..8}
	ln -s ../doc "$(DESTDIR)"/etc/skel/.local/share/doc
	ln -s ../doc "$(DESTDIR)"/etc/skel/.local/local/share/doc
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/src
	install -d -m755 "$(DESTDIR)"/etc/skel/.local{,/local}/doc
