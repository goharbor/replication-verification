*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from TCR To Self
    @{target_images}=  Create List  alpine
    Test Replication Of Pull Images   tcr   https://harbor-replication-verification.tencentcloudcr.com    ${tcr_id}    ${tcr_key}    pull-for-harbor/**    @{target_images}

Test Case - Replication Of Push Images to TCR Triggered By Event
    Test Replication Of Push Images By Event    tcr   https://harbor-replication-verification.tencentcloudcr.com    ${tcr_id}    ${tcr_key}    push-from-harbor
