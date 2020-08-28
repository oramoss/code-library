# Documentation
https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10

# azcopy commands

# Login
azcopy login

# Copy file with recursion and don't overwrite existing files
azcopy copy "<storage account end point>" "<storage account end point>" --recursive=false --overwrite=false