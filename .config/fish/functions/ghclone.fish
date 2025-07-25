function ghclone --description "Shorthand for cloning a repo from GitHub to the standardized place" --argument repo
	if not test -d "$HOME/Desktop/GitHub"
		echo "The '$HOME/Desktop/GitHub' directory does not exist."
		return 1
	end
	if not string match -q -- "*/*" $repo
		set repo "TimothyWillard/$repo"
	end
	mkdir -vp $HOME/Desktop/GitHub/$repo
	if contains -- --git $argv; or contains -- -g $argv
		git clone --verbose git@github.com:$repo.git ~/Desktop/GitHub/$repo
	else if contains -- --worktree $argv; or contains -- -w $argv
		# https://infrequently.org/2021/07/worktrees-step-by-step/
		git clone --verbose --bare git@github.com:$repo.git ~/Desktop/GitHub/$repo/.bare
		echo "gitdir: ./.bare" > ~/Desktop/GitHub/$repo/.git
		git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
	else
		jj git clone --colocate git@github.com:$repo.git ~/Desktop/GitHub/$repo
	end
end
