*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from GithubGCR To Self
    @{target_images}=  Create List  alpine
    Test Replication Of Pull Images   github-gcr   https://ghcr.io    ${github_gcr_id}    ${github_gcr_key}    bitsf/pull/alpine    @{target_images}

Test Case - Replication Of Push Images to GithubGCR Triggered By Event
    Test Replication Of Push Images By Event    github-gcr   https://ghcr.io    ${github_gcr_id}    ${github_gcr_key}    bitsf/push
