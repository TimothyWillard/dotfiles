
eval "$(/usr/local/bin/brew shellenv)"

# Setting PATH for Python 3.12
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
export PATH

# Need to manually set SDK root for R CMD Check
if [[ `hostname` = "epid-iss-MBP.lan" ]]; then
    export SDKROOT=$(xcrun --show-sdk-path)
fi
