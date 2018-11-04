*** Settings ***
Documentation     Invalid FSI test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To FSI Advanced
Test Template     Edit Should Fail
Test Teardown     Teardown Test
Resource          ../resources/fsi_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***                FIELD ID            FIELD VALUE             TOOLTIP ID            TOOLTIP MSG
Invalid Format controlPort        ${controlPort}      ${NumberOnlyWrong}      ${controlPortErr}     ${portErrEven}
Invalid Space controlPort         ${controlPort}      ${SPACE}                ${controlPortErr}     ${portErrEven}
Invalid Is Low controlPort        ${controlPort}      ${portLow}              ${controlPortErr}     ${errRange}
Invalid Is High controlPort       ${controlPort}      ${portHigh}             ${controlPortErr}     ${errRange}
Invalid Is Odd controlPort        ${controlPort}      ${portOdd}              ${controlPortErr}     ${portErrEven}
Invalid Step controlPort          ${controlPort}      ${portStep}             ${controlPortErr}     ${portErrEven}

Invalid Format voicePort          ${voicePort}        ${NumberOnlyWrong}      ${voicePortErr}       ${portErrEven}
Invalid Space voicePort           ${voicePort}        ${SPACE}                ${voicePortErr}       ${portErrEven}
Invalid Is Low voicePort          ${voicePort}        ${portLow}              ${voicePortErr}       ${errRange}
Invalid Is High voicePort         ${voicePort}        ${portHigh}             ${voicePortErr}       ${errRange}
Invalid Is Odd voicePort          ${voicePort}        ${portOdd}              ${voicePortErr}       ${portErrEven}
Invalid Step voicePort            ${voicePort}        ${portStep}             ${voicePortErr}       ${portErrEven}

Invalid Format controlAttempt     ${controlAttempt}   ${NumberOnlyWrong}      ${controlAttemptErr}  ${errNumber}
Invalid Space controlAttempt      ${controlAttempt}   ${SPACE}                ${controlAttemptErr}  ${errNumber}
Invalid Is Low controlAttempt     ${controlAttempt}   ${controlAttemptLow}    ${controlAttemptErr}  ${errRange}
Invalid Is High controlAttempt    ${controlAttempt}   ${controlAttemptHigh}   ${controlAttemptErr}  ${errRange}
Invalid Step controlAttempt       ${controlAttempt}   ${controlAttemptStep}   ${controlAttemptErr}  ${errNumber}

Invalid Format connLossLimit      ${connLossLimit}    ${NumberOnlyWrong}      ${connLossLimitErr}   ${errNumber}
Invalid Space connLossLimit       ${connLossLimit}    ${SPACE}                ${connLossLimitErr}   ${errNumber}
Invalid Is Low connLossLimit      ${connLossLimit}    ${connLossLimitLow}     ${connLossLimitErr}   ${errRange}
Invalid Is High connLossLimit     ${connLossLimit}    ${connLossLimitHigh}    ${connLossLimitErr}   ${errRange}
Invalid Step connLossLimit        ${connLossLimit}    ${connLossLimitStep}    ${connLossLimitErr}   ${errNumber}

Invalid Format controlRetry       ${controlRetry}     ${NumberOnlyWrong}      ${controlRetryErr}    ${controlRetryErrStep}
Invalid Space controlRetry        ${controlRetry}     ${SPACE}                ${controlRetryErr}    ${controlRetryErrStep}
Invalid Is Low controlRetry       ${controlRetry}     ${controlRetryLow}      ${controlRetryErr}    ${errRange}
Invalid Is High controlRetry      ${controlRetry}     ${controlRetryHigh}     ${controlRetryErr}    ${errRange}
Invalid Step controlRetry         ${controlRetry}     ${controlRetryStep}     ${EMPTY}              ${EMPTY}

Invalid Format voterReport        ${voterReport}      ${NumberOnlyWrong}      ${voterReportErr}     ${errNumber}
Invalid Space voterReport         ${voterReport}      ${SPACE}                ${voterReportErr}     ${errNumber}
Invalid Is Low voterReport        ${voterReport}      ${voterReportLow}       ${voterReportErr}     ${errRange}
Invalid Is High voterReport       ${voterReport}      ${voterReportHigh}      ${voterReportErr}     ${errRange}
Invalid Step voterReport          ${voterReport}      ${voterReportStep}      ${voterReportErr}     ${errNumber}

# Invalid Format voiceEoSTimeout    ${voiceEoSTimeout}    ${NumberOnlyWrong}        ${voiceEoSTimeoutErr}   ${controlRetryErrStep}
# Invalid Space voiceEoSTimeout     ${voiceEoSTimeout}    ${SPACE}                  ${voiceEoSTimeoutErr}   ${controlRetryErrStep}
# Invalid Is Low voiceEoSTimeout    ${voiceEoSTimeout}    ${voiceEoSTimeoutLow}     ${voiceEoSTimeoutErr}   ${errRange}
# Invalid Is High voiceEoSTimeout   ${voiceEoSTimeout}    ${voiceEoSTimeoutHigh}    ${voiceEoSTimeoutErr}   ${errRange}
# Invalid Step voiceEoSTimeout      ${voiceEoSTimeout}    ${voiceEoSTimeoutStep}    ${voiceEoSTimeoutErr}   ${errRange}

# Invalid Format voiceBuffer        ${voiceBuffer}      ${NumberOnlyWrong}      ${voiceBufferErr}     ${errNumber}
# Invalid Space voiceBuffer         ${voiceBuffer}      ${SPACE}                ${voiceBufferErr}     ${errNumber}
# Invalid Is Low voiceBuffer        ${voiceBuffer}      ${voiceBufferLow}       ${voiceBufferErr}     ${errRange}
# Invalid Is High voiceBuffer       ${voiceBuffer}      ${voiceBufferHigh}      ${voiceBufferErr}     ${errRange}
# Invalid Step voiceBuffer          ${voiceBuffer}      ${voiceBufferStep}      ${voiceBufferErr}     ${errNumber}

*** Keywords ***
Edit Should Fail
    [Arguments]   ${Field ID}   ${Field Value}    ${Tooltip ID}     ${Tooltip Msg}
    Set Test Variable   ${Comment}      ${TEST NAME}: ${FIELD VALUE}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Run Keyword If    "${Tooltip ID}"!="${EMPTY}"  Wait Until Element Is Visible    ${Tooltip ID}
    Run Keyword If    "${Tooltip ID}"!="${EMPTY}"  Wait Until Element Contains      ${Tooltip ID}   ${Tooltip Msg}
    Click Element     ${radioName}
    Sleep   1s
    ${newFieldPlaceholder}=    Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    Run Keyword If    "${newFieldPlaceholder}"=="${Field Value}"     Fail    Placeholder matches incorrect value
