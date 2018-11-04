*** Settings ***
Documentation     Valid Radio Channel (All) test case suite.
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
&{channelFieldsListTop}     ${channelMode}=${channelModeAll}    ${channelType}=${channelTypeAll}
&{channelFieldsListAnalog}  ${rxSquelch}=${rxSquelchAll}        ${rxAnalogUnmute}=${rxAnalogUnmuteAll}  ${rxDeEmph}=${rxDeEmphAll}  ${txSignal}=${txSignalAll}  ${txPreEmph}=${txPreEmphAll}
&{channelFieldsListOthers}  ${rxCTCSSTone}=${rxCTCSSToneAll}    ${txCTCSSTone}=${txCTCSSToneAll}        ${rxDigitalUnmute}=${rxDigitalUnmuteAll}

&{channelFieldsList}    ${channelMode}=${channelModeAll}  ${channelType}=${channelTypeAll}  ${rxSquelch}=${rxSquelchAll}    ${rxAnalogUnmute}=${rxAnalogUnmuteAll}   ${rxCTCSSTone}=${rxCTCSSToneAll}
...                      ${rxDigitalUnmute}=${rxDigitalUnmuteAll}    ${rxDeEmph}=${rxDeEmphAll}   ${txSignal}=${txSignalAll}  ${txCTCSSTone}=${txCTCSSToneAll}  ${txPreEmph}=${txPreEmphAll}
&{channelFieldsTextbox}  ${rxFreq}=${rxFreqAll}   ${txFreq}=${txFreqAll}   ${txTimeout}=${txTimeoutAll}    ${txOutput}=${txOutputAll}     ${txCTCSSLevel}=${txCTCSSLevelAll}
...                     ${txAnalogHangtime}=${txAnalogHangtimeAll}     ${rxNAC}=${rxNACAll}    ${rxTGID}=${rxTGIDAll}   ${txNAC}=${txNACAll}    ${txDigitalHangtime}=${txDigitalHangtimeAll}

&{channel1OriginalValues}
&{channel1NewValues}
&{channel2OriginalValues}
&{channel2NewValues}

&{channelAllValues}   ${rxFreqAll}=${FreqMin}    ${txFreqAll}=${FreqMin}    ${txTimeoutAll}=${txTimeoutMax}        ${txOutputAll}=${txOutputMax}    ${txCTCSSLevelAll}=${txCTCSSLevelMax}
...                 ${txAnalogHangtimeAll}=${txAnalogHangtimeMax}    ${rxNACAll}=${rxNACMin}    ${rxTGIDAll}=${rxTGIDMin}    ${txNACAll}=${txNACMin}    ${txDigitalHangtimeAll}=${txDigitalHangtimeMax}
...                 ${channelModeAll}=${channelModeListOption}     ${channelTypeAll}=${channelTypeListOption}             ${rxSquelchAll}=${rxSquelchListOption}     ${rxAnalogUnmuteAll}=${rxAnalogUnmuteListOption}
...                 ${rxCTCSSToneAll}=${rxCTCSSToneListOption}     ${rxDigitalUnmuteAll}=${rxDigitalUnmuteListOption}     ${rxDeEmphAll}=${rxDeEmphListOption}       ${txSignalAll}=${txSignalListOption}
...                 ${txCTCSSToneAll}=${txCTCSSToneListOption}     ${txPreEmphAll}=${txPreEmphListOption}

@{fieldsAnalogTxUnmuteCTCSS}      ${txCTCSSLevel}         ${txCTCSSTone}
@{fieldsAnalogOnly}               ${txAnalogHangtime}     ${rxSquelch}            ${rxAnalogUnmute}   ${rxDeEmph}     ${txSignal}     ${txPreEmph}
@{fieldsAnalogRxUnmuteCTCSS}      ${rxCTCSSTone}
@{fieldsDigitalRxUnmuteNACTGID}   ${rxNAC}                ${rxTGID}
@{fieldsDigitalOnly}              ${txNAC}                ${txDigitalHangtime}    ${rxDigitalUnmute}

${channelModeListOption}          Receive Only
${channelTypeListOption}          Analog
${rxSquelchListOption}            Noise
${rxAnalogUnmuteListOption}       CTCSS
${rxCTCSSToneListOption}          100 Hz
${rxDigitalUnmuteListOption}      NAC
${rxDeEmphListOption}             Disable
${txSignalListOption}             CTCSS
${txCTCSSToneListOption}          103.5 Hz
${txPreEmphListOption}            Disable

${cloneButton}                    rx_clone_ch_tmpl
${cloneDropdown}                  rx_addtempl_ch
${cloneConfirm}                   rx_load_ch_tmpl

