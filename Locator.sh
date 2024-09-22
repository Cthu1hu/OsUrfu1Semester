if [ "$1" == "/?" ]
then
echo Enter: "bash locator.sh "name of your command"" 
echo Locator can find the command/file you entered and say if it is command or running file
echo Register is significant
echo Enter /? for reference
exit
fi
for a in {$(compgen -b)..$(compgen -k)}
do
if [ "$1" == "$a" ]
then echo "is internal" && exit
fi
done
IFS=$':'
test -f /bin/$1 && echo "is external: /bin/$1" && exit
test -f $(pwd)/$1 && if  [ -x “$(pwd)/$1” ];
then 
echo "is executable: $(pwd)/$1" && exit
exit
fi
for a in $PATH
do
test -f $a/$1 && if [ -x "$a/$1" ]; 
then 
echo "is executable: $a/$1" && exit
fi
done
echo "The $1 is not command or executable file, try again or enter a /? for reference"
