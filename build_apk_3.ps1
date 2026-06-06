Expand-Archive -Path jdk21.zip -DestinationPath jdk21 -Force
$env:JAVA_HOME = "$PWD\jdk21\jdk-21.0.2+13"
$env:ANDROID_HOME = "C:\Users\as989\AppData\Local\Android\Sdk"
cd web_prototype\android
.\gradlew assembleDebug
