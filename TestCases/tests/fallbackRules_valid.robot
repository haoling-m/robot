*** Settings ***
Documentation     Valid Fallback Rules test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Fallback Rules
Test Template     Edit Should Pass
Test Teardown     Teardown Test
Resource          ../resources/navigation_resource.robot
Resource          ../resources/fallbackRules_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           String
Library           Collections

*** Test Cases ***              FIELD ID                FIELD VALUE
Valid List rxSynthUnlock        ${rxSynthUnlock}        ${rxSynthUnlockList}
Valid List rx1ppsUnlock         ${rx1ppsUnlock}         ${rx1ppsUnlockList}
Valid List txSynthUnlock        ${txSynthUnlock}        ${txSynthUnlockList}
Valid List txRefFreqUnlock      ${txRefFreqUnlock}      ${txRefFreqUnlockList}
Valid List fsiDisconnect        ${fsiDisconnect}        ${fsiDisconnectList}
Valid List high48V              ${high48V}              ${high48VList}
Valid List low48V               ${low48V}               ${low48VList}
Valid List highCurrent          ${highCurrent}          ${highCurrentList}
Valid List paDisconnect         ${paDisconnect}         ${paDisconnectList}
Valid List paHigh48V            ${paHigh48V}            ${paHigh48VList}
Valid List paLow48V             ${paLow48V}             ${paLow48VList}
Valid List paHighCurrent        ${paHighCurrent}        ${paHighCurrentList}
Valid List paHighTemp           ${paHighTemp}           ${paHighTempList}
Valid List paOutputPower        ${paOutputPower}        ${paOutputPowerList}
Valid List leftFail48V          ${leftFail48V}          ${leftFail48VList}
Valid List rightFail48V         ${rightFail48V}         ${rightFail48VList}

*** Keywords ***
Edit Should Pass
    [Arguments]   ${Field ID}   @{Field Value}
    Set Suite Variable    ${Comment}    ${TEST NAME}: ${FIELD VALUE}
    # Need the window height for these tests to be high, otherwise list selection won't save for Firefox
    Run Keyword If    '${TEST NAME}'=='Valid List paHighTemp' or '${TEST NAME}'=='Valid List paOutputPower'   Set Window Size   900   1020
    ${Found Values}=   Get List Items    ${Field ID}
    Lists Should Be Equal    ${Found Values}    @{Field Value}
    # No option is pre selected with fsiDisconnect in current GUI, so select one to start test
    Run Keyword If    '${TEST NAME}'=='Valid List fsiDisconnect'    Select From List By Value   ${Field ID}   nothing
    ${Selected}=    Get Selected List Label   ${Field ID}
    # Remove the currently selected value, check other values first,
    # so there is actually a change to check successful updates with
    Remove Values From List    ${Found Values}    ${Selected}
    :FOR    ${Item}    IN    @{Found Values}
    \   Click Element   ${Field ID}
    \   ${ItemStr}=   Convert To String   ${Item}
    \   Select From List   ${Field ID}  ${ItemStr}
    # Firefox needs to click outside of dropdown list for update to go through
    \   Run Keyword If    '${BROWSER}'=='${FIREFOX}'    Click Element   ${fallbackRules}
    \   Wait Until Element Is Visible   ${updateLabel}
    \   Wait Until Element Contains     ${updateLabel}    ${updateLabelText}
    \   Capture Page Screenshot
    \   Navigate To Fallback Rules
    \   ${newValue}=    Get Selected List Label   ${Field ID}
    \   Run Keyword If    "${newValue}"!="${ItemStr}"     Fail    Dropdown value doesn't match correct value
    Click Element   ${Field ID}
    # Check the initial selected value
    Select From List    ${Field ID}   ${Selected}
    Run Keyword If    '${BROWSER}'=='${FIREFOX}'    Click Element   ${fallbackRules}
    Wait Until Element Is Visible   ${updateLabel}
    Wait Until Element Contains     ${updateLabel}    ${updateLabelText}
    Navigate To Fallback Rules
    ${newValue}=    Get Selected List Label   ${Field ID}
    Run Keyword If    "${newValue}"!="${Selected}"     Fail    Dropdown value doesn't match correct value
