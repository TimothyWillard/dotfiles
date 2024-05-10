function ghpullall --description "Pull the latest from the main branch for all git repos cloned from GitHub"
	set returnto (pwd)
	for repo in (find ~/Desktop/GitHub -type d -maxdepth 2)
		cd $repo
		if test -d "$repo/.git"
			set branchname (git rev-parse --abbrev-ref HEAD)
			if test $branchname = "master"; or test $branchname = "main"; or test $branchname = "trunk"
				set reponame (basename $repo)
				set orgname (basename (dirname $repo))
				echo "> Updating $orgname/$reponame"
				git fetch
				git pull
			end
		end
	end
	cd $returnto
end
