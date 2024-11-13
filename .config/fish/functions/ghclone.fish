function ghclone --description "Shorthand for cloning a repo from GitHub to the standardized place" --argument repo
	if not test -d "$HOME/Desktop/GitHub"
		echo "The '$HOME/Desktop/GitHub' directory does not exist."
		return 1
	end
	mkdir -vp $HOME/Desktop/GitHub/$repo
	git clone git@github.com:$repo.git ~/Desktop/GitHub/$repo
end