${allFieldFlag}                   All

*** Test Cases ***
All Radio Channel Edit Should Pass
    Set Test Variable   ${Comment}    ${TEST NAME}
    Log To Console      ${EMPTY}
    Log To Console      Gather Channel 1 Values
    Gather Channel Values     1     ${channel1OriginalValues}
    Log To Console      Gather Channel 2 Values
    Gather Channel Values     2     ${channel2OriginalValues}
    Log To Console      Set Channel All Values
    Set Channel All Values
    Log To Console      Gather New Channel 1 Values
    Gather Channel Values     1     ${channel1NewValues}
    Log To Console      Gather New Channel 2 Values
    Gather Channel Values     2     ${channel2NewValues}
    Log To Console      Compare Channel Values
    Compare Channel Values

*** Keywords ***
Gather Channel Values
    [Arguments]     ${channelNumberValue}   ${dictToAdd}
    Click Radio Channel Then Advanced View
    Select From List   ${channelNumber}  ${channelNumberValue}
    Sleep   5s
    @{listKeysTop}=    Get Dictionary Keys    ${channelFieldsListTop}
    :FOR    ${listSingle}  IN    @{listKeysTop}
    \   Log   ${listSingle}
    \   Navigate To Required Fields     ${listSingle}
    \   Append Dropdown List Text   ${listSingle}  ${dictToAdd}
    @{listKeysAnalog}=    Get Dictionary Keys    ${channelFieldsListAnalog}
    :FOR    ${listSingle}  IN    @{listKeysAnalog}
    \   Log   ${listSingle}
    \   Navigate To Required Fields     ${listSingle}
    \   Append Dropdown List Text   ${listSingle}  ${dictToAdd}
    @{listKeysOthers}=    Get Dictionary Keys    ${channelFieldsListOthers}
    :FOR    ${listSingle}  IN    @{listKeysOthers}
    \   Log   ${listSingle}
    \   Navigate To Required Fields     ${listSingle}
    \   Append Dropdown List Text   ${listSingle}  ${dictToAdd}
    @{textBoxKeys}=     Get Dictionary Keys     ${channelFieldsTextbox}
    :FOR    ${textBoxSingle}    IN    @{textBoxKeys}
    \   Log     ${textBoxSingle}
    \   Navigate To Required Fields     ${textBoxSingle}
    \   Append Placeholder    ${textBoxSingle}        ${dictToAdd}

Append Placeholder
    [Arguments]     ${fieldID}  ${dictToAdd}
    ${fieldValue}=  Wait Visible Get Attribute   ${fieldID}   ${placeholderFlag}
    ${fieldValue}=   Remove String   ${fieldValue}    $
    Set To Dictionary   ${dictToAdd}   ${fieldID}=${fieldValue}

Append Dropdown List Text
    [Arguments]     ${fieldID}  ${dictToAdd}
    ${fieldValue}=  Get Selected List Label   ${fieldID}
    Set To Dictionary   ${dictToAdd}   ${fieldID}=${fieldValue}

Set Channel All Values
    Click All Radio Channel Then Advanced View
    Log     ${channelAllValues}
    ${items}=    Get Dictionary Items    ${channelAllValues}
    :FOR    ${fieldID}    ${fieldValue}    IN    @{items}
    \   Continue For Loop If    '${fieldID}'=='WILL_ADD'
    \   ${isList}=      Run Keyword And Return Status   Dictionary Should Contain Value   ${channelFieldsList}  ${fieldID}
    \   ${isTextbox}=   Run Keyword And Return Status   Dictionary Should Contain Value   ${channelFieldsTextbox}  ${fieldID}
    \   Run Keyword If    ${isList}      Input Into All Dropdown List    ${fieldID}  ${fieldValue}
    \   ...    ELSE IF    ${isTextbox}   Input Into All Textbox          ${fieldID}  ${fieldValue}
    Wait Visible Do Action      ${channelApplyAll}  ${clickable}    ${clickable}
    Sleep   10s     #TODO Wait for update label

Navigate To Required Fields
    [Arguments]     ${fieldID}
    Run Keyword If  "${fieldID}" in @{fieldsAnalogTxUnmuteCTCSS}        Show Required Fields    ${analogTxUnmuteCTCSS}
    ...    ELSE IF  "${fieldID}" in @{fieldsAnalogOnly}                 Show Required Fields    ${analogOnly}
    ...    ELSE IF  "${fieldID}" in @{fieldsDigitalRxUnmuteNACTGID}     Show Required Fields    ${digitalRxUnmuteNACTGID}
    ...    ELSE IF  "${fieldID}" in @{fieldsDigitalOnly}                Show Required Fields    ${digitalOnly}
    ...    ELSE IF  "${fieldID}" in @{fieldsAnalogRxUnmuteCTCSS}        Show Required Fields    ${analogRxUnmuteCTCSS}

