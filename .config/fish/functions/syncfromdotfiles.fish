function syncfromdotfiles --description "Sync files from GitHub dotfiles"
	rsync --recursive --checksum --verbose --times --exclude=.git --exclude=vscode_settings.json ~/Desktop/GitHub/TimothyWillard/dotfiles/ ~/
	rsync --recursive --checksum --verbose --times --exclude=.git ~/Desktop/GitHub/TimothyWillard/dotfiles/vscode_settings.json ~/Library/Application\ Support/Code/User/settings.json
	source ~/.config/fish/**/*.fish
end
