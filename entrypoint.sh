#!/bin/sh -l

resoluteOutput=$GITHUB_WORKSPACE/Resolute_output.json
ls -la $GITHUB_WORKSPACE

echo "workspace-location: $1"
echo "component-to-analyze: $2"
echo "project-path: $3"
echo "output-path: $4"
echo "validation-only: $5"
echo "csv-output: $6"
echo "exit-on-warning: $7"
echo "supplementary-aadl: $8"
echo "resoluteOutput: $resoluteOutput"

runCommand = (/fmide/osate -application com.rockwellcollins.atc.resolute.cli.Resolute \
  -noSplash -data $GITHUB_WORKSPACE/$1 -compImpl $2 -output $4)

if [[ -n $3 ]]; then
	runCommand += (-p $3)
fi

if [ "XX $5" = 'XX "true"' ] ; then
	runCommand += (-validationOnly)
fi

if [ "XX $6" = 'XX "true"' ]; then
	runCommand += (-csv)
fi

if [ "XX $7" = 'XX "true"' ]; then
	runCommand += (-exitOnValidationWarning)
fi

if [[ -n $8 ]]; then
	runCommand += (-files $8)
fi

runCommand += (-o $resoluteOutput $resoluteOutput)

xvfb-run -e /dev/stdout -s "-screen 0 1280x1024x24 -ac -nolisten tcp -nolisten unix" "${runCommand[@]}"

echo "timestamp=$(jq .date $resoluteOutput)" >> $GITHUB_OUTPUT
echo "status=$(jq .status $resoluteOutput)" >> $GITHUB_OUTPUT
echo "status-messages=$(jq .statusMessages $resoluteOutput)" >> $GITHUB_OUTPUT

exitStatus=1
analysisStatus=$(jq .status $resoluteOutput)
echo "analysisStatus: $analysisStatus"
if [ "XX $analysisStatus" = 'XX "Analysis Completed"' ]; then
	claimsTrue=$(jq "[.results[] | .status] | all" $resoluteOutput)
	if [ "XX $claimsTrue" = 'XX "true"' ]; then
		exitStatus=0
	fi
fi
echo "exitStatus: $exitStatus"
exit $exitStatus
