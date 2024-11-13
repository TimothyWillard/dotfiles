if `uname` = "Darwin"; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Need to manually set SDK root for R CMD Check
if echo "$( hostname )" | grep -q "epid-iss"; then
    export SDKROOT=$(xcrun --show-sdk-path)
fi
