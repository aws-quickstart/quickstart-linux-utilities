#!/usr/bin/bash -e 
# QuickStart Common Linux Tools
# author: tonynv@amazon.com
#
# Supported operating systems:
# -Red Hat Enterprise Linux
# -Centos
# -Ubuntu
# -Fedora
# -Amazon Linux
# -SUSE

# Configuration
PROGRAM='QuickStart Linux Common Tools'

# Detects operating system type and return vaule
# If no varible is passed in function will print to stdout
# 
function qs_get-ostype () {
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

        if [ $? -eq 0 ] && [ "$__return" ];then
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

# Returns operating system version or return 1
# If no varible is passed in function will print to stdout
# 
function qs_get-osversion () {
    local __return=$1
    DETECTION_STRING="/etc/*-release"
    if [[ $(ls ${DETECTION_STRING})  ]]; then
        OSLEVEL=$(cat /etc/*-release \
        | grep VERSION_ID \
        | tr -d \" \
        | awk -F= '{print $2}')

        if [ $? -eq 0 ] && [ "$__return" ];then
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

# If python is install Returns default python path
# If no varible is passed in function will print to stdout
function qs_get-python-path () {
    local __return=$1
    # Set PYTHON_EXECUTEABLE to default python version
    if command -v python > /dev/null 2>&1; then
       PYTHON_EXECUTEABLE=$(which python)
    else
       PYTHON_EXECUTEABLE=$(which python3)
    fi

    #Return python path or return code (1)
    if [ $PYTHON_EXECUTEABLE ] && [ "$__return" ]; then
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

# Installs pip from pypa
function  qs_bootstrap_pip () {
	curl --silent \
	 --show-error \
	--retry 5 \
	https://bootstrap.pypa.io/get-pip.py | sudo qs_get-python-path
}

# Updates supported operating systems to latest or exit with code (1)
# If no varible is passed in function will print to stdout
function qs_update-os () {
    # Assigns values to INSTANCE_OSTYPE
    get_ostype INSTANCE_OSTYPE
    get_osversion INSTANCE_OSVERSION

    if [ "$INSTANCE_OSTYPE" == "AMZN" ]; then
    	yum update -y
    elif [ "$INSTANCE_OSTYPE" == "Ubuntu" ]; then
    	apt-get update -y
    elif [ "$INSTANCE_OSTYPE" == "RedHat" ]; then
    	yum update -y
    elif [ "$INSTANCE_OSTYPE" == "CentOS" ]; then
    	yum update -y
    elif [ "$INSTANCE_OSTYPE" == "fedora" ]; then
    	dnf update -y	
    elif [ "$INSTANCE_OSTYPE" == "SUSE" ]; then
    	zypper refresh && zypper update
    else
        exit 1
    fi
}