*** Settings ***
Documentation     Valid Radio Channel (Clone) test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Click Radio Channel Then Advanced View
Test Teardown     Teardown Test
Resource          ../resources/radioChannel_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           String
Library           Collections

*** Variables ***
@{channelFieldsList}    ${channelMode}  ${channelType}  ${rxSquelch}    ${rxAnalogUnmute}   ${rxCTCSSTone}  ${rxDigitalUnmute}
...                     ${rxDeEmph}             ${txSignal}         ${txCTCSSTone}  ${txPreEmph}
@{channelFieldsTextbox}  ${rxFreq}   ${txFreq}   ${txTimeout}    ${txOutput}     ${txCTCSSLevel}
...                     ${txAnalogHangtime}     ${rxNAC}    ${rxTGID}   ${txNAC}    ${txDigitalHangtime}
@{channelFields}        @{channelFieldsList}    @{channelFieldsTextbox}

&{channel1OriginalValues}
&{channel1NewValues}

&{channel2Values}   ${rxFreq}=${FreqMin}    ${txFreq}=${FreqMin}    ${txTimeout}=${txTimeoutMax}        ${txOutput}=${txOutputMax}    ${txCTCSSLevel}=${txCTCSSLevelMax}
...                 ${txAnalogHangtime}=${txAnalogHangtimeMax}    ${rxNAC}=${rxNACMin}    ${rxTGID}=${rxTGIDMin}    ${txNAC}=${txNACMin}    ${txDigitalHangtime}=${txDigitalHangtimeMax}
...                 ${channelMode}=${channelModeListOption}     ${channelType}=${channelTypeListOption}             ${rxSquelch}=${rxSquelchListOption}     ${rxAnalogUnmute}=${rxAnalogUnmuteListOption}
...                 ${rxCTCSSTone}=${rxCTCSSToneListOption}     ${rxDigitalUnmute}=${rxDigitalUnmuteListOption}     ${rxDeEmph}=${rxDeEmphListOption}       ${txSignal}=${txSignalListOption}
...                 ${txCTCSSTone}=${txCTCSSToneListOption}     ${txPreEmph}=${txPreEmphListOption}

@{fieldsAnalogTxUnmuteCTCSS}        ${txCTCSSLevel}         ${txCTCSSTone}
@{fieldsAnalogOnly}                 ${txAnalogHangtime}     ${rxSquelch}            ${rxAnalogUnmute}   ${rxDeEmph}     ${txSignal}     ${txPreEmph}
@{fieldsAnalogRxUnmuteCTCSS}        ${rxCTCSSTone}
@{fieldsDigitalRxUnmuteNACTGID}     ${rxNAC}                ${rxTGID}
@{fieldsDigitalOnly}                ${txNAC}                ${txDigitalHangtime}    ${rxDigitalUnmute}

${channelModeListOption}        Receive Only
${channelTypeListOption}        Analog
${rxSquelchListOption}          Noise
${rxAnalogUnmuteListOption}     CTCSS
${rxCTCSSToneListOption}        100 Hz
${rxDigitalUnmuteListOption}    NAC
${rxDeEmphListOption}           Disable
${txSignalListOption}           CTCSS
${txCTCSSToneListOption}        103.5 Hz
${txPreEmphListOption}          Disable

${cloneButton}                  rx_clone_ch_tmpl
${cloneDropdown}                rx_addtempl_ch
${cloneConfirm}                 rx_load_ch_tmpl

*** Test Cases ***
Clone Should Pass
    Set Test Variable   ${Comment}    ${TEST NAME}
    Log To Console      ${EMPTY}
    Log To Console      Gather Channel 1 Values
    Gather Channel 1 Values     ${channel1OriginalValues}
    Log To Console      Set Channel 2 Values
    Set Channel 2 Values
    Log To Console      Clone Channel
    Clone Channel
    Log To Console      Gather Channel 1 Values
    Gather Channel 1 Values     ${channel1NewValues}
    Log To Console      Compare Channel Values
    Compare Channel Values

*** Keywords ***
Gather Channel 1 Values
    [Arguments]     ${dictToAdd}
    Select From List   ${channelNumber}  1
    Sleep   5s
    :FOR    ${fieldID}  IN    @{channelFields}
    \   Navigate To Required Fields     ${fieldID}
    \   Run Keyword If    "${fieldID}" in @{channelFieldsList}      Append Dropdown List Text   ${fieldID}  ${dictToAdd}
    \   ...    ELSE IF    "${fieldID}" in @{channelFieldsTextbox}   Append Placeholder    ${fieldID}        ${dictToAdd}

Append Placeholder
    [Arguments]     ${fieldID}  ${dictToAdd}
    ${fieldValue}=  Wait Visible Get Attribute   ${fieldID}   ${placeholderFlag}
    ${fieldValue}=   Remove String   ${fieldValue}    $
    Set To Dictionary   ${dictToAdd}   ${fieldID}=${fieldValue}

