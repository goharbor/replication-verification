*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from Harbor To Self
    @{target_images}=  Create List  photon  alpine
    Test Replication Of Pull Images   harbor   https://cicd.harbor.vmwarecna.net    ${harbor_ac_id}    ${harbor_ac_key}    library/{photon,alpine}    @{target_images}

Test Case - Replication Of Push Images to Harbor Triggered By Event
    Test Replication Of Push Images By Event    harbor   https://cicd.harbor.vmwarecna.net    ${harbor_ac_id}    ${harbor_ac_key}    replication-ci
