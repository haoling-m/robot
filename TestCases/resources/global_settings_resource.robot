*** Settings ***
Documentation     A resource to manage and manipulate global settings
Resource          navigation_resource.robot

*** Variables ***
### Buttons ###
${UIC-5 Global Settings Tab}      //*[@id="accordionHeaderPreferences"]/a
${Global Submit Button}           btnUpdate
${Accordion Content}              content

### Field Values ###
${uicName}                        uicName
${uicDesc}                        uicDesc
${dhcp}                           dhcp
${ipv4}                           ipv4
${subnetMask}                     subnetMask
${defaultGateway}                 defaultGateway
${ntpuri}                         ntpuri
${priorityOverride}               priorityOverride

### Input Values ###
# INVALID
${addressHasLetter}               192.168.000.0a
${addressHasSymbol}               192.168.000.0%
${addressOutsideRange}            192.123.123.256
${addressTooManyDigits}           192.123.123.1234
${invalidGatewayWithIP}           192.168.123.255
${addressAt255}                   192.168.66.255
${addressAt0}                     192.168.66.0
# VALID
@{SubnetMaskOptions}              255.255.255.0   255.255.255.128
${Test NTP}                       129.6.15.32

### MISC ###
${Backspace Key}                  \\08
${Global Update Success Msg}      Server Settings successfully updated
${disabled}                       disabled
# Use in Valid Global to restore values
${Old Name}
${Old Description}
${Old Subnet}
${Old NTP}
${Old IP}

*** Keywords ***
Click Global Settings And Expand
    ${treeButtonVisible}=   Run Keyword And Return Status   Wait Until Element Is Visible   ${Global Settings Tree Button}
    Run Keyword Unless    ${treeButtonVisible}    Run Keywords
    ...   Reload Page   AND
    ...   Wait Until Element Is Visible   ${Global Settings Tree Button}
    Click Element   ${Global Settings Tree Button}
    ${globalTabVisible}=    Wait Until Element Is Visible     ${UIC-5 Global Settings Tab}
    Run Keyword Unless    ${globalTabVisible}   Run Keywords
    ...   Reload Page   AND
    ...   Wait Until Element Is Visible   ${UIC-5 Global Settings Tab}
    Sleep   1s
    Mouse Over                        ${UIC-5 Global Settings Tab}
    Click Element                     ${UIC-5 Global Settings Tab}
    Wait Until Element Is Visible     ${Accordion Content}
    Wait Until Element is Visible     ${Global Submit Button}

Submit Global Changes
    [Arguments]   ${alertChoice}
    Wait Until Element Is Visible     ${Global Submit Button}
    ${btnDisabled}=   Get Element Attribute   ${Global Submit Button}   disabled
    Run Keyword Unless    '${btnDisabled}'=='true'    Run Keywords
    ...   Click Button    ${Global Submit Button}   AND
    ...   Handle Alert    ${alertChoice}
    Capture Page Screenshot
