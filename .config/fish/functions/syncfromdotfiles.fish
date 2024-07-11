function syncfromdotfiles --description "Sync files from GitHub dotfiles"
	rsync --recursive --checksum --verbose --times --exclude=.git --exclude=vscode_settings.json --exclude=".gitconfig-*" ~/Desktop/GitHub/TimothyWillard/dotfiles/ ~/
	if string match --quiet -- 'epid-iss-mbp*' (hostname)
		set gitconfiglocal '.gitconfig-work'
	end
	rsync --recursive --checksum --verbose --times --exclude=.git ~/Desktop/GitHub/TimothyWillard/dotfiles/$gitconfiglocal ~/.gitconfig-local
	rsync --recursive --checksum --verbose --times --exclude=.git ~/Desktop/GitHub/TimothyWillard/dotfiles/vscode_settings.json ~/Library/Application\ Support/Code/User/settings.json
	source ~/.config/fish/**/*.fish
end
