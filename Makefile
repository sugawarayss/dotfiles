.PHONY: zsh vim brew_restore brew_dump git warp all
# GLOBALS
PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL=/bin/zsh
ZSHRC=.zshrc
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
	@echo "tigrc --- end"
	ls -l ~/.tigrc

zsh:
	@echo "zshrc deploy --- start"
	$(call file-exist, $(HOME)/${ZSHRC})
	ln -s ${PROJECT_DIR}/HOME/${ZSHRC} $(HOME)/${ZSHRC}
	ls -l $(HOME)/${ZSHRC}
	@echo "zshrc deploy --- finished"

	@echo "zprofile deploy --- start"
	$(call file-exist, $(HOME)/${ZPROFILE})
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
	git config --global commit.template $(HOME)/${CONFIG_DIR}/git/${COMMIT_TEMPLATE}
	ls -l ~/${CONFIG_DIR}/git/${COMMIT_TEMPLATE}
	@echo "git commit_template deploy --- finished"


vim:
	@echo "nvim settings deploy --- start"
	$(call dir-exist $(HOME)/${NVIM_DIR})
	ln -s ${PROJECT_DIR}/nvim $(HOME)/${CONFIG_DIR}/nvim
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
	$(call file-exist $(HOME)/${WARP_DIR}/${WARP_KEYBIND})
	ln -s ${PROJECT_DIR}/warp/${WARP_KEYBIND} $(HOME)/.warp/${WARP_KEYBIND}
	@echo "warp keybind deploy --- finished"

	@echo "warp workflows deploy --- start"
	$(call dir-exist $(HOME)/${WARP_DIR})
	ln -s ${PROJECT_DIR}/warp/workflows $(HOME)/.warp/workflows
	@echo "warp workflows deploy --- finished"

all: brew_restore zsh git vim
	echo finished
