// Copyright Project Harbor Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
Test Case - Get Harbor Version
#Just get harbor version and log it
    Get Harbor Version

Test Case - Replication Of Pull Images from DockerHub To Self
    Init Chrome Driver
    ${d}=    Get Current Date    result_format=%m%s
    #login source
    Sign In Harbor    ${HARBOR_URL}    ${HARBOR_ADMIN}    ${HARBOR_PASSWORD}
    Create An New Project    project${d}
    Switch To Registries
    Create A New Endpoint    docker-hub    e${d}    https://hub.docker.com/    danfengliu    Aa123456    Y
    Switch To Replication Manage
    Create A Rule With Existing Endpoint    rule${d}    pull    danfengliu/*    image    e${d}    project${d}
    Select Rule And Replicate  rule${d}
    Sleep    30
    Go Into Project    project${d}
    Switch To Project Repo
    #In docker-hub, under repository danfengliu, there're only 2 images: centos,mariadb.
    Retry Wait Until Page Contains    project${d}/centos
    Go Into Project    project${d}
    Switch To Project Repo
    Retry Wait Until Page Contains    project${d}/mariadb
    Close Browser
