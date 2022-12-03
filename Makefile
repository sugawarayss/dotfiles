.PHONY: zsh vim homebrew git warp all
# GLOBALS
PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL=/bin/zsh
ZSHRC=.zshrco
ZPROFILE=.zprofile
COMMIT_TEMPLATE=.commit_template
NVIM_DIR=.config/nvim
WARP_DIR=.warp
WARP_KEYBIND=keybindings.yaml


define file-exist
	@test -f $1 || echo $1 does not exist
endef

define dir-exist
	@test $1 || echo $1 does not exist
endef

zsh:
	$(call file-exist, $(HOME)/${ZSHRC})
	@cp -i ${PROJECT_DIR}/zsh/${ZSHRC} $(HOME)/${ZSHRC}

	$(call file-exist, $(HOME)/${ZPROFILE})
	@cp -i ${PROJECT_DIR}/zsh/${ZPROFILE} $(HOME)/${ZPROFILE}

	@echo "you should run \`source $(HOME)/${ZSHRC} && source $(HOME)/${ZPROFILE}\`"

git:
	$(call file-exist, $(HOME)/${COMMIT_TEMPLATE})
	@cp -i ${PROJECT_DIR}/git/${COMMIT_TEMPLATE} $(HOME)/${COMMIT_TEMPLATE}
	git config --global commit.template $(HOME)/${COMMIT_TEMPLATE}


vim:
	$(call dir-exist $(HOME)/${NVIM_DIR})
	cp -r ${PROJECT_DIR}/nvim $(HOME)/.config/

# TODO: if使わない
homebrew:
	if type "brew" > /dev/null 2>&1; then\
		echo "brew already exists"\
		brew bundle --file ./homebrew/Brewfile\
	else\
		echo "brew does not exist"\
		echo "Installing brew"\
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"\
		source "$HOME/.zprofile"\
		brew bundle --file ./homebrew/Brewfile\
	fi

warp:
	$(call file-exist $(HOME)/${WARP_DIR}/${WARP_KEYBIND})
	cp -i ${PROJECT_DIR}/warp/${WARP_KEYBIND} $(HOME)/.warp/
	$(call dir-exist $(HOME)/${WARP_DIR})
	cp -r ${PROJECT_DIR}/warp/workflows $(HOME)/.warp/

all: homebrew zsh git vim
	echo finished
