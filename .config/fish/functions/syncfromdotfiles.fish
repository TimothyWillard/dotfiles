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
	if [ "$osname" = "Darwin" ]
        set cptrname (scutil --get ComputerName)
		if string match --quiet -- 'epid_id*MacBook Pro' $cptrname
			set gitconfiglocal '.gitconfig-work'
		else if string match --quiet -- 'Timothys-*' $cptrname
			set gitconfiglocal '.gitconfig-home'
		end
    else if [ "$osname" = "Linux" ]
        set cptrname (hostnamectl --static)
		if string match --quiet -- 'longleaf-*.unc.edu' $cptrname
			set gitconfiglocal '.gitconfig-longleaf'
		end
    end
	if set -q $gitconfiglocal
		rsyncsansgit $DOTFILES/$gitconfiglocal $HOME/.gitconfig-local
	else
		echo "Unable to find a local gitconfig to sync"
	end
	if test -d "$HOME/Library/Application Support/Code/User"
		rsyncsansgit $DOTFILES/vscode_settings.json $HOME/Library/Application\ Support/Code/User/settings.json
	end
	source ~/.config/fish/**/*.fish
end
