#!/bin/bash
defects=0
delete=0
create=0

dir=$1
serviceFile=".heshes"

if [[ ! -n $1 ]]
then
echo "вы не ввели путь к нужной директории, по умолчанию будет использоваться текущая директория"
dir="."
fi

if [[ ! -d $dir ]]
then
    echo "это не директория"
    exit 1
fi

if [[ ! -f $dir/$serviceFile ]]
then
    echo "служебный файл не найден"
    exit 2
else
    echo "служебный файл успешно найден"
fi

while read line
do
    fileName=$(echo $line | awk '{print $2}')
    fileHash=$(echo $line | awk '{print $1}')
    if [[ ! -f $dir/$fileName ]]
    then
        echo "файл $fileName не найден"
        delete=$(($delete+1))
        continue
    fi
    shaSum="$(sha256sum $dir/$fileName | awk '{print $1}')"
    if [ "$shaSum" != "$fileHash" ]
    then
        echo "файл $fileName был изменен"
        defects=$(($defects+1))
    fi
done < $dir/$serviceFile

create=$((`wc -l < $dir/$serviceFile`-`ls -1 | wc -l`))

if [[ $defects -eq 0 && create -eq 0 ]]
then
    echo "проверка прошла успешно файлы не были изменены"
    exit 0
else
    echo "проверка провалена $defects файла(ов) было изменено, $delete файла(ов) удалено и $create новых файлов создано"
    exit 3
fi