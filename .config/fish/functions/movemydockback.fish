function movemydockback --description "Move my dock back from the external display to my laptop."
	defaults write com.apple.dock appswitcher-all-displays -bool true
	killall Dock
end
