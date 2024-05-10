function ghcd --description "Shorthand for cd-ing to a repo from GitHub to the standardized place" --argument repo
	# TODO: This should do the things like it used to, check if it's a full org/repo or just repo and try to search for just repo
	cd ~/Desktop/GitHub/$repo
end
