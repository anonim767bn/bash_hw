#!/bin/bash
serviceFile=".heshes"
if [[ ! -n $1 ]]
then
    echo "не даны аргументы"
    exit 1
fi

if [[ ! -d $1 ]]
then
    echo "это не директория"
    exit 2
fi

if [[ -f $serviceFile ]]
then
    echo "служебный файл с хешами уже существует, если хотите проверить целостность файлов, то запустите check.sh"
    echo "если хотите выйти введите 0, если хотите перезаписать файл с хешами, то введите любое число"
    read input
    if [[ $input -eq 0 ]]
    then
    echo "досвидаия..."
    exit 0
    fi
    rm $serviceFile
    touch $serviceFile
    echo "файл с хешами очищен и будет перезаписан новыми данными"
else
    touch $serviceFile
    echo "создан служебный файл"
fi

for file in ./*
do
echo $(sha256sum $file)>>$serviceFile
echo `sha256sum $file`
done

echo "готово"
exit 0

