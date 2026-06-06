$env:JAVA_HOME = "$PWD\jdk17\jdk-17.0.10+7"
$env:ANDROID_HOME = "C:\Users\as989\AppData\Local\Android\Sdk"
cd web_prototype\android
.\gradlew assembleDebug
