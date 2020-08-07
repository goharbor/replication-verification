*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from Gitlab To Self
    @{target_images}=  Create List  photon  alpine
    Test Replication Of Pull Images   gitlab   https://registry.gitlab.com    ${gitlab_id}    ${gitlab_key}    bitsf/testci/ci/{photon,alpine}    @{target_images}

Test Case - Replication Of Push Images to Gitlab Triggered By Event
    Test Replication Of Push Images By Event    gitlab   https://registry.gitlab.com    ${gitlab_id}    ${gitlab_key}    bitsf/testci/replication-ci
