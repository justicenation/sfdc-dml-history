SRC_DIRECTORY=src

# Delete the src directory if it already exists
if [ -d "$SRC_DIRECTORY" ]; then
    rm -R "$SRC_DIRECTORY"
fi

# Prompt for the target org
echo # line break
echo "Deploy to which organization?"
read USERNAME

echo # line break
echo Roger that. Commencing deploymnet to $USERNAME...

# Convert the source code
sfdx force:source:convert -r force-app -d src
sfdx force:mdapi:deploy -d src -u $USERNAME -w 5
