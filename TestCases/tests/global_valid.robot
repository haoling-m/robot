*** Settings ***
Documentation     Tests valid global settings input
Suite Setup       Global Valid Suite Setup
Suite Teardown    Global Valid Suite Teardown
Test Setup        Click Global Settings And Expand
Test Template     Valid Global
Test Teardown     Teardown Test
Resource          ../resources/global_settings_resource.robot
Resource          ../resources/testrail_api_resource.robot
Resource          ../resources/utility_resource.robot
Library           String

*** Test Cases ***                 FIELD ID         FIELD VALUE
Valid Name Min                     ${uicName}       a
Valid Name Max                     ${uicName}       ${25Character String}
Valid Name Has Dash                ${uicName}       ${String hasDash}
Valid Name Has Underscore          ${uicName}       ${String hasUnderScore}
Valid Name Has Space               ${uicName}       ${SPACE}
Valid Name Has Symbols             ${uicName}       ${Symbols String}
#Valid Name HTML String             ${uicName}       ${HTMLString}

Valid Description Max              ${uicDesc}       ${255Character String}
Valid Description Empty            ${uicDesc}       ${EMPTY}
Valid Description Has Dash         ${uicDesc}       ${String hasDash}
Valid Description Has Underscore   ${uicDesc}       ${String hasUnderScore}
Valid Description Has Symbols      ${uicDesc}       ${Symbols String}
Valid Description HTML String      ${uicDesc}       ${HTMLString}

Valid DFSI Override CheckBox       ${priorityOverride}    checkBox

Valid IP Address                   ${ipv4}          ${SERVERALT}
Valid Subnet                       ${subnetMask}    ${SubnetMaskOptions}
Valid NTP                          ${ntpuri}        ${Test NTP}

*** not accepted/causes errors, need to fix in later version? ¯\_(ツ)_/¯***
Valid Name QuotationEscape         ${uicDesc}       ${QuotesEscapedString}
Valid Name HTML Entity             ${uicDesc}       ${HTMLEntityString}
Valid Desc QuotationEscape         ${uicDesc}       ${QuotesEscapedString}
Valid Desc HTMLEncodeString        ${uicDesc}       ${HTML Entity}

*** Keywords ***
Valid Global
    [Arguments]   ${Field ID}   ${Field Value}
    Wait Until Element Is Visible   ${Field ID}
    Run Keyword if    "${Field ID}"=="${dhcp}" or "${Field ID}"=="${priorityOverride}"    Test CheckBox    ${Field ID}
    ...         ELSE IF   '${TEST NAME}'=='Valid Subnet'    Run Keywords    Set Test Variable   ${Comment}   Should Accept ${TEST NAME} Values ${Field Value}   AND   Loop Through Subnet Options    ${Field ID}    ${Field Value}
    ...         ELSE    Run Keywords    Set Test Variable   ${Comment}   Should Accept ${TEST NAME} "${Field Value}"    AND   Test Input   ${Field ID}   ${Field Value}
    Wait Until Page Does Not Contain    ${Update Success Msg}

Test Input
    [Arguments]   ${Field ID}   ${Field Value}
    Run Keyword if    "${Field Value}"=="${EMPTY}"    Clear Text Field    ${Field ID}
    ...       ELSE    Input Text      ${Field ID}   ${Field Value}
    Submit Global Changes   ACCEPT
    Wait For Loading Wheel To Disappear And Reload
    # Changing IP address logs you out, so you have to log back in
    Run Keyword If    '${TEST NAME}'=='Valid IP Address'    Login And Go To Global Settings
    Wait Until Element Is Visible   ${UIC-5 Global Settings Tab}
    Sleep   0.5s
    Mouse Over    ${UIC-5 Global Settings Tab}
    Click Element   ${UIC-5 Global Settings Tab}
    Wait Until Element Is Visible   ${Field ID}
    ${New Field Value}=   Get Value   ${Field ID}
    Run Keyword If    "${New Field Value}"!="${Field Value}"     Run Keywords   Log   ${Field Value}    AND   Fail    Test value did not save

Test Checkbox
    [Arguments]   ${Field ID}
    Set Test Variable   ${Comment}    Checkbox "${Field ID}" should accept check/uncheck
    Click Element   ${Field ID}
    Submit Global Changes   ACCEPT
    Wait For Loading Wheel To Disappear And Reload
    Wait Until Element Is Visible   ${UIC-5 Global Settings Tab}
    Mouse Over    ${UIC-5 Global Settings Tab}
    Sleep   0.4s
    Click Element   ${UIC-5 Global Settings Tab}
    Sleep   0.2s
    Wait Until Element Is Visible   ${Field ID}
    Click Element   ${Field ID}
    Submit Global Changes   ACCEPT
    Wait For Loading Wheel To Disappear And Reload

Loop Through Subnet Options
    [Arguments]   ${Field ID}   ${Subnet Values}
    :FOR    ${Value}    IN    @{Subnet Values}
    \   ${GUI Value}=   Get Value    ${Field ID}
    \   Run Keyword If    '${GUI Value}'=='${Value}'    No Operation
    \   ...         ELSE    Run Keywords    Log To Console    \nTesting ${Value}   AND   Test Input    ${Field ID}   ${Value}