Compare Channel Values
    @{listKeys}=    Get Dictionary Keys    ${channelFieldsList}
    :FOR    ${listSingle}  IN    @{listKeys}
    \   ${listAll}=    Get From Dictionary    ${channelFieldsList}    ${listSingle}
    \   ${original1Value}=     Get From Dictionary    ${channel1OriginalValues}    ${listSingle}
    \   ${original2Value}=     Get From Dictionary    ${channel2OriginalValues}    ${listSingle}
    \   Continue For Loop If    '${listAll}'=='WILL_ADD'
    \   ${setAllValue}=        Get From Dictionary    ${channelAllValues}          ${listAll}
    \   ${new1Value}=          Get From Dictionary    ${channel1NewValues}         ${listSingle}
    \   ${new2Value}=          Get From Dictionary    ${channel2NewValues}         ${listSingle}
    \   Log    Key=${listSingle}/${listAll}, O1V=${original1Value}, O2V=${original2Value}, SAV=${setAllValue}, N1V=${new1Value}, N2V=${new2Value},
    \   Run Keyword If     "${original1Value}"=="${new1Value}"     Run Keyword And Continue On Failure      Fail    Channel 1 value did not change
    \   ...    ELSE IF     "${original2Value}"=="${new2Value}"     Run Keyword And Continue On Failure      Fail    Channel 2 value did not change
    \   ...    ELSE IF     "${setAllValue}"!="${new1Value}"        Run Keyword And Continue On Failure      Fail    Global value did not set Channel 1 value
    \   ...    ELSE IF     "${setAllValue}"!="${new2Value}"        Run Keyword And Continue On Failure      Fail    Global value did not set Channel 2 value

    @{textBoxKeys}=     Get Dictionary Keys     ${channelFieldsTextbox}
    :FOR    ${textBoxSingle}    IN    @{textBoxKeys}
    \   ${textboxAll}=    Get From Dictionary    ${channelFieldsTextbox}    ${textBoxSingle}
    \   ${original1Value}=     Get From Dictionary    ${channel1OriginalValues}    ${textBoxSingle}
    \   ${original2Value}=     Get From Dictionary    ${channel2OriginalValues}    ${textBoxSingle}
    \   ${setAllValue}=        Get From Dictionary    ${channelAllValues}          ${textboxAll}
    \   ${new1Value}=          Get From Dictionary    ${channel1NewValues}         ${textBoxSingle}
    \   ${new2Value}=          Get From Dictionary    ${channel2NewValues}         ${textBoxSingle}
    \   Log    Key=${textBoxSingle}/${textboxAll}, O1V=${original1Value}, O2V=${original2Value}, SAV=${setAllValue}, N1V=${new1Value}, N2V=${new2Value},
    \   Run Keyword If     "${original1Value}"=="${new1Value}"     Run Keyword And Continue On Failure      Fail    Channel 1 value did not change
    \   ...    ELSE IF     "${original2Value}"=="${new2Value}"     Run Keyword And Continue On Failure      Fail    Channel 2 value did not change
    \   ...    ELSE IF     "${setAllValue}"!="${new1Value}"        Run Keyword And Continue On Failure      Fail    Global value did not set Channel 1 value
    \   ...    ELSE IF     "${setAllValue}"!="${new2Value}"        Run Keyword And Continue On Failure      Fail    Global value did not set Channel 2 value

Input Into All Dropdown List
    [Arguments]   ${Field ID}   ${Field Value}
    Click Element   ${Field ID}
    Select From List   ${Field ID}  ${Field Value}

Input Into Dropdown List
    [Arguments]   ${Field ID}   ${Field Value}
    Click Element   ${Field ID}
    Select From List   ${Field ID}  ${Field Value}
    Click Element       ${radioName}
    Run Keyword Unless  "${Field ID}"=="${txCTCSSTone}" or "${Field ID}"=="${txSignal}"     Wait Until Element Is Visible   ${updateLabel}
    Run Keyword Unless  "${Field ID}"=="${txCTCSSTone}" or "${Field ID}"=="${txSignal}"     Wait Until Element Contains     ${updateLabel}    ${updateLabelText}
    ${newValue}=    Get Selected List Label   ${Field ID}
    Run Keyword If    "${newValue}"!="${Field Value}"     Fail    Dropdown value doesn't match correct value

Input Into All Textbox
    [Arguments]   ${Field ID}   ${Field Value}
    Click Element            ${Field ID}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}

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
