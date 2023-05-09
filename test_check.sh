#!/bin/bash

testFile=noDirectory
touch $testFile
bash check.sh $testFile
if [[ $? -eq 1 ]]
then
    echo "!!!!!тест на директорию прошёл успешно"
    rm $testFile
else
    rm $testFile
    exit 1
fi

if [[ -f ".heshes" ]]
then
    rm .heshes
fi

bash check.sh .
if [[ $? -eq 2 ]]
then
    echo "!!!!!тест на наличие служебного файла прошел успешно"
else
    exit 2
fi
bash write.sh .
echo "random text">random.file
bash check.sh .
if [[ $? -eq 3 ]]
then
    echo "!!!!!тест с изменением файлов прошёл успешно"
    rm random.file
    rm .heshes
else
    rm random.file
    rm .heshes
    exit 3
fi

bash write.sh .
bash check.sh .

if [[ $? -eq 0 ]]
then
    echo "!!!!!тест с неизмененными файлами прошел успешно"
else
    exit 4
fi
rm .heshes
exit 0