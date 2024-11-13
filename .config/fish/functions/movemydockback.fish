function movemydockback --description "Move my dock back from the external display to my laptop."
	# Exit early if not MacOS
    if test (uname) != "Darwin"
        echo "The \`movemydockback\` function is only intended for use on MacOS."
        return 1
    end
	defaults write com.apple.dock appswitcher-all-displays -bool true
	killall Dock
end
