#!/bin/bash

owner="rzmudzin"
repo="memorymatrix"
targetStep="Build"
targetWorkflow="Archive"
authToken="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"
outputFile="run-times.csv"


function process_run() {
    #Process passed run id and its associated steps
    jobsUrl="https://api.github.com/repos/$owner/$repo/actions/runs/$1/jobs"
    jobsJson=$(curl --location --request GET "$jobsUrl" \
--header 'Accept: application/vnd.github+json' \
--header 'Authorization: Bearer '"${authToken}" \
--header 'X-GitHub-Api-Version: 2022-11-28')

    jobData=($(jq -r '.jobs[0] | .run_id, .started_at, .completed_at' <<< "$jobsJson" | tr -d '[]," '))
    stepsData=($(jq -r '.jobs[0].steps[] | .name, .started_at, .completed_at' <<< "$jobsJson" | tr -d '[]," '))

    runId="${jobData[0]}"
    runStart="${jobData[1]}"
    runEnd="${jobData[2]}"
    echo "Run Id: $runId"
    echo "Started at $runStart"
    echo "Ended at $runEnd"

    echo "Run Steps: $((${#stepsData[@]} / 3))"
    # Extract Steps Data
    for ((i=0; i<${#stepsData[@]}; i+=3)); do
        stepName="${stepsData[$i]}"
        stepEndTime="${stepsData[$i-1]}"
        stepStartTime="${stepsData[$i-2]}"
        if [[ "$stepName" == "$targetStep" ]];
        then
            echo "$stepName started at $stepStartTime completed at $stepEndTime"
            #Add Row to CSV File for step time
            echo "${targetWorkflow},${runId},${runStart},${runEnd},${stepName},${stepStartTime},${stepEndTime}" >> ${outputFile}
        fi
    done
}

#Output CSV Headers
echo "workflow,runid,run_start,run_end,step,step_start,step_end" > ${outputFile}

#Download all workflow runs for this repo
runsUrl="https://api.github.com/repos/$owner/$repo/actions/runs"
runsJson=$(curl --location --request GET "${runsUrl}" --header 'Accept: application/vnd.github+json' --header 'Authorization: Bearer '"${authToken}" --header 'X-GitHub-Api-Version: 2022-11-28')
runs=($(jq -r '.workflow_runs[] | .name, .status, .id' <<< "$runsJson" | tr -d '[]," '))

#Cycle through all the runs processing completed runs for the target workflow
runsProcessed=0
for ((run=0; run<${#runs[@]}; run+=3)); do
    name="${runs[$run]}"
    runId="${runs[$run-1]}"
    status="${runs[$run-2]}"

    if [[ "$name" == "$targetWorkflow" ]] && [[ "$status" == "completed" ]];
    then
        runsProcessed=$(expr $runsProcessed + 1)
        echo "Processing Workflow $targetWorkflow Run $runId"
        process_run "$runId"
    else
        echo "Skipping Workflow $name"
    fi
done

echo "Processed $runsProcessed runs"
