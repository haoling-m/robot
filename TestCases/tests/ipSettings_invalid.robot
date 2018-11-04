*** Settings ***
Documentation     Invalid IP Settings test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Editable IP Settings
Test Template     Edit Should Fail
Test Teardown     Teardown Test
Resource          ../resources/ipSettings_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           Collections
Library           String

*** Test Cases ***              FIELD ID        FIELD VALUE         TOOLTIP ID          ERROR MSG
Invalid Format 01 IP Address    ${ipAddress}    ${ipv4Invalid1}     ${ipAddressErr}     ${ipAddressErrMsg}
Invalid Format 02 IP Address    ${ipAddress}    ${ipv4Invalid2}     ${ipAddressErr}     ${ipAddressErrMsg}
Invalid Format 03 IP Address    ${ipAddress}    ${ipv4Invalid3}     ${ipAddressErr}     ${ipAddressErrMsg}
Invalid Format 04 IP Address    ${ipAddress}    ${ipv4Invalid4}     ${ipAddressErr}     ${ipAddressErrMsg}

Invalid Format 01 Gateway       ${gateway}      ${ipv4Invalid1}     ${gatewayErr}       ${gatewayErrMsg}
Invalid Format 02 Gateway       ${gateway}      ${ipv4Invalid2}     ${gatewayErr}       ${gatewayErrMsg}
Invalid Format 03 Gateway       ${gateway}      ${ipv4Invalid3}     ${gatewayErr}       ${gatewayErrMsg}
Invalid Format 04 Gateway       ${gateway}      ${ipv4Invalid4}     ${gatewayErr}       ${gatewayErrMsg}

Invalid Format 01 NTP 1         ${ntp1}         ${ipv4Invalid1}     ${ntp1Err}          ${ntp1ErrMsg}
Invalid Format 02 NTP 1         ${ntp1}         ${ipv4Invalid2}     ${ntp1Err}          ${ntp1ErrMsg}
Invalid Format 03 NTP 1         ${ntp1}         ${ipv4Invalid3}     ${ntp1Err}          ${ntp1ErrMsg}
Invalid Format 04 NTP 1         ${ntp1}         ${ipv4Invalid4}     ${ntp1Err}          ${ntp1ErrMsg}

Invalid Format 01 NTP 2         ${ntp2}         ${ipv4Invalid1}     ${ntp2Err}          ${ntp2ErrMsg}
Invalid Format 02 NTP 2         ${ntp2}         ${ipv4Invalid2}     ${ntp2Err}          ${ntp2ErrMsg}
Invalid Format 03 NTP 2         ${ntp2}         ${ipv4Invalid3}     ${ntp2Err}          ${ntp2ErrMsg}
Invalid Format 04 NTP 2         ${ntp2}         ${ipv4Invalid4}     ${ntp2Err}          ${ntp2ErrMsg}

*** Keywords ***
Edit Should Fail
    [Arguments]   ${Field ID}   ${Field Value}    ${Tooltip ID}     ${Error Msg}
    Set Test Variable   ${Comment}    ${TEST NAME}: ${FIELD VALUE}
    Wait Visible Do Action   ${Field ID}   ${Field Value}   ${textBox}
    Wait Visible Do Action     ${confirmIP}    Click    ${clickable}
    Wait Until Element Is Visible   ${Tooltip ID}
    Wait Until Element Contains     ${Tooltip ID}   ${errMsg}
    Wait Until Element Is Visible   ${okErr}
    Wait Until Element Contains     ${okErr}        ${Error Msg}
