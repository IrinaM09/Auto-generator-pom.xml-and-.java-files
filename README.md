# Auto-generatoring-pom.xml-and-.java-files
This repository contains a script that generates a pom.xml file with a defined structure and a .java file also with an internal structure.

Prerequisites:
  - pom.xml file with the needed internal structure
  - .java file  with the needed internal structure
  
Usage: 
  from terminal run: ./gen_project.sh <modelVersion> <groupId> <artifactId> <version> <packaging>
  
  example:  ./gen_project.sh 4.0.0  org.apache.maven  my-app  3.0.0  jar
 
 Output:
 
 directory named ${artifactId} with:
  - modified pom.xml file 
  - modified .java file
