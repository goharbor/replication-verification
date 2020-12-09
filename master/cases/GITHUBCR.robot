*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from Github Container Registry To Self
    @{target_images}=  Create List  alpine
    Test Replication Of Pull Images   github-ghcr   https://ghcr.io    ${id}    ${token}    goharbor-ghcr-verification/pull/alpine    @{target_images}

Test Case - Replication Of Push Images to Github Container Registry Triggered By Event
    Test Replication Of Push Images By Event    github-ghcr   http://119.28.68.176    ${id}    ${token}    goharbor-ghcr-verification/push
