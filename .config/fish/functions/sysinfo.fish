function sysinfo --description "Get system info for bug reporting. Use -1 to get the info in one line."
    # Init
    set OUTPUT_STRING ""

    # Get OS info
    if which sw_vers > /dev/null
        set OS_VERSION ( sw_vers | awk 'NR==2 {print $2}' )
        set OUTPUT_STRING "$OUTPUT_STRING\nMacOS $OS_VERSION"
    else if which lsb_release > /dev/null
        set OS_VERSION ( lsb_release -d | string sub --start 13 | xargs )
        set OUTPUT_STRING "$OUTPUT\n$OS_VERSION"
    else
        echo "Unknown and unspported OS."
        return 1
    end

    # Get python info
    if which python > /dev/null
        set PYTHON_VERSION ( python --version | awk '{print $2}' )
        set OUTPUT_STRING "$OUTPUT_STRING\nPython $PYTHON_VERSION"
    end

    # Get R info
    if which R > /dev/null
        set R_VERSION ( R --version | awk 'NR==1 {print $3}' )
        set OUTPUT_STRING "$OUTPUT_STRING\nR $R_VERSION"
    end

    # Get conda info
    if which conda > /dev/null
        set CONDA_VERSION ( conda --version | awk '{print $2}' )
        set OUTPUT_STRING "$OUTPUT_STRING\nConda $CONDA_VERSION"
    end

    # Get git info
    if contains -- --git $argv; and which git > /dev/null; and git rev-parse --is-inside-work-tree > /dev/null 2>&1
        set GIT_VERSION ( git --version | awk '{print $3}' )
        set OUTPUT_STRING "$OUTPUT_STRING\nGit $GIT_VERSION"
        set GIT_BRANCH ( git rev-parse --abbrev-ref HEAD )
        set OUTPUT_STRING "$OUTPUT_STRING\nBranch $GIT_BRANCH"
        set GIT_COMMIT ( git rev-parse HEAD )
        set OUTPUT_STRING "$OUTPUT_STRING\nCommit $GIT_COMMIT"
    end

    # Output
    set OUTPUT_STRING ( string trim --chars="\n" "$OUTPUT_STRING" )
    if contains -- -1 $argv
        set OUTPUT_STRING ( echo "$OUTPUT_STRING" | string replace -a "\n" ", " )
    end
    echo -e "$OUTPUT_STRING"
end
