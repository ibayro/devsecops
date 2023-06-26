#!/bin/bash

command -v gitleaks >/dev/null 2>&1 || { 
    echo >&2 "Gitleaks is not found. Installing Gitleaks on a local machine.";
    
    # Installing Gitleaks takes into consideration the OS type of a local machine.
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.17.0/gitleaks_8.17.0_linux_x64.tar.gz | tar -xvz
        export PATH=$(pwd):$PATH
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.17.0/gitleaks_8.17.0_darwin_arm64.tar.gz | tar -xz
        export PATH=$(pwd):$PATH
    elif [[ "$OSTYPE" == "win32"* ]]; then
        curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.17.0/gitleaks_8.17.0_windows_arm64.zip | tar -xvz
        export PATH=$(pwd):$PATH
     elif [[ "$OSTYPE" == "cygwin"* ]]; then
        curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.17.0/gitleaks_8.17.0_windows_arm64.zip | tar -xvz
        export PATH=$(pwd):$PATH
    else
        echo >&2 "Couldn't install gitleaks. Unknown OS is detected."; 
        exit 1;
    fi
}

ENABLE=$(git config --bool hooks.gitleaks-enable)

# ENABLE option check
if [ "$ENABLE" != "true" ]; then
    echo "Secret visibility verification. Type the command: "git config hooks.gitleaks-enable true" in order to enable this option"
    exit 0
fi

gitleaks detect --source . -v --redact

if [ "$?" != "0" ]; then
    echo "Secret has been detected. Sensitive data will not pass. Take proper security actions in order to proceed."
else
    echo "Secret has not been detected. Security actions have been taken."
    exit 1
fi

gitleaks protect

if [ "$?" -eq "0" ]; then
	echo "Secret has not been detected. Gitleak protection is activated"
fi

exit 0
