# Replication-Verification

Replication is a fancy feature of [Harbor](https://github.com/goharbor/harbor) registry. With the adapter framework, Harbor
has supported replicating artifacts(container images, Helm Charts) between Harbor<->Harbor or Harbor<->other 3rd registry services,
including Dockerhub, AWS ECR, Google GCR, Azure ACR, GitLab Registry, Ali ACR and Quay etc. with both pull and push modes. 
This repository is created to keep and regularly run the related compatibility testing cases that are used to verify 
whether the related replication adapters are still working well in Harbor or not and check if the newly contributed adapter
is implemented properly. Based on the compatibility testing, a daily well-organized report will be updated in time for the
community to refer.


## Report

| case \ version | master | 2.0.x | 1.10.x | 1.9.x |
| -------------- | :----: | :---: | :----: | :---: | 
| Dockerhub      | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-master-DockerHub.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-master-DockerHub.gif) | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-DockerHub.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-DockerHub.gif) | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-1.10.0-DockerHub.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-1.10.0-DockerHub.gif) | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-1.9.0-DockerHub.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-1.9.0-DockerHub.gif) |
| AwsECR         | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-master-AwsECR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-master-AwsECR.gif)       | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-AwsECR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-AwsECR.gif)       | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-1.10.0-AwsECR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-1.10.0-AwsECR.gif)       | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-1.9.0-AwsECR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-1.9.0-AwsECR.gif)       |
| GoogleGCR      | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-master-GoogleGCR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-master-GoogleGCR.gif) | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-GoogleGCR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-GoogleGCR.gif) | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-1.10.0-GoogleGCR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-1.10.0-GoogleGCR.gif) | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-1.9.0-GoogleGCR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-1.9.0-GoogleGCR.gif) |
| AzureACR       | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-master-AzureACR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-master-AzureACR.gif)   | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-AzureACR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-AzureACR.gif)   | 
| Gitlab         | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-master-Gitlab.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-master-Gitlab.gif)       | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-Gitlab.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-Gitlab.gif)       | 
| AliACR         | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-master-AliACR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-master-AliACR.gif)       | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-AliACR.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-AliACR.gif)       | 
| Harbor(2.x)    | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-master-Harbor.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-master-Harbor.gif)       | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-Harbor.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-2.0.0-Harbor.gif)       | 
| Quay           | [![status](https://github.com/goharbor/replication-verification/raw/results/results/st-master-Quay.svg)](https://github.com/goharbor/replication-verification/raw/results/results/st-master-Quay.gif)           |

**NOTES:** Each square represent an executing result of the relevant compatibility testing case. From left to right, they are:

 * Registry endpoint creation case
 * Pull-based replication case
 * Push-based replication case
 * Deletion replication case

Green color means case execution is successful and red color means case execution is failed.

## Triggers

### crontab schedule

Run daily at UTC time `22:00`.

> cron: '0 22 * * *'

### manually trigger github action

Issue HTTP request to run.

```bash
curl -u goharbor -XPOST https://api.github.com/repos/goharbor/replication-verification/dispatches -d '
{
  "event_type": "testing"
}'
```

### run locally

Use local script to run.

Clone this repository first:

```shell script
git clone https://github.com/goharbor/replication-verification.git
```
Execute the script with proper parameters:

```shell script
./localrun.sh --
```

## Contribute new replication adapter

If you're planning to contribute a new replication adapter, please follow the [contributing guide](./CONTRIBUTING.md) to start.

## Contact us

Use the ways shown [here](https://github.com/goharbor/harbor#community) to get contact with us if you encounter any issues related to replication adapter contributions.