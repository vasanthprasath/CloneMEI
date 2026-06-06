Expand-Archive -Path jdk17.zip -DestinationPath jdk17 -Force
$env:JAVA_HOME = "$PWD\jdk17\jdk-17.0.10+7"
cd web_prototype\android
.\gradlew assembleDebug
