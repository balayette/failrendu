#!/bin/bash
TP_DIR="$1"
USER_FIRSTNAME="$2"
USER_LASTNAME="$3"
ZIP_NAME="$4"
DIR_NAME="$5"
TP_DIR_EXISTS=1
AUTHORS_EXISTS=1
README_EXISTS=1

clear
echo "ANTI FAIL RENDU"
echo "Watch out, if the archive arch changes too much, this may not work!"
echo "Alway check the ouput at least once"
echo "I am, of course, not responsible for anything"
echo
echo "HOW TO USE ME?"
echo
echo "There aren't much checks, so the program depends on you to provide accurate info"
echo
echo "bash clean.sh directory_of_the_tp first_name last_name archive_name directory_name"
echo
echo "directory_of_the_tp = name of the directory containing your tp"
echo "first_name = your first name"
echo "last_name = your last name"
echo "archive_name = name of the .zip file"
echo "directory_name = name of the directory inside the archive"
echo
echo "Example : "
echo "bash clean.sh tp nicolas manichon rendu-tp-nicolas.manichon.zip nicolas.manichon"
echo
echo "This will create a rendu-tp-nicolas.manichon.zip archive, containing a folder called 
nicolas.manichon, itself containing all the folders and files contained in tp"
echo
echo "THE SCRIPT AUTOMATICALLY CREATES A README AND AUTHORS FILE IF THEY DONT 
EXIST, AND AUTOMATICALLY DELETES THE obj AND bin FOLDERS"
echo
echo "Are you ready to continue? y/n"
read -n1 key
if [ $key != "y" ]; then
	exit
fi
clear

[ -d "$TP_DIR" ]
TP_DIR_EXISTS=$?

[ -f "$TP_DIR/AUTHORS" ]
AUTHORS_EXISTS=$?

[ -f "$TP_DIR/README" ]
README_EXISTS=$?

if ((TP_DIR_EXISTS == 0)); then
	echo "TP directory exists. COOL"
else
	echo "TP directory doesn't exist. NOT COOL"
	exit
fi

if ((AUTHORS_EXISTS == 0)); then
	echo "AUTHORS file exists. COOL"
else
	echo "AUTHORS file doesn't exist. NOT COOL"
	echo "Automatically creating it!"
	touch "$TP_DIR/AUTHORS"
fi

if ((README_EXISTS == 0)); then
	echo "README file exists. COOL"
else
	echo "README file doesn't exist. NOT COOL"
	echo "Automatically creating it!"
	touch "$TP_DIR/README"
fi

AUTHORS_LEN=$(wc -m < "$TP_DIR/AUTHORS")
README_LEN=$(wc -m < "$TP_DIR/README")

if ((AUTHORS_LEN > 0)); then
	echo "AUTHORS isn't empty. COOL"
else
	echo "AUTHORS is empty. NOT COOL"
	echo "Automatically creating it!"
	echo "$ $USER_FIRSTNAME.$USER_LASTNAME" > "$TP_DIR/AUTHORS"
fi

if ((README_LEN > 0)); then
	echo "README isn't empty. COOL"
else
	echo "README is empty. NOT COOL"
	echo "Automatically writing to it!"
	echo " " > "$TP_DIR/README"
fi

echo "AUTHORS content : "
cat -e "$TP_DIR/AUTHORS"
echo "README content : "
cat -e "$TP_DIR/README"

echo "So far, everything is alright."
echo "Cleaning /tmp/$TP_DIR"

rm -rf "/tmp/$TP_DIR"

echo "Cleaning /tmp/$DIR_NAME"
rm -rf "/tmp/$DIR_NAME"

echo "Copying the directory to /tmp..."

cp -ar "$TP_DIR" /tmp

echo "Removing the bin and obj dirs from the /tmp directory"

find "/tmp/$TP_DIR" -type d -name 'bin' | xargs rm -rf
find "/tmp/$TP_DIR" -type d -name 'obj' | xargs rm -rf

echo "Removed"

echo "Removing the .vs files"
find "/tmp/$TP_DIR" -type d -name '.vs' | xargs rm -rf

echo "Removed"

echo "Removing the .git folder"
find "/tmp/$TP_DIR" -type d -name '.git' | xargs rm -rf

echo "Removed"

echo "Moving the files inside $DIR_NAME"
mv "/tmp/$TP_DIR" "/tmp/$DIR_NAME"
echo "Moved"

cd /tmp/
echo "This is the arch of the tp that will be ziped"
tree "$DIR_NAME"

echo "Creating the zip file"
zip -qr "$ZIP_NAME" "$DIR_NAME"
echo "Created the zip file"
cd -
mv "/tmp/$ZIP_NAME" .

echo "DONE!"
echo "The zip file is right there. Just use ls"

