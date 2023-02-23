# Copyright 2016-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Quote arguments or standard input for usage in POSIX shell by eval"
HOMEPAGE="https://github.com/vaeth/quoter/"
SRC_URI="https://github.com/vaeth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" install

	rm -f "${ED}"/usr/bin/quoter_pipe.sh || die
	insinto /usr/share/${PN}
	doins bin/quoter_pipe.sh
}
