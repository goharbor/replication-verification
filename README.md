# results

| case \ version | master | 2.0.x | 1.10.x | 1.9.x |
| -------------- | :----: | :---: | :----: | :---: | 
| Dockerhub      | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-master-DockerHub.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-master-DockerHub.gif) | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-DockerHub.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-DockerHub.gif) | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-1.10.0-DockerHub.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-1.10.0-DockerHub.gif) | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-1.9.0-DockerHub.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-1.9.0-DockerHub.gif) |
| AwsECR         | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-master-AwsECR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-master-AwsECR.gif)       | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-AwsECR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-AwsECR.gif)       | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-1.10.0-AwsECR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-1.10.0-AwsECR.gif)       | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-1.9.0-AwsECR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-1.9.0-AwsECR.gif)       |
| GoogleGCR      | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-master-GoogleGCR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-master-GoogleGCR.gif) | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-GoogleGCR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-GoogleGCR.gif) | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-1.10.0-GoogleGCR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-1.10.0-GoogleGCR.gif) | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-1.9.0-GoogleGCR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-1.9.0-GoogleGCR.gif) |
| AzureACR       | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-master-AzureACR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-master-AzureACR.gif)   | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-AzureACR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-AzureACR.gif)   | 
| Gitlab         | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-master-Gitlab.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-master-Gitlab.gif)       | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-Gitlab.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-Gitlab.gif)       | 
| AliACR         | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-master-AliACR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-master-AliACR.gif)       | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-AliACR.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-AliACR.gif)       | 
| Harbor(2.x)    | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-master-Harbor.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-master-Harbor.gif)       | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-Harbor.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-2.0.0-Harbor.gif)       | 
| Quay           | [![status](https://github.com/bitsf/replication-verification/raw/results/results/st-master-Quay.svg)](https://github.com/bitsf/replication-verification/raw/results/results/st-master-Quay.gif)           |

## checkpoints
1. Create endpoint Successfully
1. Pull-based Successfully
1. Push-based successfully
1. Delete successfully

# trigger

## crontab schedule

- cron: '0 22 * * *'

## manually trigger github action

```bash
curl -u bitsf -XPOST https://api.github.com/repos/bitsf/replication-verification/dispatches -d '
{
  "event_type": "testing"
}'
```

## run locally

- install robotframework, reference cmd in main.yml
- run in cmd for harbor master/2.x version
python -u -m robot.run -v ip:$IP -v repo:${repo} -v tag:${case} -v ecr_ac_id:xxx -v ecr_ac_key:xxx AwsECR.robot
- run in RIDE
pip install robotframework-ride
