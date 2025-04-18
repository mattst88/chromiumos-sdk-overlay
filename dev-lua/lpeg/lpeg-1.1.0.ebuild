# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua flag-o-matic toolchain-funcs

DESCRIPTION="Parsing Expression Grammars for Lua"
HOMEPAGE="https://www.inf.puc-rio.br/~roberto/lpeg/"
SRC_URI="https://luarocks.org/manifests/gvvaughan/${P}-1.src.rock -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="test debug doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	app-arch/unzip
	test? ( ${RDEPEND} )
"

DOCS=( HISTORY )
HTML_DOCS=( lpeg.html re.html )
PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-makefile.patch
)

src_unpack() {
	unpack "${P}.zip" || die
	unpack "${WORKDIR}/${P}.tar.gz" || die
}

lua_src_prepare() {
	if ! test -d "${S}.${ELUA}/" ; then
		cp -ral "${S}/" "${S}.${ELUA}/" || die
	fi
}

src_prepare() {
	default
	use debug && append-cflags -DLPEG_DEBUG

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-ldflags "-undefined dynamic_lookup"
	fi

	lua_foreach_impl lua_src_prepare
}

lua_src_compile() {
	cd "${S}.${ELUA}/" || die
	emake CC="$(tc-getCC)" \
		LUADIR="${EPREFIX}/$(lua_get_include_dir)"
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	cd "${S}.${ELUA}/" || die
	${ELUA} test.lua || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	cd "${S}.${ELUA}/" || die
	local instdir
	instdir="$(lua_get_cmod_dir)"
	exeinto "${instdir#${EPREFIX}}"
	doexe lpeg.so
	instdir="$(lua_get_lmod_dir)"
	insinto "${instdir#${EPREFIX}}"
	doins re.lua

	if [[ ${CHOST} == *-darwin* ]] ; then
		local luav=$(lua_get_version)
		# we only want the major version (e.g. 5.1)
		local luamv=${luav:0:3}
		local file="lua/${luamv}/lpeg.so"
		install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/${file}" \
			"${ED}/usr/$(get_libdir)/${file}" || die "Failed to adjust install_name"
	fi
}

src_install() {
	lua_foreach_impl lua_src_install
	cd "${S}" || die
	use doc && einstalldocs
}
