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
Documentation  This resource contains keywords related to creating basic test cases
Resource  ../resources/Util.robot

*** Variables ***
${HARBOR_URL}  https://${ip}
${HARBOR_ADMIN}  admin
${HARBOR_PASSWORD}  Harbor12345
${SERVER}  ${ip}
${SERVER_URL}  https://${SERVER}
${SERVER_API_ENDPOINT}  ${SERVER_URL}/api
&{SERVER_CONFIG}  endpoint=${SERVER_API_ENDPOINT}  verify_ssl=False

*** Keywords ***
Test Replication Of Pull Images
    [Arguments]    ${provider}    ${endpoint}    ${username}    ${pwd}    ${project_name}    @{target_images}
    Init Chrome Driver
    ${d}=    Get Current Date    result_format=%m%s
    Sign In Harbor    ${HARBOR_URL}    ${HARBOR_ADMIN}    ${HARBOR_PASSWORD}
    Log To Console  Create Project
    Create An New Project    project${d}
    Switch To Registries
    Log To Console  Create endpoint
    Create A New Endpoint    ${provider}    e${d}    ${endpoint}    ${username}    ${pwd}    Y
    Record A Good Check    note=Create endpoint Successfully
    Switch To Replication Manage
    Log To Console  Create pull-based rule
    Create A Rule With Existing Endpoint    rule${d}    pull    ${project_name}    image    e${d}    project${d}
    Filter Replicatin Rule  rule${d}
    Select Rule And Replicate  rule${d}
    :FOR    ${item}    IN    @{target_images}
    \    Log To Console  Check image replicated to Project project${d} ${item}
    \    Image Should Be Replicated To Project  project${d}   ${item}  times=2
    Record A Good Check    note=Pull-based Successfully
    Close Browser

Test Replication Of Push Images By Event
    [Arguments]    ${provider}    ${endpoint}    ${username}    ${pwd}    ${target_namespace}    ${target_repo}=${repo}    ${target_tag}=${tag}    ${pull_deleted_success}=${true}
    Init Chrome Driver
    ${d}=    Get Current Date    result_format=%m%s
    Sign In Harbor    ${HARBOR_URL}    ${HARBOR_ADMIN}    ${HARBOR_PASSWORD}
    Log To Console  Create Project for push
    Create An New Project    project${d}_0
    Log To Console  Create Project for pull
    Create An New Project    project${d}_1
    Switch To Registries
    Log To Console  Create endpoint
    Create A New Endpoint    ${provider}    e${d}    ${endpoint}    ${username}    ${pwd}    Y
    Switch To Replication Manage
    Log To Console  Create push-based rule
    Create A Rule With Existing Endpoint    rule${d}_0    push    project${d}_0/*    image    e${d}    ${target_namespace}  mode=Event Based  del_remote=${true}
    Log To Console  Create pull-based rule
    Create A Rule With Existing Endpoint    rule${d}_1    pull    ${target_namespace}/${target_repo}    image    e${d}    project${d}_1    filter_tag=${target_tag}_${d}
    Log To Console  Pushing Image
    ${image_with_tag}=  Push Image With Tag  ${ip}  ${HARBOR_ADMIN}  ${HARBOR_PASSWORD}  project${d}_0  ${target_repo}  ${target_tag}_${d}  ${target_tag}
    Log To Console  Push Image ${image_with_tag}
    Sleep  30
    Log To Console  Check push-based rule
    Filter Replicatin Rule  rule${d}_0
    Select Rule  rule${d}_0
    Executions Result Count Should Be  Failed  event_based  0
    Executions Result Count Should Be  Succeeded  event_based  1
    Log To Console  manual replication check
    Filter Replicatin Rule  rule${d}_1
    Select Rule And Replicate  rule${d}_1
    Sleep  10
    Log To Console  Check pull-based rule
    Filter Replicatin Rule  rule${d}_1
    Select Rule  rule${d}_1
    Executions Result Count Should Be  Failed  manual  0
    Executions Result Count Should Be  Succeeded  manual  1
    Image Should Be Replicated To Project  project${d}_1  ${target_repo}  times=2
    Record A Good Check    note=Push-based successfully
    Log To Console  Delete Repo
    Go Into Project  project${d}_0
    Delete Repo  project${d}_0
    Sleep  30
    Log To Console  Check push-based rule for delete
    Switch To Replication Manage
    Filter Replicatin Rule  rule${d}_0
    Select Rule  rule${d}_0
    Executions Result Count Should Be  Failed  event_based  0
    Executions Result Count Should Be  Succeeded  event_based  2
    Log To Console  manual replication check for delete
    Filter Replicatin Rule  rule${d}_1
    Select Rule And Replicate  rule${d}_1
    Sleep  10
    Log To Console  Check pull-based rule for delete
    Filter Replicatin Rule  rule${d}_1
    Select Rule  rule${d}_1
    Run Keyword If    ${pull_deleted_success}==${true}   Executions Result Count Should Be  Failed  manual  0
    Run Keyword If    ${pull_deleted_success}==${true}   Executions Result Count Should Be  Succeeded  manual  2
    Run Keyword If    ${pull_deleted_success}!=${true}   Executions Result Count Should Be  Failed  manual  1
    Record A Good Check    note=Delete successfully
    Close Browser

Record A Good Check
    [Arguments]    ${note}=well done
    Log To Console  Record A Good Check:${note}
    Append To File   checkpoint.txt   good\n
