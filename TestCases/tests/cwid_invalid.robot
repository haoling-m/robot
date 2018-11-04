*** Settings ***
Documentation     Invalid CWID test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To CWID
Test Template     Edit Should Fail
Test Teardown     Teardown Test
Resource          ../resources/cwid_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***                FIELD ID        FIELD VALUE             TOOLTIP ID
Invalid Format Interval           ${interval}     ${NumberOnlyWrong}      ${intervalErr}
Invalid Space Interval            ${interval}     ${SPACE}                ${intervalErr}
Invalid Is Low Interval           ${interval}     ${intervalLow}          ${intervalErr}
Invalid Is High Interval          ${interval}     ${intervalHigh}         ${intervalErr}
# This field rounds decimal values to whole numbers to become valid
# Invalid Step Interval             ${interval}     ${intervalStep}         ${intervalErr}

Invalid Format WPM                ${wpm}          ${NumberOnlyWrong}      ${wpmErr}
Invalid Space WPM                 ${wpm}          ${SPACE}                ${wpmErr}
Invalid Is Low WPM                ${wpm}          ${wpmLow}               ${wpmErr}
Invalid Is High WPM               ${wpm}          ${wpmHigh}              ${wpmErr}
Invalid Step WPM                  ${wpm}          ${wpmStep}              ${wpmErr}

Invalid Format transmitString     ${transmit1}     ${AlphanumericWrong}    ${transmitErr}
Invalid Is High transmitString1   ${transmit1}     ${transmitHigh}         ${transmitErrClass}
#Invalid Is High transmitString2   ${transmit2}     ${transmitHigh}         ${transmitErrClass}
#Invalid Is High transmitString3   ${transmit3}     ${transmitHigh}         ${transmitErrClass}
#Invalid Is High transmitString4   ${transmit4}     ${transmitHigh}         ${transmitErrClass}
#Invalid Is High transmitString5   ${transmit5}     ${transmitHigh}         ${transmitErrClass}
#Invalid Is High transmitString6   ${transmit6}     ${transmitHigh}         ${transmitErrClass}
#Invalid Is High transmitString7   ${transmit7}     ${transmitHigh}         ${transmitErrClass}
#Invalid Is High transmitString8   ${transmit8}     ${transmitHigh}         ${transmitErrClass}

Invalid Format toneFreq           ${freq}         ${NumberOnlyWrong}      ${freqErr}
Invalid Space toneFreq            ${freq}         ${SPACE}                ${freqErr}
Invalid Is Low toneFreq           ${freq}         ${freqLow}              ${freqErr}
Invalid Is High toneFreq          ${freq}         ${freqHigh}             ${freqErr}
Invalid Step toneFreq             ${freq}         ${freqStep}             ${freqErr}

Invalid Format toneLevel          ${level}        ${NumberOnlyWrong}      ${levelErr}
Invalid Space toneLevel           ${level}        ${SPACE}                ${levelErr}
Invalid Is Low toneLevel          ${level}        ${levelLow}             ${levelErr}
Invalid Is High toneLevel         ${level}        ${levelHigh}            ${levelErr}
Invalid Step toneLevel            ${level}        ${levelStep}            ${levelErr}

*** Keywords ***
Edit Should Fail
    [Arguments]   ${Field ID}   ${Field Value}    ${Tooltip ID}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${Field Value}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Wait Until Element Is Visible   ${Tooltip ID}
    Run Keyword If    "${Tooltip ID}"=="${transmitErrClass}"    Wait Until Element Contains   ${transmitErrClass}   ${transmitErrClassText}
    Wait Visible Do Action     ${cwidLink}    Click    ${radioButton}
    Run Keyword If    "${Tooltip ID}"=="${transmitErrClass}"    Wait Until Element Is Visible   ${updateSuccessful}
    Sleep   2s
    ${newFieldPlaceholder}=    Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    Run Keyword If    "${newFieldPlaceholder}"=="${Field Value}"     Fail    Placeholder matches incorrect value
