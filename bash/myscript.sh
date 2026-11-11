#!/bin/bash

myname="Thiago"
myage="23"

echo "Hello, my name is $myname."
echo "I'm $myage years old."

# files=$(ls) -> cria uma lista com a saída de ls
files=$(ls)
echo $files
# now=$(date) -> dia e hora atual
now=$(date)
echo "The system time and date is:"

echo $now

echo "Hello $myname"

echo "The system time and date is:"

echo $now

echo "Your username is: $USER"

# Basic Math
# \* escapa o * se não entende que é qualquer coisa, e pega uma pasta
expr 30 + 10
expr 100 \* 4

#############################
# If statements
# eq = equal
# gt = greater than
# ne = not equal
# o comando else if no bash é elif
mynum=300

if [ $mynum -ne 200 ]
then
    echo "The condition is true."
else
    echo "The variable does not equal 23."
fi

# -f -> indica que faz uma verificação de arquivo
if [ -f ~/myfile ]
then
    echo "The file exists."
else
    echo "The file does not exist."
fi

command=htop

# o command verifica a existência de um comando $command
# -v -> resposta em formato verboso
# quando colocamos os colchetes estamos usando o comando teste em segundo plano

if command -v $command
then
    echo "$command is available, let's run it..."
else
    echo "$command is NOT available, installing it..."
    sudo apt update && sudo apt install -y $command
    # o && indica que se o primeiro comandar funcionar, ele vai executar o segundo
fi

# executa o comando após ter baixado
# $command

##### Exit Codes
package=htop

# redireciona a saída para package_install_results
# sudo apt install $package >> package_install_results.log

if [ $? -eq 0 ]
then
    echo "The installation of $package was successful."
    echo "The new command is available here:"
    which $package
else
    echo "$package failed to install." >> package_install_failure.log
fi

directory=/etc

if [ -d $directory ]
then
    echo "The directory $directory exists."
    exit 0
else
    echo "The directory $directory doesn't exist."
    exit 212
fi

echo "The exit code for this script run is $?"
