*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from DockerHub To Self
    @{target_images}=  Create List  centos  mariadb
    Test Replication Of Pull Images   docker-hub   https://hub.docker.com/    ${dockerhub_ac_id}    ${dockerhub_ac_key}    danfengliu/{cent*,mariadb}   @{target_images}

Test Case - Replication Of Push Images to DockerHub Triggered By Event
    Test Replication Of Push Images By Event    docker-hub   https://hub.docker.com/    ${dockerhub_ac_id}    ${dockerhub_ac_key}    danfengliu
