function ghclone --description "Shorthand for cloning a repo from GitHub to the standardized place" --argument repo
	mkdir -vp ~/Desktop/GitHub/$repo
	git clone git@github.com:$repo.git ~/Desktop/GitHub/$repo
end
