function ghcd --description "Shorthand for cd-ing to a repo from GitHub to the standardized place" --argument repo
	if test -z "$repo"
		echo "No repo name argument was provided."
		return 1
	end
	if string match -q -- "*/*" $repo
		if test -d "$HOME/Desktop/GitHub/$repo"
			cd $HOME/Desktop/GitHub/$repo
			return 0
		end
		echo "Was expecting to find '~/Desktop/GitHub/$repo', but does not exist."
	else
		# TODO: The sort order from find is roughly the order that directories
		# were created, which isn't great. Probably should be in modtime order
		# since the name matching is on a first come first serve basis.
		for r in (find -P ~/Desktop/GitHub -type d -maxdepth 2 -mindepth 2)
			set bn (basename $r)
			set dn (basename (dirname $r))
			if [ $bn = $repo ]
				cd $HOME/Desktop/GitHub/$dn/$repo
				return 0
			end
		end
		echo "Was expecting to find a repo under ~/Desktop/GitHub with a basename of $repo, but does not exist."
	end
	return 1
end
