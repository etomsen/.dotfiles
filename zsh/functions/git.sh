#!/usr/bin/env bash

git_branch_delete() {
	local branch_to_delete
	branch_to_delete=$(git branch | fzf | xargs)

	if [ -n "$branch_to_delete" ]; then
		 git branch --delete --force "$branch_to_delete"
	fi
}

git_checkout() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

git_diff() {
    preview="git diff $@ --color=always -- {-1}"
    git diff $@ --name-only | fzf -m --ansi --preview $preview
}

_fzf_git_fzf() {
  fzf-tmux -p80%,60% -- \
    --layout=reverse --multi --height=50% --min-height=20 --border \
    --border-label-pos=2 \
    --color='header:italic:underline,label:blue' \
    --preview-window='right,50%,border-left' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

_fzf_git_check() {
  git rev-parse HEAD > /dev/null 2>&1 && return

  [[ -n $TMUX ]] && tmux display-message "Not in a git repository"
  return 1
}

if [[ -z $_fzf_git_cat ]]; then
  # Sometimes bat is installed as batcat
  export _fzf_git_cat="cat"
  _fzf_git_bat_options="--style='${BAT_STYLE:-full}' --color=always --pager=never"
  if command -v batcat > /dev/null; then
    _fzf_git_cat="batcat $_fzf_git_bat_options"
  elif command -v bat > /dev/null; then
    _fzf_git_cat="bat $_fzf_git_bat_options"
  fi
fi

git_files() {
  _fzf_git_check || return
  local root query
  root=$(git rev-parse --show-toplevel)
  [[ $root != "$PWD" ]] && query='!../ '

  (git -c color.status=always status --short --no-branch
   git ls-files "$root" | grep -vxFf <(git status -s | grep '^[^?]' | cut -c4-; echo :) | sed 's/^/   /') |
  _fzf_git_fzf -m --ansi --nth 2..,.. \
    --border-label '📁 Files' \
    --header $'CTRL-O (open in browser) ╱ ALT-E (open in editor)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git file {-1}" \
    --bind "alt-e:execute:${EDITOR:-vim} {-1} > /dev/tty" \
    --query "$query" \
    --preview "git diff --no-ext-diff --color=always -- {-1} | sed 1,4d; $_fzf_git_cat {-1}" "$@" |
  cut -c4- | sed 's/.* -> //'
}

git_branches() {
  _fzf_git_check || return
  git branch "$@" --sort=-committerdate --sort=-HEAD --format=$'%(HEAD) %(color:yellow)%(refname:short) %(color:green)(%(committerdate:relative))\t%(color:blue)%(subject)%(color:reset)' --color=always | column -ts$'\t' | _fzf_git_fzf --ansi \
    --border-label '🌲 Branches' \
    --header-lines 2 \
    --tiebreak begin \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git branch {}" \
    --bind "alt-a:change-border-label(🌳 All branches)+reload:bash \"$__fzf_git\" all-branches" \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) --' "$@" |
  sed 's/^..//' | cut -d' ' -f1
}

git_tags() {
  _fzf_git_check || return
  git tag --sort -version:refname |
  _fzf_git_fzf --preview-window right,70% \
    --border-label '📛 Tags' \
    --header $'CTRL-O (open in browser)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git tag {}" \
    --preview 'git show --color=always {}' "$@"
}

git_log() {
  _fzf_git_check || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always "$@" | _fzf_git_fzf --ansi --no-sort --bind 'ctrl-s:toggle-sort' \
    --border-label '🍡 Hashes' \
    --header-lines 3 \
    --bind "ctrl-o:execute-silent:bash $__fzf_git commit {}" \
    --bind 'ctrl-d:execute:grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git diff > /dev/tty' \
    --bind "alt-a:change-border-label(🍇 All hashes)+reload:bash \"$__fzf_git\" all-hashes" \
    --color hl:underline,hl+:underline \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git show --color=always' "$@" |
  awk 'match($0, /[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]*/) { print substr($0, RSTART, RLENGTH) }'
}

git_remotes() {
  _fzf_git_check || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  _fzf_git_fzf --tac \
    --border-label '📡 Remotes' \
    --header $'CTRL-O (open in browser)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git remote {1}" \
    --preview-window right,70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {1}/"$(git rev-parse --abbrev-ref HEAD)" --' "$@" |
  cut -d$'\t' -f1
}

git_stashes() {
  _fzf_git_check || return
  git stash list | _fzf_git_fzf \
    --border-label '🥡 Stashes' \
    --header $'CTRL-X (drop stash)\n\n' \
    --bind 'ctrl-x:reload(git stash drop -q {1}; git stash list)' \
    -d: --preview 'git show --color=always {1}' "$@" |
  cut -d: -f1
}

_fzf_git_lreflogs() {
  _fzf_git_check || return
  git reflog --color=always --format="%C(blue)%gD %C(yellow)%h%C(auto)%d %gs" | _fzf_git_fzf --ansi \
    --border-label '📒 Reflogs' \
    --preview 'git show --color=always {1}' "$@" |
  awk '{print $1}'
}

_fzf_git_each_ref() {
  _fzf_git_check || return
  git for-each-ref --sort=-creatordate --sort=-HEAD --color=always --format=$'%(refname) %(color:green)(%(creatordate:relative))\t%(color:blue)%(subject)%(color:reset)' |
        eval "$1" |
        sed 's#^refs/remotes/#\x1b[95mremote-branch\t\x1b[33m#; s#^refs/heads/#\x1b[92mbranch\t\x1b[33m#; s#^refs/tags/#\x1b[96mtag\t\x1b[33m#; s#refs/stash#\x1b[91mstash\t\x1b[33mrefs/stash#' |
        column -ts$'\t' | _fzf_git_fzf --ansi \
    --nth 2,2.. \
    --tiebreak begin \
    --border-label '☘️  Each ref' \
    --header-lines 2 \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git {1} {2}" \
    --bind "alt-e:execute:${EDITOR:-vim} <(git show {2}) > /dev/tty" \
    --bind "alt-a:change-border-label(🍀 Every ref)+reload:bash \"$__fzf_git\" all-refs" \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {2} --' "$@" |
  awk '{print $2}'
}

git_worktree() {
  _fzf_git_check || return
  git worktree list | _fzf_git_fzf \
    --border-label '🌴 Worktrees' \
    --header $'CTRL-X (remove worktree)\n\n' \
    --bind 'ctrl-x:reload(git worktree remove {1} > /dev/null; git worktree list)' \
    --preview '
      git -c color.status=always -C {1} status --short --branch
      echo
      git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {2} --
    ' "$@" |
  awk '{print $1}'
}

