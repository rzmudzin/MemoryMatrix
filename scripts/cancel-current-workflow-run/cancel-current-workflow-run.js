const github = require('@actions/github');
const core = require('@actions/core');

function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}

async function run() {
    
    //Extract the passed token and obtain repo info from context
    const token = process.argv[2];
    const { GITHUB_RUN_ID } = process.env;
    const { eventName, sha, ref, repo: { owner, repo }, payload, } = github.context;
    let runId = Number(GITHUB_RUN_ID);

    //Connect to github and get the current run's info
    const octokit = github.getOctokit(token);
    const { data: current_run } = await octokit.rest.actions.getWorkflowRun({
        owner,
        repo,
        run_id: runId,
    });
    // console.log(current_run);    //Uncomment to log the current run for any debugging needs that arise
    
    let workflow_name = current_run.name;
    let workflow_id = current_run.workflow_id;
    let status = current_run.status;
    console.log('Cancel requested for run id ' + runId + ' from workflow ' + workflow_name + '. Current status ' + status);

    // Cancel the current run
    console.log(`Canceling current run ${runId}`);
    const result = await octokit.rest.actions.cancelWorkflowRun({
            owner,
            repo,
            run_id: runId,
        });
    console.log(`Cancel run ${runId} responded with status ${result.status}`);

    //Poll for run status, force an exit if we have not been canceled after 1 minute. No need to break loop or check status as successful cancel causes immediate exit
    for(var i=0; i<6; ++i) {
        console.log(i);
        await delay(5000);
        const { data: runInfo } = await octokit.rest.actions.getWorkflowRun({
            owner,
            repo,
            run_id: runId,
        });
        console.log('Cancel of run id ' + runId + ' from workflow ' + workflow_name + ' pending. Current run status ' + runInfo.status);
    }
    console.log('Cancel of run id ' + runId + ' from workflow ' + workflow_name + ' unsuccessful. Forcing exit.');
    process.exit(11);

}

run();