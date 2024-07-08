# Need to manually set SDK root for R CMD Check
if [[ `hostname` == "epid-iss-MBP.lan" ]]
then
    export SDKROOT=$(xcrun --show-sdk-path)
fi
