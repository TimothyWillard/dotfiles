function ghpullall --description "Pull the latest from the main branch for all git repos cloned from GitHub"
	if not test -d "$HOME/Desktop/GitHub"
		echo "The '$HOME/Desktop/GitHub' directory does not exist."
		return 1
	end
	set returnto (pwd)
	for repo in (find -P $HOME/Desktop/GitHub -type d -mindepth 2 -maxdepth 2 ! -path '*/.*')
		cd $repo
		set reponame (basename $repo)
		set orgname (basename (dirname $repo))
		if test -d "$repo/.jj"
			echo "> Updating Jujutsu Repo $orgname/$reponame"
			jj git fetch
		else if test -d "$repo/.git"
			echo "> Updating Git Repo $orgname/$reponame"
			set branchname (git rev-parse --abbrev-ref HEAD)
			set mainbranchname (git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
			set workingchanges (git status -s | wc -l | string trim)
			if [ "$workingchanges" != "0" ]
				git stash
			end
			if [ "$branchname" != "$mainbranchname" ]
				git switch $mainbranchname
			end
			git fetch
			git pull
			if [ "$branchname" != "$mainbranchname" ]
				git switch $branchname
			end
			if [ "$workingchanges" != "0" ]
				git stash apply --quiet
			end
		else if test -d "$repo/.bare"
			echo "> Fetching Git Worktree $reponame"
			git fetch --all
		else
			echo "Skipping $repo"
		end
	end
	cd $returnto
end
