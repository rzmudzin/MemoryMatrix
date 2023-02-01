#!/bin/bash

# owner="mobile"
# repo="ios"
# targetStep="Archivingproject"
# targetWorkflow="BuildFeatureBranch"
# authToken="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"
# baseUrl="https://git.marriott.com/api/v3/repos"

owner="rzmudzin"
repo="memorymatrix"
targetStep="Build"
targetWorkflow="Archive"
authToken="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"
baseUrl="https://api.github.com/repos"

outputFile="run-times.csv"
jq="$HOME/jq/jq"

function installJQ() {
    if [ -f "$jq" ];
    then
        echo "JQ install found"
    else
        echo "Install JQ"
        mkdir -p "$HOME/jq"
        cp "./bin/jq" "$jq"
        xattr -dr com.apple.quarantine "$jq"
    fi

}

function process_run() {
    #Process passed run id and its associated steps
    jobsUrl="$baseUrl/$owner/$repo/actions/runs/$1/jobs"
    echo "$jobsUrl"
    jobsJson=$(curl --location --request GET "$jobsUrl" \
--header 'Accept: application/vnd.github+json' \
--header 'Authorization: Bearer '"${authToken}" \
--header 'X-GitHub-Api-Version: 2022-11-28')

    jobData=($("${jq}" -r '.jobs[0] | .run_id, .started_at, .completed_at' <<< "$jobsJson" | tr -d '[]," '))
    stepsData=($("${jq}" -r '.jobs[0].steps[] | .name, .started_at, .completed_at' <<< "$jobsJson" | tr -d '[]," '))

    runId="${jobData[0]}"
    runStart="${jobData[1]}"
    runEnd="${jobData[2]}"
    echo -e "\t Run Id: $runId"
    echo -e "\t Started at $runStart"
    echo -e "\t Ended at $runEnd"

    echo "Run Steps: $((${#stepsData[@]} / 3))"
    # Extract Steps Data
    for ((i=0; i<${#stepsData[@]}; i++)); do
        stepName="${stepsData[$i]}"
        stepStartTime="${stepsData[$i+1]}"
        stepEndTime="${stepsData[$i+2]}"
        if [[ "$stepName" == "$targetStep" ]];
        then
            echo -e "\t $stepName started at $stepStartTime completed at $stepEndTime"
            #Add Row to CSV File for step time
            echo "${targetWorkflow},${runId},${runStart},${runEnd},${stepName},${stepStartTime},${stepEndTime}" >> ${outputFile}
        fi
        i=$(expr $i + 2)
    done

    echo "Run Processing Complete"
}

installJQ

#Output CSV Headers
echo "workflow,runid,run_start,run_end,step,step_start,step_end" > ${outputFile}

#Download all workflow runs for this repo
runsUrl="$baseUrl/$owner/$repo/actions/runs"
runsJson=$(curl --location --request GET "${runsUrl}" --header 'Accept: application/vnd.github+json' --header 'Authorization: Bearer '"${authToken}" --header 'X-GitHub-Api-Version: 2022-11-28')
runs=($("${jq}" -r '.workflow_runs[] | .name, .status, .id' <<< "$runsJson" | tr -d '[]," '))

#Cycle through all the runs processing completed runs for the target workflow
runsProcessed=0
for ((run=0; run<${#runs[@]}; run++)); do
    name="${runs[$run]}"
    status="${runs[$run+1]}"
    runId="${runs[$run+2]}"

    if [[ "$name" == "$targetWorkflow" ]] && [[ "$status" == "completed" ]];
    then
        runsProcessed=$(expr $runsProcessed + 1)
        echo "Processing Workflow $targetWorkflow Run $runId"
        process_run "$runId"
    else
        echo "Skipping Workflow $name Run $runId (status $status)"
    fi
    run=$(expr $run + 2)
done

echo "Processed $runsProcessed runs"
