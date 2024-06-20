
#!/bin/bash

"$@"
status=$?
if [ $status -eq 11 ]
then
    echo "Canceling Workflow. Child script returned exit code of $status"
    npm install --prefix "${GITHUB_WORKSPACE}/scripts/cancel-current-workflow-run" "${GITHUB_WORKSPACE}/scripts/cancel-current-workflow-run"
    node "${GITHUB_WORKSPACE}/scripts/cancel-current-workflow-run/cancel-current-workflow-run.js" "${GITHUB_TOKEN}"
else
    if [ $status -ne 0 ]
    then
        echo "Script returned failed exit code $status. Exiting Workflow"
        exit $status
    fi
fi
