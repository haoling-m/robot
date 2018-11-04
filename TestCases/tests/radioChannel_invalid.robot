*** Settings ***
Documentation     Invalid Radio Channel test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Click Radio Channel Then Advanced View
Test Template     Edit Should Fail
Test Teardown     Teardown Test
Resource          ../resources/radioChannel_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***                    FIELD ID              FIELD VALUE               TOOLTIP ID              FIELD REQUIREMENTS
Invalid Format 01 channelName         ${channelName}        ${invalidChannelName1}    ${channelNameErr}       ${noRequirements}
Invalid Format 02 channelName         ${channelName}        ${invalidChannelName2}    ${channelNameErr}       ${noRequirements}
Invalid Format 03 channelName         ${channelName}        ${invalidChannelName3}    ${channelNameErr}       ${noRequirements}
Invalid Format 04 channelName         ${channelName}        ${invalidChannelName4}    ${channelNameErr}       ${noRequirements}

Invalid Format rxFreq                 ${rxFreq}             ${NumberOnlyWrong}        ${rxFreqErr}            ${noRequirements}
Invalid Space rxFreq                  ${rxFreq}             ${SPACE}                  ${rxFreqErr}            ${noRequirements}
Invalid Is Low rxFreq                 ${rxFreq}             ${FreqLow}                ${rxFreqErr}            ${noRequirements}
Invalid Is High rxFreq                ${rxFreq}             ${FreqHigh}               ${rxFreqErr}            ${noRequirements}

Invalid Format txFreq                 ${txFreq}             ${NumberOnlyWrong}        ${txFreqErr}            ${noRequirements}
Invalid Space txFreq                  ${txFreq}             ${SPACE}                  ${txFreqErr}            ${noRequirements}
Invalid Is Low txFreq                 ${txFreq}             ${FreqLow}                ${txFreqErr}            ${noRequirements}
Invalid Is High txFreq                ${txFreq}             ${FreqHigh}               ${txFreqErr}            ${noRequirements}

Invalid Format txTimeout              ${txTimeout}          ${NumberOnlyWrong}        ${txTimeoutErr}         ${noRequirements}
Invalid Space txTimeout               ${txTimeout}          ${SPACE}                  ${txTimeoutErr}         ${noRequirements}
Invalid Is Low txTimeout              ${txTimeout}          ${txTimeoutLow}           ${txTimeoutErr}         ${noRequirements}
Invalid Is High txTimeout             ${txTimeout}          ${txTimeoutHigh}          ${txTimeoutErr}         ${noRequirements}
Invalid Step txTimeout                ${txTimeout}          ${txTimeoutStep}          ${txTimeoutErr}         ${noRequirements}

Invalid Format txOutput               ${txOutput}           ${NumberOnlyWrong}        ${txOutputErr}          ${noRequirements}
Invalid Space txOutput                ${txOutput}           ${SPACE}                  ${txOutputErr}          ${noRequirements}
Invalid Is Low txOutput               ${txOutput}           ${txOutputLow}            ${txOutputErr}          ${noRequirements}
Invalid Is High txOutput              ${txOutput}           ${txOutputHigh}           ${txOutputErr}          ${noRequirements}
Invalid Step txOutput                 ${txOutput}           ${txOutputStep}           ${txOutputErr}          ${noRequirements}

Invalid Format txCTCSSLevel           ${txCTCSSLevel}       ${NumberOnlyWrong}        ${txCTCSSLevelErr}      ${analogTxUnmuteCTCSS}
Invalid Space txCTCSSLevel            ${txCTCSSLevel}       ${SPACE}                  ${txCTCSSLevelErr}      ${analogTxUnmuteCTCSS}
Invalid Is Low txCTCSSLevel           ${txCTCSSLevel}       ${txCTCSSLevelLow}        ${txCTCSSLevelErr}      ${analogTxUnmuteCTCSS}
Invalid Is High txCTCSSLevel          ${txCTCSSLevel}       ${txCTCSSLevelHigh}       ${txCTCSSLevelErr}      ${analogTxUnmuteCTCSS}

