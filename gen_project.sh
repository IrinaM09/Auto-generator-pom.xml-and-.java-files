#! /bin/bash

# Author: Irina Mitocaru

# Description.
# 
# This script generates a directory with:
#   - a pom.xml file
#   - a .java class with the two methods from DVHABCProject


# global variables
modelVersion=$1
groupId=$2
artifactId=$3
version=$4
packaging=$5

# constants
OLD_POM_FILE="old_pom.xml"
POM_FILE="pom.xml"
OLD_CLASS_FILE="old_class.java"
CLASS_FILE="$3.java"
OLD_DIR="OLD"
FILE_ERR="Error: File does not exist"
FILE_READ_ERR="Error: File does not have read access"
FILE_WRITE_ERR="Error: File does not have write access"
ARGS_ERR="Error: Not enough arguments given"
SNAPSHOT="-SNAPSHOT"


usage()
{
    printf  "\n--------------------------------------------------------------------------\n
    Usage: <modelVersion> <groupId> <artifactId> <version> <packaging>\n
            4.0.0  org.apache.maven  my-app  3.0.0  jar
             \n--------------------------------------------------------------------------\n"
}

check_pom()
{
    printf "\nValidating arguments and old pom.xml file\n"
    # check number of arguments
    if [ $# -ne 5 ]; then
        printf "[pom.xml] $ARGS_ERR\n"
        exit 1;
    fi

    # check pom.xml file existance
    if [ ! -f "$OLD_POM_FILE" ]; then
        printf "[pom.xml] $FILE_ERR\n"
        exit 1;
    fi

    # check if pom.xml has read access
    if [ ! -r "$OLD_POM_FILE" ]; then
        printf "[pom.xml] $FILE_READ_ERR\n"
        exit 1;
    fi

    # check if pom.xml has write access
    if [ ! -w "$OLD_POM_FILE" ]; then
        printf "[pom.xml] $FILE_WRITE_ERR\n"
        exit 1;
    fi
}

clone_pom()
{
    cp "$OLD_POM_FILE" "$POM_FILE" > /dev/null 2>&1
}

update_pom()
{
    printf "\nGenerating pom.xml file\n"

    # update modelVersion
    printf "Updating modelVersion...\n"
    sed -i "s/<modelVersion><\/modelVersion>/<modelVersion>$modelVersion<\/modelVersion>/" $POM_FILE

    # update groupId
    printf "Updating groupId...\n"
    sed -i "s/<groupId><\/groupId>/<groupId>$groupId<\/groupId>/" $POM_FILE

    # update artifactId
    printf "Updating artifactId...\n"
    sed -i "s/<artifactId><\/artifactId>/<artifactId>$artifactId<\/artifactId>/" $POM_FILE

    # update version
    printf "Updating version...\n"
    sed -i "s/<version><\/version>/<version>$version$SNAPSHOT<\/version>/" $POM_FILE

    # update packaging
    printf "Updating packaging...\n"
    sed -i "s/<packaging><\/packaging>/<packaging>$packaging<\/packaging>/" $POM_FILE

    # update configuration
    printf "Updating configuration...\n"
    sed -i "/<manifestEntries>/,/<\/manifestEntries>/ s/<mainInterface><\/mainInterface>/<mainInterface>$groupId.$artifactId<\/mainInterface>/;" $POM_FILE
    sed -i "s/<finalName><\/finalName>/<finalName>$artifactId<\/finalName>/" $POM_FILE
}

check_class()
{
    printf "\nValidating old .java file\n"

    # check old_class.java file existance
    if [ ! -f "$OLD_CLASS_FILE" ]; then
        printf "[old_class.java] $FILE_ERR\n"
        exit 1;
    fi

    # check if old_class.java has read access
    if [ ! -r "$OLD_CLASS_FILE" ]; then
        printf "[old_class.java] $FILE_READ_ERR\n"
        exit 1;
    fi

    # check if old_class.java has write access
    if [ ! -w "$OLD_CLASS_FILE" ]; then
        printf "[old_class.java] $FILE_WRITE_ERR\n";
        exit 1;
    fi
}

clone_class()
{
    cp "$OLD_CLASS_FILE" "$CLASS_FILE" > /dev/null 2>&1
}

update_class()
{
    printf "\nGenerating .java file\n"
    
    # add package
    printf "Adding package...\n"
    sed -i "1s/^/package $groupId;\n\n/" $CLASS_FILE

    # update class name
    printf "Updating class name...\n"
    sed -i "s/ClassName/$artifactId/" $CLASS_FILE
}

create_dir()
{
    # create directory
    printf "\nMoving files to directory $artifactId\n"
    mkdir -p $artifactId;
    mv $CLASS_FILE $artifactId
    mv $POM_FILE $artifactId
}

cleanup()
{
    # create old directory
    printf "\nMoving old files to directory $OLD_DIR;\nthis directory can be deleted\n"
    mkdir -p $OLD_DIR;
    mv $OLD_CLASS_FILE $OLD_DIR
    mv $OLD_POM_FILE $OLD_DIR
}

# call helper functions
usage

# call functions to update pom.xml file
check_pom $modelVersion $groupId $artifactId $version $packaging
clone_pom
update_pom

# call functions to update .java class
check_class
clone_class
update_class

# call functions to refactorize and cleanup
create_dir
cleanup
printf "\nDone\n"