Login And Go To Global Settings
    Set Test Variable   ${LOGIN URL}    ${LOGIN URL ALT}
    Login User    ${VALID USER}   ${VALID PASSWORD}
    Go To Global Settings Page

# Use backspace key to clear field,
# because using ${EMPTY} string and Clear Element Text does not trigger as a value change in GUI
Clear Text Field
    [Arguments]   ${Field ID}
    # Add some text so we can delete it and test for empty
    Input Text    ${Field ID}   someTextToDelete
    Submit Global Changes   ACCEPT
    Wait For Loading Wheel To Disappear And Reload
    Sleep   2s
    Click Element   ${UIC-5 Global Settings Tab}
    Wait Until Element Is Visible   ${Field ID}
    Double Click Element    ${Field ID}
    Double Click Element    ${Field ID}
    Press Key   ${Field ID}   ${Backspace Key}

# Generate a valid gateway to test alongside a valid IP
Generate Gateway Address From IP
    [arguments]   ${Test IP Address}
    ${IP Beginning}=    Get Substring   ${Test IP Address}    0   -4
    ${IP Ending}=    Get Substring    ${Test IP Address}    -3
    ${Gateway Ending}=    Evaluate    random.randint(1, 254)   random
    Run Keyword If   '${Gateway Ending}'=='${IP Ending}'    Set Test Variable   ${Gateway Ending}   ${IP Ending}-1
    ${New Gateway}=   Catenate    SEPARATOR=.   ${IP Beginning}   ${Gateway Ending}
    Run Keyword If    '${TEST NAME}'=='Valid IP Address'    Run Keywords
    ...     Set Test Variable   ${Comment}   Should Accept ${TEST NAME} "${Test IP Address}"    AND
    ...     Input Text    ${defaultGateway}   ${New Gateway}   AND
    ...     Sleep   2s
    ...     ELSE IF    '${TEST NAME}'=='Valid Gateway'    Run Keywords
    ...     Set Test Variable   ${Field Value}    ${New Gateway}    AND
    ...     Set Test Variable   ${Comment}   Should Accept ${TEST NAME} "${New Gateway}"

Wait For Loading Wheel To Disappear And Reload
    Wait Until Keyword Succeeds   2 min    5 sec   Element Should Not Be Visible    class=modal
    # Keep reloading to clear the connection error page(for name changes)  and start GUI again
    :FOR    ${i}    IN RANGE    10
    \   Run Keyword If    "${TEST NAME}"=="Valid IP Address"   Go To   ${LOGIN URL ALT}
    \   ...         ELSE      Reload Page
    \   ${Page Loaded}=   Run Keyword And Return Status   Wait Until Page Contains   Welcome to Codan UIC-5
    \   Exit For Loop If    ${Page Loaded}

Global Valid Suite Setup
    Setup Suite To Global Settings
    Click Global Settings And Expand
    Cancel Changes
    Sleep   3s
    ${ipVisible}=   Run Keyword And Return Status   Element Should Be Visible   ${ipv4}
    Run Keyword Unless    ${ipVisible}    Run Keywords
    ...   Mouse Over    ${UIC-5 Global Settings Tab}    AND
    ...   Click Element   ${UIC-5 Global Settings Tab}
    # save current values to restore later
    Wait Until Element Is Visible   ${ipv4}
    ${Old Name}=    Wait Visible Get Value   ${uicName}
    ${Old Description}=   Wait Visible Get Value   ${uicDesc}
    ${Old Subnet}=    Wait Visible Get Value   ${subnetMask}
    ${Old NTP}=   Wait Visible Get Value   ${ntpuri}
    ${Old IP}=    Wait Visible Get Value   ${ipv4}
    Set Suite Variable    ${Old Name}
    Set Suite Variable    ${Old Description}
    Set Suite Variable    ${Old Subnet}
    Set Suite Variable    ${Old NTP}
    Set Suite Variable    ${Old IP}

Wait Visible Get Value
    [Arguments]   ${fieldID}
    ${fieldIsVisible}=    Run Keyword And Return Status   Wait Until Element Is Visible   ${fieldID}
    # click again in case of GUI hiccup
    Run Keyword Unless    ${fieldIsVisible}   Run Keywords
    ...   Click Global Settings And Expand    AND
    ...   ${fieldIsVisible}=    Run Keyword And Return Status   Wait Until Element Is Visible   ${fieldID}
    ${fieldValue}=    Get Value   ${fieldID}
    Return From Keyword   ${fieldValue}

Global Valid Suite Teardown
    Click Global Settings And Expand
    # restore the old values that were set before the test
    Input Text    ${uicName}    ${Old Name}
    Input Text    ${uicDesc}    ${Old Description}
    Input Text    ${subnetMask}   ${Old Subnet}
    Input Text    ${ntpuri}    ${Old NTP}
    Input Text    ${ipv4}    ${Old IP}
    Submit Global Changes   ACCEPT
    :FOR    ${i}    IN RANGE    5
    \   ${Page Loaded}=   Run Keyword And Return Status   Wait Until Page Contains   Welcome to Codan UIC-5
    \   Reload Page
    \   Exit For Loop If    ${Page Loaded}
    Teardown Suite
