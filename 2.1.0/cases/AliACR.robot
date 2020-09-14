*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from AliACR To Self
    @{target_images}=  Create List  photon  alpine
    Test Replication Of Pull Images   ali-acr   https://registry.us-west-1.aliyuncs.com    ${ali_ac_id}    ${ali_ac_key}    bitsf/{photon,alpin*}    @{target_images}

Test Case - Replication Of Push Images to AliACR Triggered By Event
    Test Replication Of Push Images By Event    ali-acr   https://registry.us-west-1.aliyuncs.com    ${ali_ac_id}    ${ali_ac_key}    bitsf
