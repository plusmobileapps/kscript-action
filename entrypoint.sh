#!/bin/sh -l

# export PATH=$PATH:/usr/local/sdkman/candidates/java/current/bin/java
# export PATH=$PATH:/usr/local/sdkman/candidates/kotlin/current/bin/kotlin
# export PATH=$PATH:/usr/local/sdkman/candidates/kscript/current/bin/kscript
# export PATH=$PATH:/usr/local/sdkman/candidates/gradle/current/bin/gradle

kscript /ktest.kts /github/workspace/$1

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
