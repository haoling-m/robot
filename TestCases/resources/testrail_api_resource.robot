Documentation     A resource for handling requests to the Testrail API
Resource          properties.robot
Resource          navigation_resource.robot
Library           DateTime
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem

*** Variables ***
${API Server}   https://cavictestrail01.codanradio.com/index.php?
${API Path}     /api/v2
${API User}     trison.nguyen@codanradio.com
${API Key}      b3MB/eHDk7/FSiQZCwYe-BHuHyhbTp/F3TRtbktSq
${TestRunFile}    test_run_id
${TestCaseID}
${TestRunID}
#default value if test error occurs before the comment is set
${Comment}        Automation run error occurred

#Test statuses
${Status Passed}      1
${Status Blocked}     2
${Status Untested}    3
${Status Retest}      4
${Status Failed}      5

*** Keywords ***
### API setup and teardown ###
Set API Variables
    ${Comments List}=   Create List
    Set Suite Variable    ${Comments List}
    ${time start}=      Get Time    epoch
    Set Suite Variable   ${time start}
    ${TestRunFile Exists}=   Run Keyword And Return Status   Get File    ${TestRunFile}
    Run Keyword If    ${TestRunFile Exists}    Run Keywords
    ...       Set Test Run ID   AND
    ...       Set Test Case ID    AND
    ...       Set Suite Variable    ${API Endpoint}   /add_result_for_case/${TestRunID}/${TestCaseID}
              # temp result dump while no test run is open
    ...       ELSE    Set Suite Variable     ${API Endpoint}     /add_result/2850

Set Test Run ID
   ${TestRunID}=   Get File    ${TestRunFile}
   Set Suite Variable    ${TestRunID}

Set Test Case ID
    Log   ${SUITE NAME}
    Run Keyword If    '${SUITE NAME}'=='Cwid Invalid'               Set Suite Variable    ${TestCaseID}   3555
    ...    ELSE IF    '${SUITE NAME}'=='Cwid Valid'                 Set Suite Variable    ${TestCaseID}   3554
    ...    ELSE IF    '${SUITE NAME}'=='factoryReset valid'         Set Suite Variable    ${TestCaseID}   3560
    ...    ELSE IF    '${SUITE NAME}'=='fallbackRules valid'        Set Suite Variable    ${TestCaseID}   3576
    ...    ELSE IF    '${SUITE NAME}'=='Fsi Invalid'                Set Suite Variable    ${TestCaseID}   3562
    ...    ELSE IF    '${SUITE NAME}'=='Fsi Valid'                  Set Suite Variable    ${TestCaseID}   3561
    ...    ELSE IF    '${SUITE NAME}'=='globalSettings invalid'     Set Suite Variable    ${TestCaseID}   3553
    ...    ELSE IF    '${SUITE NAME}'=='globalSettings valid'       Set Suite Variable    ${TestCaseID}   3552
    ...    ELSE IF    '${SUITE NAME}'=='ipSettings valid'           Set Suite Variable    ${TestCaseID}   3563
    ...    ELSE IF    '${SUITE NAME}'=='ipSettings invalid'         Set Suite Variable    ${TestCaseID}   3564
    ...    ELSE IF    '${SUITE NAME}'=='Login Invalid'              Set Suite Variable    ${TestCaseID}   3566
    ...    ELSE IF    '${SUITE NAME}'=='Login Valid'                Set Suite Variable    ${TestCaseID}   3565
    ...    ELSE IF    '${SUITE NAME}'=='menuOptions valid'          Set Suite Variable    ${TestCaseID}   3575
    ...    ELSE IF    '${SUITE NAME}'=='radioChannel invalid'       Set Suite Variable    ${TestCaseID}   3557
    ...    ELSE IF    '${SUITE NAME}'=='radioChannel valid'         Set Suite Variable    ${TestCaseID}   3556
    ...    ELSE IF    '${SUITE NAME}'=='radioChannelAll invalid'    Set Suite Variable    ${TestCaseID}   3559
    ...    ELSE IF    '${SUITE NAME}'=='radioChannelAll valid'      Set Suite Variable    ${TestCaseID}   3558
    ...    ELSE IF    '${SUITE NAME}'=='radioChannelClone valid'    Set Suite Variable    ${TestCaseID}   3577
    ...    ELSE IF    '${SUITE NAME}'=='userAdd invalid'            Set Suite Variable    ${TestCaseID}   3568
    ...    ELSE IF    '${SUITE NAME}'=='userAdd valid'              Set Suite Variable    ${TestCaseID}   3567
    ...    ELSE IF    '${SUITE NAME}'=='userDelete valid'           Set Suite Variable    ${TestCaseID}   3569
    ...    ELSE IF    '${SUITE NAME}'=='userDeleteAll valid'        Set Suite Variable    ${TestCaseID}   3570
    ...    ELSE IF    '${SUITE NAME}'=='userEdit invalid'           Set Suite Variable    ${TestCaseID}   3572
    ...    ELSE IF    '${SUITE NAME}'=='userEdit valid'             Set Suite Variable    ${TestCaseID}   3571
    ...    ELSE IF    '${SUITE NAME}'=='userPassword invalid'       Set Suite Variable    ${TestCaseID}   3574
    ...    ELSE IF    '${SUITE NAME}'=='userPassword valid'         Set Suite Variable    ${TestCaseID}   3573

