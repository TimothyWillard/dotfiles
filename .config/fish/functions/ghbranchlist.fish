function ghbranchlist --description "List the current branch for all git repos cloned from GitHub"
	set returnto (pwd)
	for repo in (find -P ~/Desktop/GitHub -type d -maxdepth 2 -mindepth 2)
		cd $repo
		if test -d "$repo/.git"
			set branchname (git rev-parse --abbrev-ref HEAD)
			set reponame (basename $repo)
			set orgname (basename (dirname $repo))
			set orgreponame (string pad --right --width 60 "$orgname/$reponame") 
			echo "> $orgreponame> $branchname"
		end
	end
	cd $returnto
end