Append Dropdown List Text
    [Arguments]     ${fieldID}  ${dictToAdd}
    ${fieldValue}=  Get Selected List Label   ${fieldID}
    Set To Dictionary   ${dictToAdd}   ${fieldID}=${fieldValue}

Set Channel 2 Values
    ${items}=    Get Dictionary Items    ${channel2Values}
    :FOR    ${fieldID}    ${fieldValue}    IN    @{items}
    \   Click Radio Channel Then Advanced View
    \   Select From List   ${channelNumber}  2
    \   Sleep   5s
    \   Navigate To Required Fields     ${fieldID}
    \   Run Keyword If    "${fieldID}" in @{channelFieldsList}      Input Into Dropdown List    ${fieldID}  ${fieldValue}
    \   ...    ELSE IF    "${fieldID}" in @{channelFieldsTextbox}   Input Into Textbox          ${fieldID}  ${fieldValue}

Navigate To Required Fields
    [Arguments]     ${fieldID}
    Run Keyword If  "${fieldID}" in @{fieldsAnalogTxUnmuteCTCSS}        Show Required Fields    ${analogTxUnmuteCTCSS}
    ...    ELSE IF  "${fieldID}" in @{fieldsAnalogOnly}                 Show Required Fields    ${analogOnly}
    ...    ELSE IF  "${fieldID}" in @{fieldsDigitalRxUnmuteNACTGID}     Show Required Fields    ${digitalRxUnmuteNACTGID}
    ...    ELSE IF  "${fieldID}" in @{fieldsDigitalOnly}                Show Required Fields    ${digitalOnly}
    ...    ELSE IF  "${fieldID}" in @{fieldsAnalogRxUnmuteCTCSS}        Show Required Fields    ${analogRxUnmuteCTCSS}

Clone Channel
    Click Radio Channel Then Advanced View
    Select From List   ${channelNumber}  2
    Sleep   5s
    ${channel2Value}=   Get Value   ${channelNumber}
    Select From List   ${channelNumber}  1
    Sleep   5s
    Wait Visible Do Action  ${cloneButton}  Click   ${clickable}
    Sleep   1s
    #Wait Until Element Is Visible   ${cloneDropdown}
    Select From List By Value   ${cloneDropdown}    ${channel2Value}
    Wait Visible Do Action  ${cloneConfirm}  Click   ${clickable}
    Wait Until Element Is Visible   ${updateLabel}
    Wait Until Element Contains     ${updateLabel}    ${updateLabelText}

Compare Channel Values
    :FOR    ${fieldID}    IN    @{channelFields}
    \    ${originalValue}=    Get From Dictionary    ${channel1OriginalValues}    ${fieldID}
    \    ${setValue}=    Get From Dictionary    ${channel2Values}    ${fieldID}
    \    ${clonedValue}=    Get From Dictionary    ${channel1NewValues}   ${fieldID}
    \    Log    Key=${fieldID}, Original Value=${originalValue}, Value Set=${setValue}, Cloned Value=${clonedValue}
    \    Run Keyword If     "${originalValue}"=="${clonedValue}"    Fail    Cloned value matches original value
    \    Run Keyword If     "${setValue}"!="${clonedValue}"    Fail    Cloned value was not cloned from set value

Input Into Dropdown List
    [Arguments]   ${Field ID}   ${Field Value}
    Click Element   ${Field ID}
    Select From List   ${Field ID}  ${Field Value}
    Run Keyword Unless  "${Field ID}"=="${txCTCSSTone}" or "${Field ID}"=="${txSignal}"     Wait Until Element Is Visible   ${updateLabel}
    Run Keyword Unless  "${Field ID}"=="${txCTCSSTone}" or "${Field ID}"=="${txSignal}"     Wait Until Element Contains     ${updateLabel}    ${updateLabelText}
    ${newValue}=    Get Selected List Label   ${Field ID}
    Run Keyword If    "${newValue}"!="${Field Value}"     Fail    Dropdown value doesn't match correct value

Input Into Textbox
    [Arguments]   ${Field ID}   ${Field Value}
    Click Element            ${Field ID}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Click Element            ${radioName}
    Wait Until Element Is Visible   ${updateLabel}
    Wait Until Element Contains     ${updateLabel}    ${updateLabelText}
    ${newFieldPlaceholder}=   Wait Visible Get Attribute   ${Field ID}   ${placeholderFlag}
    ${newFieldPlaceholder}=   Remove String   ${newFieldPlaceholder}    $
    Run Keyword If    "${newFieldPlaceholder}"!="${Field Value}"     Fail    Placeholder doesn't match correct value
