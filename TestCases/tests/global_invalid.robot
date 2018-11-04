*** Settings ***
Documentation     Tests invalid global settings input
Suite Setup       Setup Suite To Global Settings
Suite Teardown    Teardown Suite
Test Setup        Click Global Settings And Expand
Test Template     Invalid Global
Test Teardown     Teardown Test
Resource          ../resources/global_settings_resource.robot
Resource          ../resources/testrail_api_resource.robot
Resource          ../resources/utility_resource.robot

*** Test Cases ***                        FIELD ID            FIELD VALUE
Invalid Name Empty                        ${uicName}          ${EMPTY}
Invalid Name Has 26 Characters            ${uicName}          ${26Character String}

Invalid Description Has 256 Characters    ${uicDesc}          ${256Character String}

Invalid IP Has Letter                     ${ipv4}             ${addressHasLetter}
Invalid IP Has Symbol                     ${ipv4}             ${addressHasSymbol}
Invalid IP Outside Range                  ${ipv4}             ${addressOutsideRange}
Invalid IP Too Many Digits                ${ipv4}             ${addressTooManyDigits}

Invalid Subnet Has Letter                 ${subnetMask}       ${addressHasLetter}
Invalid Subnet Has Symbol                 ${subnetMask}       ${addressHasSymbol}
Invalid Subnet Outside Range              ${subnetMask}       ${addressOutsideRange}
Invalid Subnet Too Many Digits            ${subnetMask}       ${addressTooManyDigits}

Invalid Gateway Has Letter                ${defaultGateway}   ${addressHasLetter}
Invalid Gateway Has Symbol                ${defaultGateway}   ${addressHasSymbol}
Invalid Gateway Outside Range             ${defaultGateway}   ${addressOutsideRange}
Invalid Gateway Too Many Digits           ${defaultGateway}   ${addressTooManyDigits}
Invalid Gateway Against IP Address        ${defaultGateway}   ${invalidGatewayWithIP}

Invalid NTP Has Letter                    ${ntpuri}           ${addressHasLetter}
Invalid NTP Has Symbol                    ${ntpuri}           ${addressHasSymbol}
Invalid NTP Outside Range                 ${ntpuri}           ${addressOutsideRange}
Invalid NTP Too Many Digits               ${ntpuri}           ${addressTooManyDigits}

*** Currently accepted in 3.0.19-15, need to fix in later version ***
Invalid IP .255                           ${ipv4}             ${addressAt255}
Invalid IP .0                             ${ipv4}             ${addressAt0}

*** Keywords ***
Invalid Global
    [Arguments]   ${Field ID}   ${Field Value}
    Wait Until Element Is Visible   ${Field ID}
    Set Test Variable   ${Comment}    Should Not Accept ${TEST NAME}: "${Field Value}"
    #If testing Empty, apply space value first to trigger validation
    Run Keyword if    "${Field Value}"=="${EMPTY}"    Input Text   ${Field ID}   ${SPACE}
    #If testing Gateway IP range, set default value for IP Address to test against
    Run Keyword if    "${TEST NAME}"=="Invalid Gateway Against IP Address"   Input Text   ${ipv4}    192.168.123.66
    Input Text      ${Field ID}   ${Field Value}
    Wait Until Element Is Visible     ${Global Submit Button}
    Click Button                      ${Global Submit Button}
    Wait Until Element Is Visible   ${errorMsg}
