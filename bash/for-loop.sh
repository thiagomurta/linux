#!/bin/bash

#### first example
# for current_number in 1 2 3 4 5 6 7 8 9 10
# do
#     echo $current_number
#     sleep 1
# done
#
# echo "This is outside of the for loop."

#### second example
# for n in {1..10}
# do
#     echo $n
#     sleep 1
# done
#
# echo "This is outside of the for loop."

#### third example
for file in logfiles/*.log
do
    tar -czvf $file.tar.gz $file
    # compactar todo arquivo $file no formato $file.tar.gz
done

