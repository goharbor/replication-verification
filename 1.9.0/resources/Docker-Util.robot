# Copyright Project Harbor Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

*** Settings ***
Documentation  This resource provides helper functions for docker operations
Library  OperatingSystem
Library  Process

*** Keywords ***
Run Docker Info
    [Arguments]  ${docker-params}
    Wait Unitl Command Success  docker ${docker-params} info

Pull image
    [Arguments]  ${ip}  ${user}  ${pwd}  ${project}  ${image}  ${tag}=${null}
    Log To Console  \nRunning docker pull ${image}...
    ${image_with_tag}=  Set Variable If  '${tag}'=='${null}'  ${image}  ${image}:${tag}
    Wait Unitl Command Success  docker login -u ${user} -p ${pwd} ${ip}
    ${output}=  Wait Unitl Command Success  docker pull ${ip}/${project}/${image_with_tag}
    Should Contain  ${output}  Digest:
    Should Contain  ${output}  Status:
    Should Not Contain  ${output}  No such image:

Push image
    [Arguments]  ${ip}  ${user}  ${pwd}  ${project}  ${image}  ${sha256}=${null}
    ${image_with_sha256}=  Set Variable If  '${sha256}'=='${null}'  ${image}  ${image}@sha256:${sha256}
    ${image_with_tag}=  Set Variable If  '${sha256}'=='${null}'  ${image}  ${image}:${sha256}
    Log To Console  \nRunning docker push ${image}...
    Wait Unitl Command Success  docker pull ${image_with_sha256}
    Wait Unitl Command Success  docker login -u ${user} -p ${pwd} ${ip}
    Wait Unitl Command Success  docker tag ${image_with_sha256} ${ip}/${project}/${image_with_tag}
    Wait Unitl Command Success  docker push ${ip}/${project}/${image_with_tag}
    Wait Unitl Command Success  docker logout ${ip}
    Sleep  1

Push Image With Tag
#tag1 is tag of image on docker hub,default latest,use a version existing if you do not want to use latest
    [Arguments]  ${ip}  ${user}  ${pwd}  ${project}  ${image}  ${tag}  ${tag1}=latest
    Log To Console  \nRunning docker push ${image}...
    Wait Unitl Command Success  docker pull ${image}:${tag1}
    Wait Unitl Command Success  docker login -u ${user} -p ${pwd} ${ip}
    Wait Unitl Command Success  docker tag ${image}:${tag1} ${ip}/${project}/${image}:${tag}
    Wait Unitl Command Success  docker push ${ip}/${project}/${image}:${tag}
    Wait Unitl Command Success  docker logout ${ip}

Cannot Docker Login Harbor
    [Arguments]  ${ip}  ${user}  ${pwd}
    Command Should be Failed  docker login -u ${user} -p ${pwd} ${ip}

Cannot Pull image
    [Arguments]  ${ip}  ${user}  ${pwd}  ${project}  ${image}  ${tag}=${null}
    ${image_with_tag}=  Set Variable If  '${tag}'=='${null}'  ${image}  ${image}:${tag}
    Wait Unitl Command Success  docker login -u ${user} -p ${pwd} ${ip}
    Command Should be Failed  docker pull ${ip}/${project}/${image_with_tag}

Cannot Pull Unsigned Image
    [Arguments]  ${ip}  ${user}  ${pass}  ${proj}  ${imagewithtag}
    Wait Unitl Command Success  docker login -u ${user} -p ${pass} ${ip}
    ${output}=  Command Should be Failed  docker pull ${ip}/${proj}/${imagewithtag}
    Should Contain  ${output}  The image is not signed in Notary

Cannot Push image
    [Arguments]  ${ip}  ${user}  ${pwd}  ${project}  ${image}  ${err_msg}=${null}
    Log To Console  \nRunning docker push ${image}...
    Wait Unitl Command Success  docker pull ${image}
    Wait Unitl Command Success  docker login -u ${user} -p ${pwd} ${ip}
    Wait Unitl Command Success  docker tag ${image} ${ip}/${project}/${image}
    ${output}=  Command Should be Failed  docker push ${ip}/${project}/${image}
    Run Keyword If  '${err_msg}' != '${null}'  Should Contain  ${output}  ${err_msg}
    Wait Unitl Command Success  docker logout ${ip}

Wait Until Container Stops
    [Arguments]  ${container}
    :FOR  ${idx}  IN RANGE  0  60
    \   ${out}=  Run  docker %{VCH-PARAMS} inspect ${container} | grep Status
    \   ${status}=  Run Keyword And Return Status  Should Contain  ${out}  exited
    \   Return From Keyword If  ${status}
    \   Sleep  1
    Fail  Container did not stop within 60 seconds

Hit Nginx Endpoint
    [Arguments]  ${vch-ip}  ${port}
    Wait Unitl Command Success  wget ${vch-ip}:${port}

Get Container IP
    [Arguments]  ${docker-params}  ${id}  ${network}=default  ${dockercmd}=docker
    ${ip}=  Wait Unitl Command Success  ${dockercmd} ${docker-params} network inspect ${network} | jq '.[0].Containers."${id}".IPv4Address' | cut -d \\" -f 2 | cut -d \\/ -f 1
    [Return]  ${ip}

# The local dind version is embedded in Dockerfile
# docker:1.13-dind
# If you are running this keyword in a container, make sure it is run with --privileged turned on
Start Docker Daemon Locally
    ${pid}=  Run  pidof dockerd
    Return From Keyword If  '${pid}' != '${EMPTY}'
    OperatingSystem.File Should Exist  /usr/local/bin/dockerd-entrypoint.sh
    ${handle}=  Start Process  /usr/local/bin/dockerd-entrypoint.sh dockerd>./daemon-local.log 2>&1  shell=True
    Process Should Be Running  ${handle}
    :FOR  ${IDX}  IN RANGE  5
    \   ${pid}=  Run  pidof dockerd
    \   Exit For Loop If  '${pid}' != '${EMPTY}'
    \   Sleep  2s
    Sleep  2s
    [Return]  ${handle}

Prepare Docker Cert
    [Arguments]  ${ip}
    Wait Unitl Command Success  mkdir -p /etc/docker/certs.d/${ip}
    Wait Unitl Command Success  cp harbor_ca.crt /etc/docker/certs.d/${ip}

Kill Local Docker Daemon
    [Arguments]  ${handle}  ${dockerd-pid}
    Terminate Process  ${handle}
    Process Should Be Stopped  ${handle}
    Wait Unitl Command Success  kill -9 ${dockerd-pid}

Docker Login Fail
    [Arguments]  ${ip}  ${user}  ${pwd}
    Log To Console  \nRunning docker login ${ip} ...
    ${output}=  Command Should be Failed  docker login -u ${user} -p ${pwd} ${ip}
    Should Contain  ${output}  unauthorized: authentication required
    Should Not Contain  ${output}  500 Internal Server Error

Docker Login
    [Arguments]  ${server}  ${username}  ${password}
    Wait Unitl Command Success  docker login -u ${username} -p ${password} ${server}

Docker Pull
    [Arguments]  ${image}
    Wait Unitl Command Success  docker pull ${image}

Docker Tag
    [Arguments]  ${src_image}   ${dst_image}
    Wait Unitl Command Success  docker tag ${src_image} ${dst_image}

Docker Push
    [Arguments]  ${image}
    Wait Unitl Command Success  docker push ${image}
