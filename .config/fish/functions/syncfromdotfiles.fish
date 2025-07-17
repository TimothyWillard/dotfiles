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
	set osname (uname)
	# Place config files in the right place
	echo "> Syncing fish config"
	rsyncsansgit $DOTFILES/.config/fish/ $HOME/.config/fish/
	if which jj > /dev/null 2>&1
		echo "> Syncing jj config"
		set jjconfigpath (jj config path --user)
		rsyncsansgit $DOTFILES/jj_config.toml $jjconfigpath
		if [ "$osname" = "Darwin" ]
			set cptrname (scutil --get ComputerName)
			if string match --quiet -- 'epid*' $cptrname
				gsed -i 's/key = ""/key = "871B573E01D0FB85"/' $jjconfigpath
			else if string match --quiet -- 'Timothy*' $cptrname
				gsed -i 's/key = ""/key = "D9EEB52CF5D0CC09"/' $jjconfigpath
			end
		else if [ "$osname" = "Linux" ]
			set cptrname (hostnamectl --static)
			if string match --quiet -- 'longleaf-*.unc.edu' $cptrname
				sed -i 's/key = ""/key = "EB5E2D91340E42B5"/' $jjconfigpath
			end
		end
	end
	echo "> Syncing git config"
	if [ "$osname" = "Darwin" ]
        set cptrname (scutil --get ComputerName)
		if string match --quiet -- 'epid*' $cptrname
			set gitconfiglocal '.gitconfig-work'
		else if string match --quiet -- 'Timothy*' $cptrname
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
	rsyncsansgit $DOTFILES/.gitconfig $HOME/.gitconfig
	if test -d "$HOME/Library/Application Support/Code/User"
		echo "> Syncing VSCode settings"
		rsyncsansgit $DOTFILES/vscode_settings.json $HOME/Library/Application\ Support/Code/User/settings.json
	end
	echo "> Syncing other dotfiles"
	rsyncsansgit $DOTFILES/.bashrc $HOME/.bashrc
	rsyncsansgit $DOTFILES/.vimrc $HOME/.vimrc
	rsyncsansgit $DOTFILES/.zprofile $HOME/.zprofile
	source ~/.config/fish/**/*.fish
end
