DESTDIR=
PKGNAME=minidlna-autoconfig

default:
	echo "Nothing to compile - nothing to do! :D"

install:
	install -D -m 755 minidlna-makeconfig.sh "${DESTDIR}/usr/share/${PKGNAME}/minidlna-makeconfig.sh"
	install -D -m 644 minidlna-autoconfig@.service "${DESTDIR}/usr/lib/systemd/system/minidlna-autoconfig@.service"
	install -D -m 644 minidlna@.service "${DESTDIR}/usr/lib/systemd/system/minidlna@.service"
	install -D -m 755 minidlna-autoconfig.sh "${DESTDIR}/usr/share/${PKGNAME}/minidlna-autoconfig.sh" 
