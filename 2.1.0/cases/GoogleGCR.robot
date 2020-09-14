*** Settings ***
Resource  ./BaseCase.robot

*** Test Cases ***
Test Case - Replication Of Pull Images from Google-GCR To Self
    @{target_images}=  Create List  httpd  tomcat
    Test Replication Of Pull Images   google-gcr   asia.gcr.io    ${null}    ${gcr_ac_key}    eminent-nation-87317/{httpd,tomcat}    @{target_images}

Test Case - Replication Of Push Images to Google-GCR Triggered By Event
    Test Replication Of Push Images By Event    google-gcr    gcr.io    ${null}    ${gcr_ac_key}    eminent-nation-87317/replication-ci
