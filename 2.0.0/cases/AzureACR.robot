*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from AZURE-ACR To Self
    @{target_images}=  Create List  busybox
    Test Replication Of Pull Images   azure-acr   https://testharbor.azurecr.io    ${azure_ac_id}    ${azure_ac_key}    library/*    @{target_images}

Test Case - Replication Of Push Images to AZURE-ACR Triggered By Event
    Test Replication Of Push Images By Event    azure-acr   https://testharbor.azurecr.io    ${azure_ac_id}    ${azure_ac_key}    replication-ci    pull_deleted_success=${false}