Invalid Format txAnalogHangtime       ${txAnalogHangtime}   ${NumberOnlyWrong}        ${txAnalogHangtimeErr}  ${analogOnly}
Invalid Space txAnalogHangtime        ${txAnalogHangtime}   ${SPACE}                  ${txAnalogHangtimeErr}  ${analogOnly}
Invalid Is Low txAnalogHangtime       ${txAnalogHangtime}   ${txAnalogHangtimeLow}    ${txAnalogHangtimeErr}  ${analogOnly}
Invalid Is High txAnalogHangtime      ${txAnalogHangtime}   ${txAnalogHangtimeHigh}   ${txAnalogHangtimeErr}  ${analogOnly}

Invalid Format rxNAC                  ${rxNAC}              ${NumberOnlyWrong}        ${rxNACErr}             ${digitalRxUnmuteNACTGID}
Invalid Space rxNAC                   ${rxNAC}              ${SPACE}                  ${rxNACErr}             ${digitalRxUnmuteNACTGID}
Invalid Is Low rxNAC                  ${rxNAC}              ${rxNACLow}               ${rxNACErr}             ${digitalRxUnmuteNACTGID}
Invalid Is High rxNAC                 ${rxNAC}              ${rxNACHigh}              ${rxNACErr}             ${digitalRxUnmuteNACTGID}

Invalid Format rxTGID                 ${rxTGID}             ${NumberOnlyWrong}        ${rxTGIDErr}            ${digitalRxUnmuteNACTGID}
Invalid Space rxTGID                  ${rxTGID}             ${SPACE}                  ${rxTGIDErr}            ${digitalRxUnmuteNACTGID}
Invalid Is Low rxTGID                 ${rxTGID}             ${rxTGIDLow}              ${rxTGIDErr}            ${digitalRxUnmuteNACTGID}
Invalid Is High rxTGID                ${rxTGID}             ${rxTGIDHigh}             ${rxTGIDErr}            ${digitalRxUnmuteNACTGID}

Invalid Format txNAC                  ${txNAC}              ${NumberOnlyWrong}        ${txNACErr}             ${digitalOnly}
Invalid Space txNAC                   ${txNAC}              ${SPACE}                  ${txNACErr}             ${digitalOnly}
Invalid Is Low txNAC                  ${txNAC}              ${txNACLow}               ${txNACErr}             ${digitalOnly}
Invalid Is High txNAC                 ${txNAC}              ${txNACHigh}              ${txNACErr}             ${digitalOnly}
Invalid txNAC $F7E                    ${txNAC}              ${txNACNonAllowed1}       ${txNACErr}             ${digitalOnly}
Invalid txNAC $F7F                    ${txNAC}              ${txNACNonAllowed2}       ${txNACErr}             ${digitalOnly}

Invalid Format txDigitalHangtime      ${txDigitalHangtime}  ${NumberOnlyWrong}        ${txDigitalHangtimeErr}   ${digitalOnly}
Invalid Space txDigitalHangtime       ${txDigitalHangtime}  ${SPACE}                  ${txDigitalHangtimeErr}   ${digitalOnly}
Invalid Is Low txDigitalHangtime      ${txDigitalHangtime}  ${txDigitalHangtimeLow}   ${txDigitalHangtimeErr}   ${digitalOnly}
Invalid Is High txDigitalHangtime     ${txDigitalHangtime}  ${txDigitalHangtimeHigh}  ${txDigitalHangtimeErr}   ${digitalOnly}

*** Keywords ***
Edit Should Fail
    [Arguments]   ${Field ID}   ${Field Value}    ${Tooltip ID}   ${Field Requirements}
    Set Test Variable    ${Comment}    ${TEST NAME}: ${Field Value}
    Run Keyword If    "${Field Requirements}"!="${noRequirements}"    Show Required Fields   ${Field Requirements}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Click Element            ${radioName}
    Sleep   2s
    ${newFieldPlaceholder}=    Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    Run Keyword If    "${newFieldPlaceholder}"=="${Field Value}"     Fail    Placeholder matches incorrect value
