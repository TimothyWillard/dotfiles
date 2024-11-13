function syncfromdotfiles --description "Sync files from GitHub dotfiles"
	rsyncsansgit --exclude=vscode_settings.json --exclude=".gitconfig-*" ~/Desktop/GitHub/TimothyWillard/dotfiles/ ~/
	if string match --quiet -- 'epid-iss-*' (hostname)
		set gitconfiglocal '.gitconfig-work'
	else if string match --quiet -- 'Timothys-*' (hostname)
		set gitconfiglocal '.gitconfig-home'
	end
	rsyncsansgit ~/Desktop/GitHub/TimothyWillard/dotfiles/$gitconfiglocal ~/.gitconfig-local
	rsyncsansgit ~/Desktop/GitHub/TimothyWillard/dotfiles/vscode_settings.json ~/Library/Application\ Support/Code/User/settings.json
	source ~/.config/fish/**/*.fish
end
