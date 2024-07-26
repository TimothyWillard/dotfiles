function ghpullall --description "Pull the latest from the main branch for all git repos cloned from GitHub"
	set returnto (pwd)
	for repo in (find -P ~/Desktop/GitHub -type d -maxdepth 2)
		cd $repo
		if test -d "$repo/.git"
			set reponame (basename $repo)
			set orgname (basename (dirname $repo))
			echo "> Updating $orgname/$reponame"
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
		end
	end
	cd $returnto
end
