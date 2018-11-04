*** Settings ***
Documentation     Invalid Global Settings test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Refresh Page
Test Template     Edit Should Fail
Test Teardown     Teardown Test
Resource          ../resources/globalSettings_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***                    FIELD ID              FIELD VALUE                 TOOLTIP ID
Invalid Format 01 endpointName        ${endpointName}       ${invalidendpointName1}     ${EMPTY}
Invalid Format 02 endpointName        ${endpointName}       ${invalidendpointName2}     ${EMPTY}
Invalid Format 03 endpointName        ${endpointName}       ${invalidendpointName3}     ${EMPTY}
Invalid Format 04 endpointName        ${endpointName}       ${invalidendpointName4}     ${EMPTY}
Invalid Is High endpointName          ${endpointName}       ${25CharLimit}              ${endpointNameErrClass}

Invalid Format unitID                 ${unitID}             ${NumberOnlyWrong}          ${unitIDErr}
Invalid Space unitID                  ${unitID}             ${SPACE}                    ${unitIDErr}
Invalid Is Low unitID                 ${unitID}             ${unitIDLow}                ${unitIDErr}
Invalid Is High unitID                ${unitID}             ${unitIDHigh}               ${unitIDErr}

*** Keywords ***
Edit Should Fail
    [Arguments]   ${Field ID}   ${Field Value}    ${Tooltip ID}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${FIELD VALUE}
    Run Keyword If    "${Field ID}"=="${endpointName}"    Make Endpoint Name Editable
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Run Keyword If    "${Tooltip ID}"!="${EMPTY}"    Wait Until Element Is Visible   ${Tooltip ID}
    Run Keyword If    "${Tooltip ID}"=="${endpointNameErrClass}"    Wait Until Element Contains   ${endpointNameErrClass}   ${endpointNameErrClassText}
    Wait Visible Do Action     ${channelList}    Click    ${radioButton}
    Run Keyword If    "${Tooltip ID}"=="${endpointNameErrClass}"    Wait Until Element Is Visible   ${updateSuccessful}
    Sleep   2s
    Run Keyword If    "${Field ID}"=="${endpointName}"    Make Endpoint Name Editable
    ${newFieldPlaceholder}=    Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    Run Keyword If    "${newFieldPlaceholder}"=="${Field Value}"     Fail    Placeholder matches incorrect value
