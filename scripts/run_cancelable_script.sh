
#!/bin/bash

"$@"
status=$?
if [ $status -eq 11 ]
then
    echo "Canceling Workflow. Child script returned exit code of $status"
    npm install --prefix "${GH_SCRIPTS_PATH}/cancel-current-workflow-run" "${GH_SCRIPTS_PATH}/cancel-current-workflow-run"
    node "${GH_SCRIPTS_PATH}/cancel-current-workflow-run/cancel-current-workflow-run.js" "${GITHUB_TOKEN}"
else
    if [ $status -ne 0 ]
    then
        echo "Script returned failed exit code $status. Exiting Workflow"
        exit $status
    fi
fi
