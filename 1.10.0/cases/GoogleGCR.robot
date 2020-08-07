*** Settings ***
Documentation  Harbor BATs
#Library  ../../apitests/python/library/Harbor.py  ${SERVER_CONFIG}
Resource  ../resources/Util.robot
Default Tags  Replication

*** Variables ***
${HARBOR_URL}  http://${ip}
${SSH_USER}  root
${HARBOR_ADMIN}  admin
${HARBOR_PASSWORD}  Harbor12345
${SERVER}  ${ip}
${SERVER_URL}  https://${SERVER}
${SERVER_API_ENDPOINT}  ${SERVER_URL}/api
&{SERVER_CONFIG}  endpoint=${SERVER_API_ENDPOINT}  verify_ssl=False

*** Test Cases ***
Test Case - Replication Of Pull Images from Google-GCR To Self
    Init Chrome Driver
    ${d}=    Get Current Date    result_format=%m%s
    #login source
    Sign In Harbor    ${HARBOR_URL}    ${HARBOR_ADMIN}    ${HARBOR_PASSWORD}
    Create An New Project    project${d}
    Switch To Registries
    Create A New Endpoint    google-gcr    e${d}    asia.gcr.io    ${null}    ${gcr_ac_key}    Y
    Switch To Replication Manage
    Create A Rule With Existing Endpoint    rule${d}    pull    eminent-nation-87317/*    image    e${d}    project${d}
    Filter Replicatin Rule  rule${d}
    Select Rule And Replicate  rule${d}
    Image Should Be Replicated To Project  project${d}  httpd
    Image Should Be Replicated To Project  project${d}  tomcat
    Close Browser
