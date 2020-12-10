*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from TencentTCR To Self
    @{target_images}=  Create List  alpine
    Test Replication Of Pull Images   tencent-tcr   https://harbor-replication-verification.tencentcloudcr.com    ${tencent_tcr_id}    ${tencent_tcr_key}    pull-for-harbor/**    @{target_images}

Test Case - Replication Of Push Images to TencentTCR Triggered By Event
    Test Replication Of Push Images By Event    tencent-tcr   https://harbor-replication-verification.tencentcloudcr.com    ${tencent_tcr_id}    ${tencent_tcr_key}    push-from-harbor