Teardown Test
    Run Keyword If Test Passed    Append To List    ${Comments List}    **Automated Test Passed:** ${Comment}\n\n
    Run Keyword If Test Failed    Append To List    ${Comments List}    ***--Automated Test Failed--:*** ${Comment}\n\n

Teardown Suite
   ${time end}=      Get Time    epoch
   ${time elapsed}=    Subtract Time From Time   ${time end}   ${time start}
   ${Final Comment}=   Catenate   @{Comments List}
   Run Keyword If Any Tests Failed    Post To Testrail    ${API Endpoint}   ${Status Failed}    ${Final Comment}    ${time elapsed}
   Run Keyword If All Tests Passed    Post To Testrail    ${API Endpoint}   ${Status Passed}    ${Final Comment}    ${time elapsed}
   Run Keyword Unless   '${SUITE NAME}'=='userAdd Valid' or '${SUITE NAME}'=='userDelete Valid' or '${SUITE NAME}'=='userPassword Valid' or '${SUITE NAME}'=='Login Invalid' or '${SUITE NAME}'=='Login Valid'
   ...    Discard Changes
   Log Out And Close Browser

Discard Changes
    ${AtLoginPage}=   Run Keyword And Return Status   Location Should Be    ${LOGIN URL}
    Run Keyword If    ${AtLoginPage}    Return From Keyword
    ${NoChangesExist}=    Get Element Attribute   ${deleteChanges}    disabled
    Run Keyword Unless    '${NoChangesExist}'=='true'
    ...       Run Keywords
    ...       Click Element   ${deleteChanges}    AND
    ...       Wait Visible Do Action    ${confirmDeleteChanges}   click   ${clickable}    AND
    ...       Sleep   2s    AND
    ...       Wait Until Keyword Succeeds   60s   10s   Element Should Not Contain   ${loadingSpinner}   Discarding Changes...

### API Requests ###
Post To Testrail
    [arguments]   ${API Endpoint}   ${Status ID}    ${Comment}    ${Time Elapsed}
    ${Header}=        Create Dictionary     Content-Type=application/json
    ${Auth}=          Create List           ${API User}    ${API Key}
    Create Session    codanTestRail         ${API Server}   headers=${Header}    auth=${Auth}   verify=True

    ${Time Int}=    Convert To Integer    ${Time Elapsed}
    ${data}=    Create Dictionary     status_id=${Status ID}   comment=${Comment}    elapsed=${Time Int}s

    ${Response}=    Post Request      codanTestRail   ${API Path}${API Endpoint}   data=${data}   headers=${Header}
    Should be Equal As Strings    ${response.status_code}   200
    Delete All Sessions

Get From Testrail
    [Arguments]   ${API Endpoint}
    ${Header}=                    Create Dictionary     Content-Type=application/json
    ${Auth}=                      Create List           trison.nguyen@codanradio.com    ${API Key}
    Create Session                codanTestRail         ${API Server}   headers=${Header}    auth=${Auth}   verify=True

    ${Response}=                  Get Request           codanTestRail   ${API Path}${API Endpoint}   headers=${Header}
    Should be Equal As Strings    ${Response.status_code}   200
    Delete All Sessions
    Return From Keyword           ${Response}
