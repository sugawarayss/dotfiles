###############
# gcloud関連  #
###############
# プラグイン
if type gcloud > /dev/null 2>&1; then
  source ${BREWPREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
  source ${BREWPREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

function gcloud-activate() {
  name="$1"
  project="$2"
  echo "gcloud config configurations activate \"${name}\""
  gcloud config configurations activate "${name}"
}
function gx-complete() {
  _values $(gcloud config configurations list | awk '{print $1}')
}

# gcloudでactiveなprojectをgum filterで選択して切り替える関数
function gx() {
  name="$1"
  if [ -z "$name" ]; then
    line=$(gcloud config configurations list | gum filter --prompt="SELECT GCP PROJECT >")
    name=$(echo "${line}" | awk '{print $1}')
  else
    line=$(gcloud config configurations list | grep "$name")
  fi
  project=$(echo "${line}" | awk '{print $4}')
  gcloud-activate "${name}" "${project}"
}
compdef gx-complete gx

# gcloud設定名からプロジェクト名を取得する
function gcloud-alias() {
    gcloud config configurations list | grep "^$1" | head -1 | awk '{print $4}'
}

# 現在の設定を取得する
function gcloud-current() {
    cat $HOME/.config/gcloud/active_config
}
