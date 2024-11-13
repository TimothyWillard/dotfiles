function syncfromdotfiles --description "Sync files from GitHub dotfiles"
	# Determine where to source dotfiles from
	if test -d "$HOME/Desktop/GitHub/TimothyWillard/dotfiles"
		set DOTFILES $HOME/Desktop/GitHub/TimothyWillard/dotfiles
	else if test -d "$HOME/dotfiles"
		set DOTFILES $HOME/dotfiles
	else
		echo "Unable to determine where to source dotfiles from."
		return 1
	end
	# Place
	rsyncsansgit --exclude=vscode_settings.json --exclude=".gitconfig-*" $DOTFILES/ $HOME/
	if string match --quiet -- 'epid-iss-*' (hostname)
		set gitconfiglocal '.gitconfig-work'
	else if string match --quiet -- 'Timothys-*' (hostname)
		set gitconfiglocal '.gitconfig-home'
	else if string match --quiet -- 'longleaf-*.unc.edu' (hostnamectl --static)
		set gitconfiglocal '.gitconfig-longleaf'
	end
	rsyncsansgit $DOTFILES/$gitconfiglocal $HOME/.gitconfig-local
	if test -d "$HOME/Library/Application Support/Code/User"
		rsyncsansgit $DOTFILES/vscode_settings.json $HOME/Library/Application\ Support/Code/User/settings.json
	end
	source ~/.config/fish/**/*.fish
end
