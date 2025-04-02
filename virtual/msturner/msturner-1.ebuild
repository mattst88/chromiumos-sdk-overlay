# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package containing packages msturner@ wants"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="*"

PDEPEND="
	app-admin/stow
	app-editors/neovim
	app-misc/tmux
	app-portage/eix
	app-shells/autojump
	app-shells/fzf
	app-text/dos2unix
	app-text/wgetpaste
	dev-vcs/tig
	sys-apps/ripgrep
	x11-terms/kitty-shell-integration
	x11-terms/kitty-terminfo
"
