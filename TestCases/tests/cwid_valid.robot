*** Settings ***
Documentation     Valid CWID test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To CWID
Test Template     Edit Should Pass
Test Teardown     Teardown Test
Resource          ../resources/cwid_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***              FIELD ID          FIELD VALUE
Valid At Min Interval           ${interval}       ${intervalMin}
Valid At Max Interval           ${interval}       ${intervalMax}

Valid At Max WPM                ${wpm}            ${wpmMax}
Valid At Min WPM                ${wpm}            ${wpmMin}

Valid At Min transmitString1    ${transmit1}      ${transmitMin}
Valid At Max transmitString1    ${transmit1}      ${transmitMax}

#Valid At Min transmitString2    ${transmit2}      ${transmitMin}
#Valid At Max transmitString2    ${transmit2}      ${transmitMax}

#Valid At Min transmitString3    ${transmit3}      ${transmitMin}
#Valid At Max transmitString3    ${transmit3}      ${transmitMax}

#Valid At Min transmitString4    ${transmit4}      ${transmitMin}
#Valid At Max transmitString4    ${transmit4}      ${transmitMax}

#Valid At Min transmitString5    ${transmit5}      ${transmitMin}
#Valid At Max transmitString5    ${transmit5}      ${transmitMax}

#Valid At Min transmitString6    ${transmit6}      ${transmitMin}
#Valid At Max transmitString6    ${transmit6}      ${transmitMax}

#Valid At Min transmitString7    ${transmit7}      ${transmitMin}
#Valid At Max transmitString7    ${transmit7}      ${transmitMax}

#Valid At Min transmitString8    ${transmit8}      ${transmitMin}
#Valid At Max transmitString8    ${transmit8}      ${transmitMax}

#Valid Clear transmitString8     ${EMPTY}          ${transmit8Clr}
#Valid Clear transmitString7     ${transmit8}      ${transmit7Clr}
#Valid Clear transmitString6     ${transmit7}      ${transmit6Clr}
#Valid Clear transmitString5     ${transmit6}      ${transmit5Clr}
#Valid Clear transmitString4     ${transmit5}      ${transmit4Clr}
#Valid Clear transmitString3     ${transmit4}      ${transmit3Clr}
#Valid Clear transmitString2     ${transmit3}      ${transmit2Clr}

Valid At Min toneFreq           ${freq}           ${freqMin}
Valid At Max toneFreq           ${freq}           ${freqMax}

Valid At Min toneLevel          ${level}          ${levelMin}
Valid At Max toneLevel          ${level}          ${levelMax}

Valid List cwidEnabled          ${cwidEnabled}    ${cwidEnabledList}
Valid List cwidMode             ${cwidMode}       ${cwidModeList}
Valid List interrupt            ${interrupt}      ${interruptList}

*** Keywords ***
Edit Should Pass
    [Arguments]   ${Field ID}   ${Field Value}
    ${passed}=    Run Keyword And Return Status   Evaluate    type(${Field Value})
    ${type}=      Run Keyword If     ${passed}    Evaluate    type(${Field Value})
    ${clearTest}=   Evaluate    """${transmitClear}""" in """${TEST NAME}"""
    Run Keyword If    "${type}"=="${listFlag}" or "${type}"=="${typeListFlag}"    Test Dropdown   ${Field ID}   ${Field Value}
    ...    ELSE IF    ${clearTest}    Clear Transmit String   ${fieldID}    ${fieldValue}
    ...       ELSE    Test Input    ${Field ID}   ${Field Value}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${Field Value}

Test Dropdown
    [Arguments]   ${Field ID}   @{Field Value}
    ${Found Values}=   Get List Items    ${Field ID}
    Lists Should Be Equal    ${Found Values}    @{Field Value}
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
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Wait Visible Do Action     ${cwidLink}    Click    ${radioButton}
    Wait Until Element Is Visible   ${updateSuccessful}
    Wait Until Element Contains     ${updateSuccessful}    ${updateSuccessfulMsg}
    ${newFieldPlaceholder}=   Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    Run Keyword If    "${newFieldPlaceholder}"!="${Field Value}"     Fail    Placeholder doesn't match correct value

Clear Transmit String
    [Arguments]   ${Field ID}   ${Field Value}
    Run Keyword If    "${Field ID}"!="${EMPTY}"   Wait Until Element Is Visible   ${Field ID}
    Wait Until Element Is Visible   ${Field Value}
    Wait Visible Do Action  ${Field Value}    click   ${clickable}
    Wait Until Element Is Visible   ${updateSuccessful}
    Wait Until Element Contains     ${updateSuccessful}    ${updateSuccessfulMsg}
    Wait Until Element Is Not Visible   ${Field Value}
    Run Keyword If    "${Field ID}"!="${EMPTY}"   Wait Until Element Is Not Visible   ${Field ID}
