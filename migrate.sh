# Example of the console command   ./migrate.sh test dev6

# grab first and second variables from the command
OPERATION=$1
ENVIRONMENT=$2

#create a string for file name with credentials
FILENAME=ant/$ENVIRONMENT.properties

#grab the file using the name created earlier
# loop through the file lines and split them by "=" sign
if [ -f "$FILENAME" ] ; then
    ant "$OPERATION" \
        -propertyfile ant/build.properties \
        -propertyfile $FILENAME
else
    echo "No Credentials File labeled $FILENAME was found in build/ folder!"
    exit
fi 
