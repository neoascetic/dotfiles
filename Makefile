all:
	sudo apt-get -y install python-setuptools git vim-nox zsh ack-grep exuberant-ctags grc
	# use 'ack' as command instead of 'ack-grep'
	sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
	# git
	make _link f=.gitconfig
	make _link f=.gitexclude
	# submodules
	git submodule init
	git submodule update
	# python stuff
	sudo easy_install pip
	sudo pip install virtualenvwrapper virtualenvwrapper.tmpenv bpython vim-bridge
	mkdir -p $(HOME)/.virtualenvs
	make _link f=.virtualenvs/* t=.virtualenvs
	# zsh
	# in most cases I run this script under user that do not have password
	# chsh -s /bin/zsh
	make _link f=.zsh
	make _link f=.zsh/rc.zsh t=.zshrc
	# ssh
	mkdir -p $(HOME)/.ssh
	make _link f=.ssh/* t=.ssh
	# vim
	make _link f=.vim
	make _link f=.vim/rc.vim t=.vimrc
	# vundle-update call (antigen will be updated too since session is interactive)
	zsh -ic "vundle-update"
	# colorful mysql output
	make _link f=.my.cnf
	make _link f=.grcat

x11:
	sudo apt-get -y install i3 dmenu
	# bin
	make _link f=bin
	# i3
	make _link f=.i3
	# patched fonts for vim's powerline
	mkdir -p $(HOME)/.fonts/
	make _link f=.fonts/* t=.fonts

_link:
	ln -si $(CURDIR)/$(f) $(HOME)/$(t)
