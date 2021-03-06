#!/bin/sh -e
#

printUsage() {
   echo "Usage : "
   echo "./compile.sh SHA1"
   echo "    SHA1: SHA1 to build (optional)"
   exit 1
}

ORIGIN=/origin
DESTINATION=/destination

for arg in "$@"
do
   case $arg in
      -*)
         echo "Invalid option: -$OPTARG"
         printUsage
         ;;
      *)
         if ! [ -z "$1" ]; then
            SHA1=$1
         fi
         ;;
   esac
   if [ "0" -lt "$#" ]; then
      shift
   fi
done

if [ -z "$SHA1" ]; then
   SHA1=master
fi

# Sources retrieval
git clone $ORIGIN/.
git checkout $SHA1

# Compilation

export MAVEN_OPTS="-Xmx7168m -Xms2048m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC -XX:-UseGCOverheadLimit"

mvn clean install -DskipTests
mvn clean site:site -Dmaven.javadoc.skip=true
mvn site:stage -DstagingDirectory=$DESTINATION/
