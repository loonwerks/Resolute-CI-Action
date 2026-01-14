#!/bin/bash -l

echo "workspace-location: $1"
echo "component-to-analyze: $2"
echo "project-path: $3"
echo "output-path: $4"
echo "validation-only: $5"
echo "csv-output: $6"
echo "exit-on-warning: $7"
echo "supplementary-aadl: $8"

runCommand=(/Sireum/bin/linux/fmide/fmide -application com.rockwellcollins.atc.resolute.cli.Resolute)

runCommand+=(-noSplash -data ${GITHUB_WORKSPACE}/$1 -compImpl $2)

if [[ -n $3 ]]; then
	runCommand+=(-p $3)
fi

if [ "XX $5" = 'XX "true"' ] ; then
	runCommand+=(-validationOnly)
fi

if [ "XX $6" = 'XX "true"' ]; then
	runCommand+=(-csv)
fi

if [ "XX $7" = 'XX "true"' ]; then
	runCommand+=(-exitOnValidationWarning)
fi

if [[ -n $8 ]]; then
	runCommand+=(-files $8)
fi

runCommand+=(-o $4)

xvfb-run -e /dev/stdout -s "-screen 0 1280x1024x24 -ac -nolisten tcp -nolisten unix" "${runCommand[@]}"

echo "timestamp=$(jq .date $4)" >> $GITHUB_OUTPUT
echo "status=$(jq .status $4)" >> $GITHUB_OUTPUT
echo "status-messages=$(jq .statusMessages $4)" >> $GITHUB_OUTPUT

exitStatus=1
analysisStatus=$(jq .status $4)
echo "analysisStatus: $analysisStatus"
if [ "XX $analysisStatus" = 'XX "Analysis Completed"' ]; then
	claimsTrue=$(jq "[.results[] | .status] | all" $4)
	if [ "XX $claimsTrue" = 'XX "true"' ]; then
		exitStatus=0
	fi
fi
echo "exitStatus: $exitStatus"
exit $exitStatus
