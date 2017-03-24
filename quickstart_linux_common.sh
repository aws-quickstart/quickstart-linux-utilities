#!/usr/bin/bash -e 
# QuickStart Common Linux Tools
# author: tonynv@amazon.com
#
# Supported operating systems:
# -Red Hat Enterprise Linux
# -Centos
# -Ubuntu
# -Amazon Linux
# -SUSE

# Configuration
PROGRAM='QuickStart Linux Common Tools'

# Detects operating system type and return vaule
# If no varible is pass in function will print to standard out
# 
function get_ostype () {
        local __return=$1
        DETECTION_STRING="/etc/*-release"
        if [[ $(ls ${DETECTION_STRING}) ]]; then
                OS=$(cat /etc/*-release \
                | grep PRETTY_NAME \
                | tr -d \" \
                | awk -F= '{print $2}'\
                | awk '{print $1,$2}'  \
                | sed 's/Linux//g' \
                | sed 's/[^a-zA-Z]//g')

                if [ $? -eq 0 ] && [ "$__return" ]
                then
                        eval $__return="${OS}"
                        return 0
                elif [ $OS ]; then
                        echo $OS
                        return 0;
                else
                     echo "Unknown"
                fi
        else
                if [ "$__return" ]; then
                        __return="Unknown"
                        return 1
                else
                        echo "Unknown"
                        return 1;
                fi
        fi
}


function get_osversion () {
        local __return=$1
        DETECTION_STRING="/etc/*-release"
        if [[ $(ls ${DETECTION_STRING})  ]]; then
                OSLEVEL=$(cat /etc/*-release \
                | grep VERSION_ID \
                | tr -d \" \
                | awk -F= '{print $2}')

                if [ $? -eq 0 ] && [ "$__return" ]
                then
                        eval $__return="${OSLEVEL}"
                        return 0
                elif [ $OS ]; then
                        echo $OSLEVEL
                        return 0;
                else
                     echo "Unknown"
                fi
        else
                if [ "$__return" ]; then
                        __return="Unknown"
                        return 1
                else
                        echo "Unknown"
                        return 1;
                fi
        fi
}


function get_python_path () {
        local __return=$1
        if command -v python > /dev/null 2>&1; then
           PYTHON_EXECUTEABLE=$(which python)
        else
           PYTHON_EXECUTEABLE=$(which python3)
        fi
	if [ $PYTHON_EXECUTEABLE ] && [ "$__return" ]
                then
                    eval $__return="${PYTHON_EXECUTEABLE}"
                    return 0
                elif [ $PYTHON_EXECUTEABLE ]; then
                    echo $PYTHON_EXECUTEABLE
                    return 0;
                else
                    echo "Python Not installed"
		    return 1
                fi

}

# Assigns values to INSTANCE_OSTYPE
get_ostype INSTANCE_OSTYPE
get_osversion INSTANCE_OSVERSION

def function install_pip () {

if [ "$INSTANCE_OSTYPE" == "AMZN" ]; then
    curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo get_python_path 
elif [ "$INSTANCE_OSTYPE" == "Ubuntu" ]; then
    curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo get_python_path 
elif [ "$INSTANCE_OSTYPE" == "RedHat" ]; then
    curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo get_python_path 
elif [ "$INSTANCE_OSTYPE" == "CentOS" ]; then
    curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo get_python_path 
elif [ "$INSTANCE_OSTYPE" == "fedora" ]; then
    curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo get_python_path 
elif [ "$INSTANCE_OSTYPE" == "SUSE" ]; then
    curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo get_python_path 
else
    echo "[ERROR] ${INSTANCE_OSTYPE) not Supported"
    exit 1

