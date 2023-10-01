.PHONY: zsh vim brew_restore brew_dump git warp tig tmux ideavim helix all
# GLOBALS
PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL=/bin/zsh
ZSHRC=.zshrc
ZSHD=.zsh.d
ZPROFILE=.zprofile
CONFIG_DIR=.config
COMMIT_TEMPLATE=.commit_template
IGNORE_FILE=ignore
NVIM_DIR=${CONFIG_DIR}/nvim
WARP_DIR=.warp
WARP_KEYBIND=keybindings.yaml


define file-exist
	@test -f $1 || echo $1 does not exist
endef

define dir-exist
	@test $1 || echo $1 does not exist
endef

tig:
	@echo "tigrc --- start"
	ln -s ${PROJECT_DIR}/HOME/.tigrc ~/.tigrc
	@echo "tigrc --- finished"
	ls -l $(HOME)/.tigrc

tmux:
	@echo "tmux deploy --- start"
	ln -s ${PROJECT_DIR}/HOME/.tmux.conf $(HOME)/.tmux.conf
	@echo "tmux deploy --- finished"
	ls -l $(HOME)/.tmux.conf

ideavim:
	@echo "ideavim deplot --- start"
	ln -s ${PROJECT_DIR}/HOME/.ideavimrc $(HOME)/.ideavimrc
	@echo "ideavim deplot --- finished"
	ls -l $(HOME)/.ideavimrc

zsh:
	@echo "zshrc deploy --- start"
	ln -s ${PROJECT_DIR}/HOME/${ZSHD} ${HOME}/${ZSHD}
	ln -s ${PROJECT_DIR}/HOME/${ZSHRC} $(HOME)/${ZSHRC}
	ls -l $(HOME)/${ZSHRC} && ls -lR ${HOME}/${ZSHD}
	@echo "zshrc deploy --- finished"

	@echo "zprofile deploy --- start"
	ln -s ${PROJECT_DIR}/HOME/${ZPROFILE} $(HOME)/${ZPROFILE}
	@echo "zprofile deploy --- finished"
	ls -l $(HOME)/${ZPROFILE}
	@echo "you should run \`source $(HOME)/${ZSHRC} && source $(HOME)/${ZPROFILE}\`"

git:
	@echo "git global ignore deploy --- start"
	ln -s ${PROJECT_DIR}/HOME/${CONFIG_DIR}/git/${IGNORE_FILE} $(HOME)/${CONFIG_DIR}/git/${IGNORE_FILE}
	ls -l ~/${CONFIG_DIR}/git/${IGNORE_FILE}
	@echo "git global ignore deploy --- finished"

	@echo "git commit_template deploy --- start"
	$(call file-exist, $(HOME)/${COMMIT_TEMPLATE})
	ln -s ${PROJECT_DIR}/HOME/${CONFIG_DIR}/git/${COMMIT_TEMPLATE} $(HOME)/${CONFIG_DIR}/git/${COMMIT_TEMPLATE}
	ls -l ~/${CONFIG_DIR}/git/${COMMIT_TEMPLATE}
	@echo "git commit_template deploy --- finished"

	@echo "git global config deploy --- start"
	ln -s ${PROJECT_DIR}/HOME/.gitconfig ${HOME}/.gitconfig
	@echo "git global config deploy --- finished"

vim:
	@echo "nvim settings deploy --- start"
	$(call dir-exist $(HOME)/${NVIM_DIR})
	ln -s ${PROJECT_DIR}/HOME/${CONFIG_DIR}/nvim $(HOME)/${CONFIG_DIR}/nvim
	ln -s ${PROJECT_DIR}/HOME/skkeleton/dictionary $(HOME)/.skk
	ln -s ${PROJECT_DIR}/HOME/skkeleton/my_dictionay $(HOME)/.skkeleton
	@echo "nvim settings deploy --- finished"

brew_restore:
	@echo "brew bundle --- start"
	brew bundle --file ${PROJECT_DIR}/homebrew/Brewfile
	@echo "brew bundle --- finished"

brew_dump:
	@echo "brew bundle dump --- start"
	brew bundle dump --force --file ${PROJECT_DIR}/homebrew/Brewfile
	@echo "brew bundle dump --- end"

starship:
	@echo "starship --- start"
	ln -s ${PROJECT_DIR}/HOME/${CONFIG_DIR}/starship.toml $(HOME)/${CONFIG_DIR}/starship.toml
	ls -l ~/${CONFIG_DIR}/starship.toml
	@echo "starship --- finished"

warp:
	@echo "warp keybind deploy --- start"
	ln -s ${PROJECT_DIR}/HOME/.warp $(HOME)/.warp
	@echo "warp keybind deploy --- finished"

helix:
	@echo "helix configurations deploy --- start"
	ln -s ${PROJECT_DIR}/HOME/${CONFIG_DIR}/helix $(HOME)/${CONFIG_DIR}/helix
	@echo "helix configurations deploy --- finished"

all: brew_restore zsh git vim starship tig tmux ideavim warp
	echo finished
