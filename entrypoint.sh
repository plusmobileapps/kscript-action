#!/bin/sh -l

kscript /ktest.kts /github/workspace/$1

# if [[ $? -eq 0 ]]; then
#     echo "Tests passed. Do something."
# else
#     echo "Tests didn't pass. Do something."
#     exit 1
# fi