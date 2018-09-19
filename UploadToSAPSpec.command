#! /bin/bash

BASEDIR=$(dirname $0)

cd $BASEDIR

pod repo push com-ios-sapspecs SAPThemeManager.podspec --allow-warnings --verbose --sources=com-ios-sapspecs,master
