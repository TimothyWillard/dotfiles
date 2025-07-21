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
	end
	echo "> Syncing git config"
	if test -f "$HOME/.gitconfig-local"
		rm $HOME/.gitconfig-local
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
