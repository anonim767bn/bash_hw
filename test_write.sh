#!/bin/bash
serviceFile=".heshes"
script="write.sh"

rm $serviceFile
bash $script

if [[ $? -eq 1 ]]
then
    echo "!!!!!!тест с отсутствием аргументов прошёл успешно"
else
    echo "!!!!!!тест провален"
    exit 1
fi

rm $serviceFile

touch test.file
bash $script test.file

if [[ $? -eq 2 ]]
then
    echo "!!!!!!тест на проверку директории прошёл успешно"
else
    echo "тест на директорию провален"
    rm test.file
    rm $serviceFile
    exit 2
fi

rm test.file
rm $serviceFile

bash $script .

while read line
do
    realHash="$(sha256sum `echo $line | awk '{print $2}'` | awk '{print $1}')"
    if [[ "$(echo $line | awk '{print $1}')" != "$realHash" ]]
    then
        echo "тест правильности записи хеш сумм провален"
        rm $serviceFile
        exit 3
    fi
done < "$serviceFile"

rm $serviceFile

echo "!!!!!!!тест на правильность записи хеш сумм прошел успешно"
exit 0
