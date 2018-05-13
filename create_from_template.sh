#!/bin/bash

USAGE=$'Usage

  ./create_from_template [options]

Options
  -d	Destination directory
  -t	Project template to use
  -v	Specify macro and value: <NAME>=<VALUE>'


if [ "$#" == "0" ] || [ "$1" == "-h" ]; then
	echo "${USAGE}"
	exit 1
fi

declare -A CONFIG
declare -A MACROS

# Load default configuration and macros
while read line
do
    if echo $line | grep -F = &>/dev/null
    then
        var=$(echo "$line" | cut -d '=' -f 1)
        CONFIG[$var]=$(echo "$line" | cut -d '=' -f 2-)
    fi
done < templates.conf.default

while read line
do
    if echo $line | grep -F = &>/dev/null
    then
        var=$(echo "$line" | cut -d '=' -f 1)
        MACROS[$var]=$(echo "$line" | cut -d '=' -f 2-)
    fi
done < macros.conf.default

# Parse options
while (($#)); do
	
	case $1 in
	-t)
		if [ "$#" == 1 ]; then
			echo "Error: Provide template name"
			exit 1
		fi
	
		CONFIG["TEMPLATE"]=$2
		shift
		;;
	-d)
		if [ "$#" == 1 ]; then
			echo "Error: Provide destination directory"
			exit 1
		fi
		
		CONFIG["DEST_DIR"]=$2
		shift	
		;;
	-p)
		if [ "$#" == 1 ]; then
			echo "Error: Provide project name"
			exit 1
		fi
		
		CONFIG["PROJECT_NAME"]=$2
		shift	
		;;
	-v)
		if [ "$#" == 1 ]; then
			echo "Error: Provide macro value"
			exit 1
		fi
		
		name=$(echo $2 | cut -f1 -d=)
		val=$(echo $2 | cut -f2 -d=)
		MACROS[${name}]=${val}

		shift
		;;
	*)
		echo \"$1\": unknown parameter
	esac
	shift
done

MACROS["PROJECT_NAME"]=${CONFIG["PROJECT_NAME"]}

# Check if PROJECT_NAME is set
if [ -z ${CONFIG["PROJECT_NAME"]} ]; then
	echo "Error: Project name must be provided (-p option)"
	exit 1
fi

# Set EXECUTABLE_NAME to PROJECT_NAME if it's not set
if [ -z ${MACROS["EXECUTABLE_NAME"]} ]; then
	MACROS["EXECUTABLE_NAME"]=${MACROS["PROJECT_NAME"]}
fi

# Copy template to new directory
cp -r "./${CONFIG["TEMPLATE"]}" "${CONFIG["DEST_DIR"]}/${CONFIG["PROJECT_NAME"]}"
cd "${CONFIG["DEST_DIR"]}/${CONFIG["PROJECT_NAME"]}"

# Run macros
for i in "${!MACROS[@]}"; do
	echo $i = ${MACROS[$i]}
	find . -type f -name "*.*" -exec sed -i'' -e "s/{{$i}}/${MACROS[$i]}/g" {} +
done

# Initialize git bare repository
git init
git add ./*
git commit -am "Initial commit"
mv .git ../${CONFIG["PROJECT_NAME"]}.git
cd ..
rm -rf ${CONFIG["PROJECT_NAME"]}
cd ${CONFIG["PROJECT_NAME"]}.git
git config --bool core.bare true
