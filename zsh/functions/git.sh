#!/usr/bin/env bash

# delete branch
gbd() {
	local branch_to_delete
	branch_to_delete=$(git branch | fzf | xargs)

	if [ -n "$branch_to_delete" ]; then
		 git branch --delete --force "$branch_to_delete"
	fi
}

gcor() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

gcop() {
    git log \
        --color=always \
        --format="%C(cyan)%h %C(blue)%ar%C(auto)%d %C(yellow)%s%+b %C(black)%ae" "$@" |
        fzf -i -e +s \
        --tiebreak=index \
        --no-multi \
        --ansi \
        --preview="echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always % | diff'" \
        --header "enter: view, C-c: hopy hash" \
        --bind "enter:execute:$_viewGitLogLine | less -R" \
        --bind "ctrl-c:execute:$_gitLogLineToHash | xclip -r -selection clipboard"
}

gdif() {
    preview="git diff $@ --color=always -- {-1}"
    git diff $@ --name-only | fzf -m --ansi --preview $preview
}
