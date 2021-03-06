SHELL = /bin/bash
DOTFILES_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
export STOW_DIR := $(DOTFILES_DIR)

all: $(OS)

macos: sudo core-macos packages link

linux: link

core-macos: brew bash

stow-macos: brew
	is-executable stow || brew install stow

stow-linux:
	is-executable stow || apt-get -y install stow 

sudo:
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

packages: brew-packages cask-apps python-packages

link: stow-$(OS)
	for FILE in $$(\ls -A runcom && ls -A etc); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then mv -v $(HOME)/$$FILE{,.bak}; fi; done
	stow -t $(HOME) runcom
	stow -t $(HOME) etc

unlink: stow-$(OS)
	stow --delete -t $(HOME) runcom
	stow --delete -t $(HOME) etc
	for FILE in $$(\ls -A runcom && ls -A etc); do if [ -f $(HOME)/$$FILE.bak ]; then mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | ruby

bash: BASH=/usr/local/bin/bash
bash: SHELLS=/private/etc/shells
bash: brew
	if ! grep -q $(BASH) $(SHELLS); then brew install bash bash-completion@2 pcre && sudo append $(BASH) $(SHELLS) && chsh -s $(BASH); fi

brew-packages: brew
	brew bundle --no-lock --file=$(DOTFILES_DIR)/install/Brewfile

cask-apps: brew
	brew bundle --no-lock --file=$(DOTFILES_DIR)/install/Caskfile

python-packages: brew-packages
	pip3 install -r $(DOTFILES_DIR)/install/pipfile

