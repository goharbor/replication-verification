*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from Quay To Self
    @{target_images}=  Create List  photon  alpine
    Test Replication Of Pull Images   quay   https://harbor.35.166.150.163.xip.io:32701    json_file    '{"account_name":"bitsf","docker_cli_password":"UK6ym0zIK9GxxROWReTjWqCc/A5JehxLeHARjj8NK1vgn9mxTzd9hJ4SM1JSZPFn"}'    bitsf/{photon,alpine}    @{target_images}

Test Case - Replication Of Push Images to Harbor Triggered By Event
    Test Replication Of Push Images By Event    quay   https://harbor.35.166.150.163.xip.io:32701    json_file    '{"account_name":"bitsf","docker_cli_password":"UK6ym0zIK9GxxROWReTjWqCc/A5JehxLeHARjj8NK1vgn9mxTzd9hJ4SM1JSZPFn"}'    bitsf
