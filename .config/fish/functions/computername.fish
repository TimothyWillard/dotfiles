function computername --description "Get the name of a computer"
    set osname (uname)
    if [ "$osname" = "Darwin" ]
        # scutil --get LocalHostName
        set cptrname (scutil --get ComputerName)
    else
        echo "Unknown and unspported OS."
        return 1
    end
    echo "$cptrname"
end
