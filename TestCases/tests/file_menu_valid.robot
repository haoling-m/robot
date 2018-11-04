*** Settings ***
Documentation     A test suite for checking validity of file menu.
Suite Setup       Valid File Suite Setup
Suite Teardown    Valid File Suite Teardown
Test Teardown     Valid File Test Teardown
Resource          ../resources/file_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot
Resource          ../resources/utility_resource.robot
Library           OperatingSystem

*** Test Cases ***
Valid File Save Configuration
    Set Test Variable   ${Comment}    File Save should save configuration file
    Run Keyword If      '${BROWSER}'=='${INTERNETEXPLORER}'    Download For Ie
    ...       ELSE       Download For Chrome and Firefox
    Sleep   1s
    Check If File Downloaded

Valid File Upload Configuration
    Set Test Variable   ${Comment}    File Upload should provide browse option to upload config file
    Navigate To File Commands   Upload Config
    Wait Until Element Is Visible    uploadedfile
    Choose File   uploadedfile    ${Download Directory}\\${Config File Name}
    Click Element   ${File Upload Submit Button}
    Wait For Loading Wheel To Disappear And Reload
    Sleep   1s
    Element Should Contain    ${Update Status}    Success

Valid File Factory Reset
    Set Test Variable   ${Comment}    Factory Reset should have warning and confirmation popup
    Navigate To File Commands   Factory Reset
    Confirm Popup   Erase Configuration
    Click Element   ${Popup Confirm Button}
    Wait For Loading Wheel To Disappear And Reload
    Login Page Should Be Open
    Login User    ${VALID USER}   ${VALID PASSWORD}
    Go To Global Settings Page

Valid File Restart Radio System
    Set Test Variable   ${Comment}    Restart Radio should have warning and confirmation popup
    Navigate To File Commands   Restart Radio System
    Confirm Popup   OK
    Click Element   ${Popup Confirm Button}
    Sleep   5s
    Go To Global Settings Page

Valid File Reboot Controller
    Set Test Variable   ${Comment}    Reboot Controller should have warning and confirmation popup
    Navigate To File Commands   Reboot Controller
    Confirm Popup   OK
    Click Element   ${Popup Confirm Button}
    Wait For Loading Wheel To Disappear And Reload
    Go To Global Settings Page

Valid File Cancel Changes
    Set Test Variable   ${Comment}    Cancel Changes should have warning and confirmation popup
    Navigate To File Menu   Cancel Changes
    Confirm Popup   OK
    Cancel Popup

Valid Save Changes
    Set Test Variable   ${Comment}    Save Changes should have warning and confirmation popup
    Navigate To File Menu   Save Changes
    Confirm Popup   Save
    Cancel Popup

Valid File Logout
    Set Test Variable   ${Comment}    File Logout should logout and bring user to log in screen
    Navigate To File Menu   Logout
    Login Page Should Be Open

*** Keywords ***
Confirm Popup
    [Arguments]   ${Button Text}
    Wait Until Element Is Visible   ${Change Confirm Popup}
    Element Text Should Be          ${Popup Confirm Button}    ${Button Text}

Download For Chrome and Firefox
    Navigate To File Commands   Save Config
    ${Pending Changes Popup}=   Run Keyword And Return Status   Wait Until Element Is Visible   class=ui-dialog   timeout=1s
    Run Keyword If    ${Pending Changes Popup}    Click Element   ${Popup Confirm Button}

Download For Ie
    # use Get request to download because the download dialog for IE can't be interacted with
    ${Header}=        Create Dictionary     Content-Type=application/sql
    Create Session    downloadConfig        http://${SERVER}/   headers=${Header}   verify=True
    ${Response}=      Get Request           downloadConfig   p25/php/commands/getXMLConfig.php   headers=${Header}
    Should be Equal As Strings    ${Response.status_code}   200
    Create Binary File   ${Download Directory}\\${Config File Name}   ${Response.content}
