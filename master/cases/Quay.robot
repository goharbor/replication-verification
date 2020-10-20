*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from Quay To Self
    @{target_images}=  Create List  photon  alpine
    Test Replication Of Pull Images   quay   https://quay.io    json_file    ${quay_ac_key}    bitsf/{photon,alpi*}    @{target_images}

Test Case - Replication Of Push Images to Harbor Triggered By Event
    Test Replication Of Push Images By Event    quay   https://quay.io    json_file    ${quay_ac_key}    bitsf
