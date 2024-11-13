function computername --description "Get the name of a computer"
    set osname (uname)
    if [ "$osname" = "Darwin" ]
        set cptrname (scutil --get ComputerName)
    else if [ "$osname" = "Linux" ]
        set cptrname (hostnamectl --static)
    else
        echo "Unknown and unspported OS."
        return 1
    end
    echo "$cptrname"
end
