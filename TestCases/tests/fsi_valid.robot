#TODO Re-add to testCasesList once FSI page is fixed
*** Settings ***
Documentation     Valid FSI test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To FSI Advanced
Test Template     Edit Should Pass
Test Teardown     Teardown Test
Resource          ../resources/fsi_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***              FIELD ID            FIELD VALUE
Valid At Min controlPort        ${controlPort}      ${portMin}
Valid At Max controlPort        ${controlPort}      ${portMax}

Valid At Min voicePort          ${voicePort}        ${portMin}
Valid At Max voicePort          ${voicePort}        ${portMax}

Valid At Min controlAttempt     ${controlAttempt}   ${controlAttemptMin}
Valid At Max controlAttempt     ${controlAttempt}   ${controlAttemptMax}

Valid At Min connLossLimit      ${connLossLimit}    ${connLossLimitMin}
Valid At Max connLossLimit      ${connLossLimit}    ${connLossLimitMax}

Valid At Min controlRetry       ${controlRetry}     ${controlRetryMin}
Valid At Max controlRetry       ${controlRetry}     ${controlRetryMax}

Valid At Min voterReport        ${voterReport}      ${voterReportMin}
Valid At Max voterReport        ${voterReport}      ${voterReportMax}

# Valid At Min voiceEoSTimeout    ${voiceEoSTimeout}    ${voiceEoSTimeoutMin}
# Valid At Max voiceEoSTimeout    ${voiceEoSTimeout}    ${voiceEoSTimeoutMax}

# Valid At Min voiceBuffer        ${voiceBuffer}      ${voiceBufferMin}
# Valid At Max voiceBuffer        ${voiceBuffer}      ${voiceBufferMax}

*** Keywords ***
Edit Should Pass
    [Arguments]   ${Field ID}   ${Field Value}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${FIELD VALUE}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Click Element            ${radioName}
    Wait Until Element Is Visible   ${success}
    Wait Until Element Contains     ${success}    ${successMsg}
    Wait Until Element Does Not Contain     ${success}    ${successMsg}
    ${newFieldPlaceholder}=   Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    Run Keyword If    "${newFieldPlaceholder}"!="${Field Value}"     Fail    Placeholder doesn't match correct value
