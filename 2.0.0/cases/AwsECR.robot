*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from AWS-ECR To Self
    @{target_images}=  Create List  httpd  alpine
    Test Replication Of Pull Images   aws-ecr   us-east-2    ${ecr_ac_id}    ${ecr_ac_key}    a/{httpd,alpine}    @{target_images}

Test Case - Replication Of Push Images to AWS-ECR Triggered By Event
    Test Replication Of Push Images By Event    aws-ecr   us-east-2    ${ecr_ac_id}    ${ecr_ac_key}    replication-ci
