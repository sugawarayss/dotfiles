###############
# AWS CLI関連 #
###############
# 指定バケットをls -lRするやつ
function file-list-s3(){
  # aws s3 ls s3://\${bucket}[/prefix/] --profile \${profile} --recursive
  local profile="$(aws configure list-profiles | gum filter)"
  local bucket="$(aws s3 ls --profile ${profile} | cut -d " " -f 3 | gum filter)"
  if [ $# = 0 ]; then
    print -z "aws s3 ls s3://$bucket --profile $profile --recursive"
  else
    print -z "aws s3 ls s3://$bucket/$@ --profile $profile --recursive"
  fi
}

# 指定のファイルをローカルにDLするやつ
function download-s3(){
  local profile="$(aws configure list-profiles | gum filter)"
  local bucket="$(aws s3 ls --profile ${profile} | cut -d " " -f 3 | gum filter)"
  local file="$(aws s3 ls s3://$bucket --profile $profile --recursive | sd " +" " " | cut -d " " -f 4 | gum filter)"
  if [ $# = 0 ]; then
    print -z "aws s3 cp s3://$bucket/$file ./"
  else
    print -z "aws s3 cp s3://$bucket/$file $@"
  fi
}

# asdf用にパスを通す
. /opt/homebrew/opt/asdf/libexec/asdf.sh
# pipenv補完設定
if type pipenv > /dev/null 2>&1; then
  eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"
fi