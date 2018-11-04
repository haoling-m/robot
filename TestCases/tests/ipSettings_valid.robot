*** Settings ***
Documentation     Valid IP Settings test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Editable IP Settings
Test Teardown     Teardown Test
Resource          ../resources/ipSettings_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           Collections
Library           String

*** Test Cases ***
Check Netmask Options
    ${foundValues}=   Get List Items    ${netmask}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${foundValues} should be equal to ${netMaskOptions}
    Lists Should Be Equal    ${foundValues}    ${netMaskOptions}

Change IP Settings
    Wait Visible Do Action   ${ipAddress}   ${SERVERALT}   ${textBox}
    ${enteredGateway}=      Wait Visible Get Attribute  ${gateway}  ${placeholderFlag}
    ${enteredNTP1}=         Confirm New Value And Overwrite     ${ntp1}
    ${enteredNTP2}=         Confirm New Value And Overwrite     ${ntp2}
    Wait Visible Do Action  ${confirmIP}    clickable   ${clickable}
    Wait For IP Change To Complete And Login    ${LOGIN URL ALT}
    Confirm Network Settings Were Changed   ${SERVERALT}    ${enteredGateway}    ${enteredNTP1}     ${enteredNTP2}
    Wait Visible Do Action   ${ipAddress}   ${SERVER}   ${textBox}
    ${enteredGateway}=      Wait Visible Get Attribute  ${gateway}  ${placeholderFlag}
    ${enteredNTP1}=         Confirm New Value And Overwrite     ${ntp1}
    ${enteredNTP2}=         Confirm New Value And Overwrite     ${ntp2}
    Set Test Variable   ${Comment}    ${TEST NAME} - Server: ${SERVER}, Gateway: ${enteredGateway}, NTP1: ${enteredNTP1}, NTP2: ${enteredNTP2}
    Wait Visible Do Action  ${confirmIP}    clickable   ${clickable}
    Wait For IP Change To Complete And Login    ${LOGIN URL}
    Confirm Network Settings Were Changed   ${SERVER}    ${enteredGateway}    ${enteredNTP1}     ${enteredNTP2}

*** Keywords ***
Confirm New Value And Overwrite
    [Arguments]     ${fieldID}
    ${oldValue}=    Gather Old Value From Field     ${fieldID}
    ${newValue}=    Generate Random Unique IP  ${oldValue}
    Wait Visible Do Action   ${fieldID}   ${newValue}   ${textBox}
    [Return]    ${newValue}

Generate Random Unique IP
    [Arguments]     ${oldValue}
    @{numbers}=    Evaluate    random.sample(range(1, 240), 4)    random
    ${generatedIP}=     Catenate    SEPARATOR=.     @{numbers}
    ${modifiedIP}=      Replace First Octet  ${generatedIP}
    ${returnIP}=     Set Variable if     '${generatedIP}'=='${oldValue}'    ${modifiedIP}   ${generatedIP}
    [Return]   ${returnIP}

Replace First Octet
    [Arguments]     ${generatedIP}
    ${firstOctet}=  Fetch From Left     ${generatedIP}  .
    ${modifiedIP}=  Replace String      ${generatedIP}  ${firstOctet}   245     count=1
    [Return]    ${modifiedIP}

Gather Old Value From Field
    [Arguments]     ${fieldID}
    ${oldValue}=    Wait Visible Get Attribute  ${fieldID}  ${placeholderFlag}
    ${oldValue}=    Fetch From Left     ${oldValue}     To
    [Return]        ${oldValue.strip()}

Wait For IP Change To Complete And Login
    [Arguments]     ${newIP}
    Login Page Should Be Open   2m      addressCheck=False
    Sleep   5s
    Close Browser
    Sleep   5s
    Open Browser To Login Page  ${newIP}
    Reload Page
    Login Default User With Validation
    Navigate To Editable IP Settings

Confirm Network Settings Were Changed
    [Arguments]     ${enteredIP}    ${enteredGateway}    ${enteredNTP1}     ${enteredNTP2}
    Confirm Network Setting Was Changed     ${enteredIP}    ${ipAddress}
    Confirm Network Setting Was Changed     ${enteredGateway}    ${gateway}
    Confirm Network Setting Was Changed     ${enteredNTP1}    ${ntp1}
    Confirm Network Setting Was Changed     ${enteredNTP2}    ${ntp2}

Confirm Network Setting Was Changed
    [Arguments]     ${enteredValue}    ${fieldID}
    ${currentValue}=      Gather Old Value From Field     ${fieldID}
    Run Keyword If      '${enteredValue}'!='${currentValue}'         Fail    IP Addresses does not match '${enteredValue}'!='${currentValue}'
