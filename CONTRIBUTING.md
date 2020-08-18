# Contribute a new replication adapter

The document drafted here is targeting to provide a simple guideline for the developer who wants to contribute a new
replication adapter to support content replications between Harbor and a new 3rd container registry.

## 1. Code development

1. Adapter code is kept at the [harbor main repository](https://github.com/goharbor/harbor) (not this repository). Fork the
Harbor repository to your namespace.
2. Read the [Harbor contributing guide](https://github.com/goharbor/harbor/blob/master/CONTRIBUTING.md) to learn how to do
contributions to Harbor.
3. Refer the existing adapter implementations under `src/replication/adapter` package to implement yours.
4. Raise code PR(Pull Request) to the harbor main repository from your branch of forked repository and wait for review
after code is completed(NOTES: After we have this verification testing framework, each new contributing replication adapter
should provide the related verification testing cases before PR merging).

## 2. Verification testing case development

1. Clone this repository to your environment (ubuntu 18.04 is verified)

You can only clone master branch in order to save some time for poor network bandwidth, as results branch may be quite large.

```shell script
mkdir replication-verification
cd replication-verification
git init
git remote add origin https://github.com/goharbor/replication-verification
git pull origin master
```

2. Create/copy a robot file and put it under the ./<branch>/cases folder (for a new adapter, branch is `master`).
3. Modify the robot file for your adapter implementation(As the case is well-structured, just need to change the related parameters):

**NOTES:** Content in `<>` are placeholders and should be replaced.

```shell script
*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from <ADAPTER-NAME> To Self
    @{target_images}=  Create List  <A-TESTING-IMAGE-ON-THE-ADAPTING-REGISTRY>  <ANOTHER-TESTING-IMAGE-ON-THE-ADAPTING-REGISTRY>
    Test Replication Of Pull Images   <ADAPTER-IDENTIFY>   <ADAPTER-NAME>    <ACCESS_KEY>   <ACCESS_SECRET>    {<NAMESPACE-IN-REGISTRY>}/{<A-TESTING-IMAGE-ON-THE-ADAPTING-REGISTRY>,<ANOTHER-TESTING-IMAGE-ON-THE-ADAPTING-REGISTRY>}    @{target_images}

Test Case - Replication Of Push Images to AWS-ECR Triggered By Event
    Test Replication Of Push Images By Event    <ADAPTER-IDENTIFY>   <ADAPTER-NAME>    <ACCESS_KEY>    <ACCESS_SECRET>    replication-ci

```
4. Setup a Harbor running environment with the new adapter enabled. 

5. Use the `localrun.sh` script to verify whether the new adapter implementation can be verified by the testing cases developed here:

```shell script
./localrun.sh <case name> <harbor IP> <registry_id:xxx> <registry_key:xxx> [true to show browser]
```

The first time run localrun.sh, it will install the dependency software for ubuntu 18.04. If you are using other OS, please install them manually.
The purpose of this step is to make sure both the code and testing cases are correctly implemented.

6. Run below script in current case folder to general a gif record named record.gif in results folder

```shell script
../../save-record.sh
```

## 3. Post actions

1. Attach the gif record generated at the step 4 of section 2 to the adapter code PR mentioned at step 4 of section 1
as a proof of the PR.
2. Provide the AK info that we can add to the github Secrets.
3. Change .github/workflows/main.yml#112 and your case to using the AK in secrets.
4. Raise PR to submit the testing cases for the new adapter to this repository for future regular executions.


**NOTES:** Testing cases PR will be merged only after the adapter code PR in harbor repo is merged.
