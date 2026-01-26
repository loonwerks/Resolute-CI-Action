#!/bin/bash -l

echo "workspace-location: $1"
echo "component-to-analyze: $2"
echo "project-path: $3"
echo "output-path: $4"
echo "validation-only: $5"
echo "csv-output: $6"
echo "exit-on-warning: $7"
echo "supplementary-aadl: $8"

AADL_DIR=${GITHUB_WORKSPACE}/$1

runCommand=(/Sireum/bin/linux/fmide/fmide -application com.rockwellcollins.atc.resolute.cli.Resolute)

runCommand+=(-noSplash -data ${GITHUB_WORKSPACE}/$1 -compImpl $2)

if [[ -n $3 ]]; then
	runCommand+=(-p $3)
	AADL_DIR=${AADL_DIR}/$3
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

# echo "Removing HAMR.aadl as that conflicts with the one contributed by the HAMR OSATE plugin"
# rm -f ${AADL_DIR}/HAMR.aadl
echo "Removing CASE_Scheduling.aadl as that conflicts with the one contributed by the HAMR OSATE plugin"
rm -f ${AADL_DIR}/[Cc][Aa][Ss][Ee]_[Ss]cheduling.aadl

xvfb-run -e /dev/stdout -s "-screen 0 1280x1024x24 -ac -nolisten tcp -nolisten unix" "${runCommand[@]}"

git config --global --add safe.directory ${GITHUB_WORKSPACE}
pushd ${AADL_DIR} && git checkout [Cc][Aa][Ss][Ee]_[Ss]cheduling.aadl && popd
echo "Restored CASE_Scheduling.aadl"

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
