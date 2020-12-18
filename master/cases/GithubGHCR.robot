*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from GithubGHCR To Self
    @{target_images}=  Create List  alpine
    Test Replication Of Pull Images   github-ghcr   https://ghcr.io    ${github_ghcr_id}    ${github_ghcr_key}    bitsf/pull/alpine    @{target_images}

Test Case - Replication Of Push Images to GithubGHCR Triggered By Event
    Test Replication Of Push Images By Event    github-ghcr   https://ghcr.io    ${github_ghcr_id}    ${github_ghcr_key}    bitsf/push
