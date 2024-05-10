function syncfromdotfiles --description "Sync files from GitHub dotfiles"
	rsync --recursive --checksum --verbose --times --exclude=.git ~/Desktop/GitHub/TimothyWillard/dotfiles/ ~/
	source ~/.config/fish/**/*.fish
end
