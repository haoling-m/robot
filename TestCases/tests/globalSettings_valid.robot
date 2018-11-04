*** Settings ***
Documentation     Valid Global Settings test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Refresh Page
Test Template     Edit Should Pass
Test Teardown     Teardown Test
Resource          ../resources/globalSettings_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           String
Library           Collections

*** Test Cases ***                FIELD ID                  FIELD VALUE
Valid At Min endpointName         ${endpointName}           ${endpointNameMin}
Valid At Max endpointName         ${endpointName}           ${endpointNameMax}

Valid At Min unitID               ${unitID}                 ${unitIDMin}
Valid At Max unitID               ${unitID}                 ${unitIDMax}

Valid List defaultActiveChannel   ${defaultActiveChannel}   ${dropdownTest}
Valid List fallbackChannel        ${fallbackChannel}        ${dropdownTest}

*** Keywords ***
Edit Should Pass
    [Arguments]   ${Field ID}   ${Field Value}
    Run Keyword If    "${Field Value}"=="${dropdownTest}"    Test Dropdown   ${Field ID}
    ...       ELSE    Test Input    ${Field ID}   ${Field Value}

Test Dropdown
    [Arguments]   ${Field ID}
    ${Found Values}=   Get List Items    ${Field ID}
    Set Test Variable   ${Comment}    ${TEST NAME} dropdown should accept values @{Found Values}
    ${foundValuesLength}=   Get Length    ${Found Values}
    ${Generated Values}=    Generate Channel List   ${foundValuesLength}
    Lists Should Be Equal    ${Found Values}    ${Generated Values}
    ${Selected}=    Get Selected List Label   ${Field ID}
    #Remove the currently selected value, check other values first,
    #so there is actually a change to check successful updates with
    Remove Values From List    ${Found Values}    ${Selected}
    :FOR    ${Item}    IN    @{Found Values}
    \   Click Element   ${Field ID}
    \   ${ItemStr}=   Convert To String   ${Item}
    \   Select From List   ${Field ID}  ${ItemStr}
    \   Wait Until Element Is Visible   ${updateSuccessful}
    \   Wait Until Element Contains     ${updateSuccessful}    ${updateSuccessfulMsg}
    \   ${newValue}=    Get Selected List Label   ${Field ID}
    \   Run Keyword If    "${newValue}"!="${ItemStr}"     Fail    Dropdown value doesn't match correct value
    Click Element   ${Field ID}
    #Check the initial selected value
    Select From List    ${Field ID}   ${Selected}
    Wait Until Element Is Visible   ${updateSuccessful}
    Wait Until Element Contains     ${updateSuccessful}    ${updateSuccessfulMsg}
    ${newValue}=    Get Selected List Label   ${Field ID}
    Run Keyword If    "${newValue}"!="${Selected}"     Fail    Dropdown value doesn't match correct value

Test Input
    [Arguments]   ${Field ID}   ${Field Value}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${FIELD VALUE}
    Run Keyword If    "${Field ID}"=="${endpointName}"    Make Endpoint Name Editable
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Wait Visible Do Action     ${channelList}    Click    ${radioButton}
    Wait Until Element Is Visible   ${updateSuccessful}
    Wait Until Element Contains     ${updateSuccessful}    ${updateSuccessfulMsg}
    Run Keyword If    "${Field ID}"=="${endpointName}"    Make Endpoint Name Editable
    ${newFieldPlaceholder}=    Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    ${newFieldPlaceholder}=   Remove String   ${newFieldPlaceholder}    $
    Run Keyword If    "${newFieldPlaceholder}"!="${Field Value}"     Fail    Placeholder matches incorrect value

Generate Channel List
    [Arguments]   ${channelLength}
    @{rChannelList}=    Create List
    :FOR    ${channelNumber}   IN RANGE    1    ${channelLength} + 1
    \   ${strChannelNumber}=    Convert To String   ${channelNumber}
    \   Append To List    ${rChannelList}   ${strChannelNumber}
    [Return]      ${rChannelList}
