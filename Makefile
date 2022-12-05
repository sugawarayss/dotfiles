.PHONY: zsh vim homebrew git warp all
# GLOBALS
PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL=/bin/zsh
ZSHRC=.zshrc
ZPROFILE=.zprofile
CONFIG_DIR=.config/
COMMIT_TEMPLATE=.commit_template
IGNORE_FILE=ignore
NVIM_DIR=${CONFIG_DIR}nvim
WARP_DIR=.warp
WARP_KEYBIND=keybindings.yaml


define file-exist
	@test -f $1 || echo $1 does not exist
endef

define dir-exist
	@test $1 || echo $1 does not exist
endef

zsh:
	@echo "zshrc deploy --- start"
	$(call file-exist, $(HOME)/${ZSHRC})
	cp -f ${PROJECT_DIR}/zsh/${ZSHRC} $(HOME)/${ZSHRC}
	@echo "zshrc deploy --- finished"

	@echo "zprofile deploy --- start"
	$(call file-exist, $(HOME)/${ZPROFILE})
	cp -f ${PROJECT_DIR}/zsh/${ZPROFILE} $(HOME)/${ZPROFILE}
	@echo "zprofile deploy --- finished"

	@echo "you should run \`source $(HOME)/${ZSHRC} && source $(HOME)/${ZPROFILE}\`"

git:
	@echo "git global ignore deploy --- start"
	cp -f ${PROJECT_DIR}/git/${IGNORE_FILE} $(HOME)/${CONFIG_DIR}${IGNORE_FILE}
	@echo "git global ignore deploy --- finished"

	@echo "git commit_template deploy --- start"
	$(call file-exist, $(HOME)/${COMMIT_TEMPLATE})
	cp -f ${PROJECT_DIR}/git/${COMMIT_TEMPLATE} $(HOME)/${CONFIG_DIR}${COMMIT_TEMPLATE}
	git config --global commit.template $(HOME)/${CONFIG_DIR}${COMMIT_TEMPLATE}
	@echo "git commit_template deploy --- finished"


vim:
	@echo "nvim settings deploy --- start"
	$(call dir-exist $(HOME)/${NVIM_DIR})
	cp -r ${PROJECT_DIR}/nvim $(HOME)/.config/
	@echo "nvim settings deploy --- finished"

# TODO: if使わない
homebrew:
	@echo "brew bundle --- start"
	brew bundle --file ${PROJECT_DIR}/homebrew/Brewfile
	@echo "brew bundle --- finished"

warp:
	@echo "warp keybind deploy --- start"
	$(call file-exist $(HOME)/${WARP_DIR}/${WARP_KEYBIND})
	cp -i ${PROJECT_DIR}/warp/${WARP_KEYBIND} $(HOME)/.warp/
	@echo "warp keybind deploy --- finished"

	@echo "warp workflows deploy --- start"
	$(call dir-exist $(HOME)/${WARP_DIR})
	cp -r ${PROJECT_DIR}/warp/workflows $(HOME)/.warp/
	@echo "warp workflows deploy --- finished"

all: homebrew zsh git vim
	echo finished
