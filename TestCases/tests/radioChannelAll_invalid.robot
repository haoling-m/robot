*** Settings ***
Documentation     Invalid Radio Channel (All) test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Click All Radio Channel Then Advanced View
Test Template     All Radio Channel Edit Should Fail
Test Teardown     Teardown Test
Resource          ../resources/radioChannel_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***                    FIELD ID                  FIELD VALUE                 TOOLTIP ID                      TOOLTIP MSG
Invalid Format rxFreq                 ${rxFreqAll}              ${NumberOnlyWrong}          ${rxFreqErrAll}                 ${errRange2}
Invalid Space rxFreq                  ${rxFreqAll}              ${SPACE}                    ${rxFreqErrAll}                 ${errRange2}
Invalid Is Low rxFreq                 ${rxFreqAll}              ${FreqLow}                  ${rxFreqErrAll}                 ${errRange2}
Invalid Is High rxFreq                ${rxFreqAll}              ${FreqHigh}                 ${rxFreqErrAll}                 ${errRange2}

Invalid Format rxNAC                  ${rxNACAll}               ${NumberOnlyWrong}          ${rxNACErrAll}                  ${errFormat}
Invalid Space rxNAC                   ${rxNACAll}               ${SPACE}                    ${rxNACErrAll}                  ${errFormat}
Invalid Is Low rxNAC                  ${rxNACAll}               ${rxNACLow}                 ${rxNACErrAll}                  ${errFormat}
Invalid Is High rxNAC                 ${rxNACAll}               ${rxNACHigh}                ${rxNACErrAll}                  ${errRange}

Invalid Format rxTGID                 ${rxTGIDAll}              ${NumberOnlyWrong}          ${rxTGIDErrAll}                 ${errFormat}
Invalid Space rxTGID                  ${rxTGIDAll}              ${SPACE}                    ${rxTGIDErrAll}                 ${errFormat}
Invalid Is Low rxTGID                 ${rxTGIDAll}              ${rxTGIDLow}                ${rxTGIDErrAll}                 ${errFormat}
Invalid Is High rxTGID                ${rxTGIDAll}              ${rxTGIDHigh}               ${rxTGIDErrAll}                 ${errRange}

Invalid Format txFreq                 ${txFreqAll}              ${NumberOnlyWrong}          ${txFreqErrAll}                 ${errRange2}
Invalid Space txFreq                  ${txFreqAll}              ${SPACE}                    ${txFreqErrAll}                 ${errRange2}
Invalid Is Low txFreq                 ${txFreqAll}              ${FreqLow}                  ${txFreqErrAll}                 ${errRange2}
Invalid Is High txFreq                ${txFreqAll}              ${FreqHigh}                 ${txFreqErrAll}                 ${errRange2}

Invalid Format txTimeout              ${txTimeoutAll}           ${NumberOnlyWrong}          ${txTimeoutErrAll}              ${errFormatNumber}
Invalid Space txTimeout               ${txTimeoutAll}           ${SPACE}                    ${txTimeoutErrAll}              ${errFormatNumber}
Invalid Is Low txTimeout              ${txTimeoutAll}           ${txTimeoutLow}             ${txTimeoutErrAll}              ${errRange}
Invalid Is High txTimeout             ${txTimeoutAll}           ${txTimeoutHigh}            ${txTimeoutErrAll}              ${errRange}
Invalid Step txTimeout                ${txTimeoutAll}           ${txTimeoutStep}            ${txTimeoutErrAll}              ${errFormatNumber}

Invalid Format txOutput               ${txOutputAll}            ${NumberOnlyWrong}          ${txOutputErrAll}               ${errFormatNumber}
Invalid Space txOutput                ${txOutputAll}            ${SPACE}                    ${txOutputErrAll}               ${errFormatNumber}
Invalid Is Low txOutput               ${txOutputAll}            ${txOutputLow}              ${txOutputErrAll}               ${errRange}
Invalid Is High txOutput              ${txOutputAll}            ${txOutputHigh}             ${txOutputErrAll}               ${errRange}
Invalid Step txOutput                 ${txOutputAll}            ${txOutputStep}             ${txOutputErrAll}               ${errFormatNumber}

Invalid Format txNAC                  ${txNACAll}               ${NumberOnlyWrong}          ${txNACErrAll}                  ${errFormat}
Invalid Space txNAC                   ${txNACAll}               ${SPACE}                    ${txNACErrAll}                  ${errFormat}
Invalid Is Low txNAC                  ${txNACAll}               ${txNACLow}                 ${txNACErrAll}                  ${errFormat}
Invalid Is High txNAC                 ${txNACAll}               ${txNACHigh}                ${txNACErrAll}                  ${errRange}
Invalid Non Allowed txNAC $F7E        ${txNACAll}               ${txNACNonAllowed1}         ${txNACErrAll}                  ${errRange}
Invalid Non Allowed txNAC $F7F        ${txNACAll}               ${txNACNonAllowed2}         ${txNACErrAll}                  ${errRange}

Invalid Format txDigitalHangtime      ${txDigitalHangtimeAll}   ${NumberOnlyWrong}          ${txDigitalHangtimeErrAll}      ${errFormatPeriod}
Invalid Space txDigitalHangtime       ${txDigitalHangtimeAll}   ${SPACE}                    ${txDigitalHangtimeErrAll}      ${errFormatPeriod}
Invalid Is Low txDigitalHangtime      ${txDigitalHangtimeAll}   ${txDigitalHangtimeLow}     ${txDigitalHangtimeErrAll}      ${errFormatPeriod}
Invalid Is High txDigitalHangtime     ${txDigitalHangtimeAll}   ${txDigitalHangtimeHigh}    ${txDigitalHangtimeErrAll}      ${errRange}

Invalid Format txCTCSSLevel           ${txCTCSSLevelAll}        ${NumberOnlyWrong}          ${txCTCSSLevelErrAll}           ${errFormatPeriod}
Invalid Space txCTCSSLevel            ${txCTCSSLevelAll}        ${SPACE}                    ${txCTCSSLevelErrAll}           ${errFormatPeriod}
Invalid Is Low txCTCSSLevel           ${txCTCSSLevelAll}        ${txCTCSSLevelLow}          ${txCTCSSLevelErrAll}           ${errFormatPeriod}
Invalid Is High txCTCSSLevel          ${txCTCSSLevelAll}        ${txCTCSSLevelHigh}         ${txCTCSSLevelErrAll}           ${errRange}

Invalid Format txAnalogHangtime       ${txAnalogHangtimeAll}    ${NumberOnlyWrong}          ${txAnalogHangtimeErrAll}       ${errFormatPeriod}
Invalid Space txAnalogHangtime        ${txAnalogHangtimeAll}    ${SPACE}                    ${txAnalogHangtimeErrAll}       ${errFormatPeriod}
Invalid Is Low txAnalogHangtime       ${txAnalogHangtimeAll}    ${txAnalogHangtimeLow}      ${txAnalogHangtimeErrAll}       ${errFormatPeriod}
Invalid Is High txAnalogHangtime      ${txAnalogHangtimeAll}    ${txAnalogHangtimeHigh}     ${txAnalogHangtimeErrAll}       ${errRange}

*** Keywords ***
All Radio Channel Edit Should Fail
    [Arguments]   ${Field ID}   ${Field Value}  ${Tooltip ID}   ${Tooltip Msg}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${Field Value}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Wait Until Element Is Visible   ${Tooltip ID}
    Wait Until Element Contains     ${Tooltip ID}   ${Tooltip Msg}
    Element Should Be Disabled      ${channelApplyAll}
