*** Settings ***
Documentation     Valid Radio Channel test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Click Radio Channel Then Advanced View
Test Template     Edit Should Pass
Test Teardown     Teardown Test
Resource          ../resources/radioChannel_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           String
Library           Collections

*** Test Cases ***                FIELD ID                FIELD VALUE                 FIELD REQUIREMENTS
Valid Format channelName          ${channelName}          ${ChannelNameFormat}        ${noRequirements}
Valid At Min channelName          ${channelName}          ${ChannelNameMin}           ${noRequirements}
Valid At Max channelName          ${channelName}          ${ChannelNameMax}           ${noRequirements}

Valid At Min rxFreq               ${rxFreq}               ${FreqMin}                  ${noRequirements}
Valid At Max rxFreq               ${rxFreq}               ${FreqMax}                  ${noRequirements}

Valid At Min txFreq               ${txFreq}               ${FreqMin}                  ${noRequirements}
Valid At Max txFreq               ${txFreq}               ${FreqMax}                  ${noRequirements}

Valid At Max txTimeout            ${txTimeout}            ${txTimeoutMax}             ${noRequirements}
Valid At Min txTimeout            ${txTimeout}            ${txTimeoutMin}             ${noRequirements}

Valid At Max txOutput             ${txOutput}             ${txOutputMax}              ${noRequirements}
Valid At Min txOutput             ${txOutput}             ${txOutputMin}              ${noRequirements}

Valid At Max txCTCSSLevel         ${txCTCSSLevel}         ${txCTCSSLevelMax}          ${analogTxUnmuteCTCSS}
Valid At Min txCTCSSLevel         ${txCTCSSLevel}         ${txCTCSSLevelMin}          ${analogTxUnmuteCTCSS}

Valid At Max txAnalogHangtime     ${txAnalogHangtime}     ${txAnalogHangtimeMax}      ${analogOnly}
Valid At Min txAnalogHangtime     ${txAnalogHangtime}     ${txAnalogHangtimeMin}      ${analogOnly}
Valid Step txAnalogHangtime       ${txAnalogHangtime}     ${txAnalogHangtimeStep}     ${analogOnly}

Valid At Min rxNAC                ${rxNAC}                ${rxNACMin}                 ${digitalRxUnmuteNACTGID}
#Valid At Max rxNAC                ${rxNAC}                ${rxNACMax}                 ${digitalRxUnmuteNACTGID}

Valid At Min rxTGID               ${rxTGID}               ${rxTGIDMin}                ${digitalRxUnmuteNACTGID}
Valid At Max rxTGID               ${rxTGID}               ${rxTGIDMax}                ${digitalRxUnmuteNACTGID}

Valid At Min txNAC                ${txNAC}                ${txNACMin}                 ${digitalOnly}
#Valid At Max txNAC                ${txNAC}                ${txNACMax}                 ${digitalOnly}

Valid At Max txDigitalHangtime    ${txDigitalHangtime}    ${txDigitalHangtimeMax}     ${digitalOnly}
Valid At Min txDigitalHangtime    ${txDigitalHangtime}    ${txDigitalHangtimeMin}     ${digitalOnly}
Valid Step txDigitalHangtime      ${txDigitalHangtime}    ${txDigitalHangtimeStep}    ${digitalOnly}

Valid List channelMode            ${channelMode}          ${channelModeList}          ${noRequirements}
Valid List channelType            ${channelType}          ${channelTypeList}          ${noRequirements}
Valid List rxSquelch              ${rxSquelch}            ${rxSquelchList}            ${analogOnly}
Valid List rxAnalogUnmute         ${rxAnalogUnmute}       ${rxAnalogUnmuteList}       ${analogOnly}
Valid List rxCTCSSTone            ${rxCTCSSTone}          ${rxCTCSSToneList}          ${analogRxUnmuteCTCSS}
Valid List rxDigitalUnmute        ${rxDigitalUnmute}      ${rxDigitalUnmuteList}      ${digitalOnly}
Valid List rxDeEmph               ${rxDeEmph}             ${rxDeEmphList}             ${analogOnly}
Valid List txSignal               ${txSignal}             ${txSignalList}             ${analogOnly}
Valid List txCTCSSTone            ${txCTCSSTone}          ${txCTCSSToneList}          ${analogTxUnmuteCTCSS}
Valid List txPreEmph              ${txPreEmph}            ${txPreEmphList}            ${analogOnly}

*** Keywords ***
Edit Should Pass
    [Arguments]   ${Field ID}   ${Field Value}    ${Field Requirements}
    Run Keyword If    "${Field Requirements}"!="${noRequirements}"   Show Required Fields   ${Field Requirements}
    ${passed}=    Run Keyword And Return Status   Evaluate    type(${Field Value})
    ${type}=      Run Keyword If     ${passed}    Evaluate    type(${Field Value})
    Run Keyword If    "${type}"=="${listFlag}" or "${type}"=="${typeListFlag}"    Test Dropdown   ${Field ID}   ${Field Value}
    ...       ELSE    Test Input    ${Field ID}   ${Field Value}

Test Dropdown
    [Arguments]   ${Field ID}   @{Field Value}
    ${Found Values}=   Get List Items    ${Field ID}
    Set Test Variable   ${Comment}    ${TEST NAME} dropdown should accept values @{Found Values}
    Lists Should Be Equal    ${Found Values}    @{Field Value}
    ${Selected}=    Get Selected List Label   ${Field ID}
    #Remove the currently selected value, check other values first,
    #so there is actually a change to check successful updates with
    Remove Values From List    ${Found Values}    ${Selected}
    :FOR    ${Item}    IN    @{Found Values}
    \   Click Element   ${Field ID}
    \   ${ItemStr}=   Convert To String   ${Item}
    \   Select From List   ${Field ID}  ${ItemStr}
    \   Wait Until Element Is Visible   ${updateLabel}
    \   Wait Until Element Contains     ${updateLabel}    ${updateLabelText}
    \   ${newValue}=    Get Selected List Label   ${Field ID}
    \   Run Keyword If    "${newValue}"!="${ItemStr}"     Fail    Dropdown value doesn't match correct value
    Click Element   ${Field ID}
    #Check the initial selected value
    Select From List    ${Field ID}   ${Selected}
    Wait Until Element Is Visible   ${updateLabel}
    Wait Until Element Contains     ${updateLabel}    ${updateLabelText}
    ${newValue}=    Get Selected List Label   ${Field ID}
    Run Keyword If    "${newValue}"!="${Selected}"     Fail    Dropdown value doesn't match correct value

Test Input
    [Arguments]   ${Field ID}   ${Field Value}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${Field Value}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Click Element            ${radioName}
    Wait Until Element Is Visible   ${updateLabel}
    Wait Until Element Contains     ${updateLabel}    ${updateLabelText}
    ${newFieldPlaceholder}=   Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    ${newFieldPlaceholder}=   Remove String   ${newFieldPlaceholder}    $
    Run Keyword If    "${newFieldPlaceholder}"!="${Field Value}"     Fail    Placeholder doesn't match correct value
