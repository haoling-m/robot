*** Settings ***
Documentation     Navigation related resource file with reusable keywords and variables.
Library           Selenium2Library
Library           Collections
Library           DateTime
Library           OperatingSystem
Library           RequestsLibrary
Resource          properties.robot
Resource          utility_resource.robot
Resource          testrail_api_resource.robot

*** Variables ***
#Navigation Links
${navBar}                 mainnavbar
${homeMenu}               link=Home
${deviceMenu}             link=Device
${subrackMenu}            link=Subrack
${subrackFirmwareLink}    micro_firmware_upload
${AlarmsLink}             popupViewAlarms
${FirmwareUpdateLink}     firmware_upload
${IPSettingsLink}         popupEditNetwork
${ImportExportLink}       alone_popupImpConfig
${FactoryResetLink}       popupResetConfig
${HardwareLink}           popupMicroInfo
${StateLink}              popupStatusInfo
${RebootLink}             popupReboot
${radioChannel}           edit_radio_channel
${radioName}              trnsvr_generic_lbl
${fallbackRules}          edit_radio_failover
${deleteChanges}          mnfooter_can_lbl
${saveChanges}            mnfooterPubBtn
${confirmDeleteChanges}   pub_mes_can_ok
${confirmSaveChanges}     pub_mes_ok
${resetDeviceButton}      rsetbtnok
${confirmReset}           resetnowok

#Field IDs
${loginUsername}          lgn_uname
${loginPassword}          lgn_upassw
${loginButton}            lgn_submit
${passwordHintButton}     lgn_login
${passwordHintLabel}      login_hint_mess_lbl
${passwordHintMsg}        Password Hint:${SPACE}
${logoutLink}             nav_grp_user
${logoutButton}           nav_btn_logout
${adminButton}            //*[@id="nvbr_admin"]/a
${loginError}             login_err_mess_lbl
${passwordDialog}         gen-dialog-text
${passwordDialogValue}    Factory default password must be changed
${passwordDialogCancel}   gen-dialog-cancel
${eulaPage}               eula_main_view
${eulaPageOK}             eula-aggr_ok
${channelListContent}     channel_list_part
${pendingChangesMsg}      msg_pending_changes
${loadingSpinner}         spinner-state-text

*** Keywords ***
#Navigation Actions
Navigate To
    [Arguments]   ${field}
    Wait Visible Do Action    ${field}    click   ${clickable}

#Login Actions
Login Default User With Validation
    Login User With Validation    ${VALID USER}   ${VALID PASSWORD}

Login User With Validation
    [Arguments]    ${username}    ${password}
    Login User Without Validation    ${username}    ${password}
    Welcome Page Should Be Open

Login User Without Validation
    [Arguments]    ${username}    ${password}
    Input Text    ${loginUsername}    ${username}
    Input Text    ${loginPassword}    ${password}
    Click Button     ${loginButton}

Log Out User
    [Arguments]     ${loginURL}=${LOGIN URL}
    Click Element     ${logoutLink}
    Click Element    ${logoutButton}
    Login Page Should Be Open   5s  ${loginURL}

#Location Checks
Login Page Should Be Open
    [Arguments]    ${timeout}   ${loginURL}=${LOGIN URL}    ${addressCheck}=True
    Wait Until Page Contains Element    ${loginUsername}   ${timeout}
    Wait Until Page Contains Element    ${loginPassword}   ${timeout}
    Wait Until Page Contains Element    ${loginButton}     ${timeout}
    Run Keyword if  ${addressCheck}     Location Should Be    ${loginURL}

Login Should Have Failed
    Location Should Be    ${LOGIN URL}
    Wait Until Element Is Visible    ${loginError}

Welcome Page Should Be Open
    ${EulaPageOpen}=    Run Keyword and Return Status     EULA Page Is Open
    Run Keyword if    ${EulaPageOpen}       Wait Visible Do Action    ${eulaPageOK}    Click     ${clickable}
    ${PasswordDialogOpen}=    Run Keyword and Return Status     Password Dialog Is Open
    Run Keyword if    ${PasswordDialogOpen}     Wait Visible Do Action    ${passwordDialogCancel}    Click       ${clickable}
    Wait Until Element Is Visible   ${radioChannel}
    Wait Until Element Is Visible   ${radioName}

EULA Page Is Open
    Wait Until Element Is Visible  id=${eulaPage}
    Sleep   2s

Password Dialog Is Open
    Wait Until Element Is Visible  id=${passwordDialog}
    Element Should Contain      id=${passwordDialog}      ${passwordDialogValue}

Logged In
    Wait Until Element Is Visible   ${navBar}
    Wait Until Element Is Visible   ${logoutLink}

#Browser Actions
Open Browser To Login Page
    [Arguments]     ${loginURL}=${LOGIN URL}    ${browserDelay}=${DELAY}
    Log   ${BROWSER}
    Run Keyword If    '${BROWSER}'=='Firefox'   Run Keywords    Set Browser For Firefox   AND   Open Browser    ${loginURL}    ${BROWSER}
    ...     ELSE IF   '${BROWSER}'=='Ie'        Run Keywords    Create Webdriver    ${BROWSER}    AND   Go To   ${loginURL}
    ...     ELSE      Open Browser    ${loginURL}    ${BROWSER}
    Set Selenium Speed    ${browserDelay}
    Login Page Should Be Open   5s  ${loginURL}

Open Browser To Home Page
    [Arguments]     ${loginURL}=${LOGIN URL}
    Run Keyword If    '${Browser}'=='Firefox'   Set Browser For Firefox
    Open Browser To Login Page  ${loginURL}
    Login Default User With Validation

Log Out And Close Browser
    [Arguments]     ${loginURL}=${LOGIN URL}
    Reload Page
    ${PasswordDialogOpen}=    Run Keyword and Return Status     Password Dialog Is Open
    Run Keyword if    ${PasswordDialogOpen}     Wait Visible Do Action    ${passwordDialogCancel}    Click       ${clickable}
    ${loggedIn}=    Run Keyword and Return Status     Logged In
    Run Keyword if    ${loggedIn}    Log Out User   ${loginURL}
    Close Browser

#Modified Browser Actions
Open Download Location Modified Browser To Home Page
    Run Keyword if      '${BROWSER}'=='${CHROME}'      Open Download Location Modified Chrome Browser
    ...       ELSE IF   '${BROWSER}'=='${FIREFOX}'     Open Download Location Modified Firefox Browser
    ...       ELSE IF   '${BROWSER}'=='${INTERNETEXPLORER}'     Open Download Location Modified Ie Browser
    ...       ELSE      Open Browser To Home Page

Open Download Location Modified Chrome Browser
    Set Suite Variable    ${DOWNLOAD DIRECTORY}    ${OUTPUT DIR}\\config_download
    ${Chrome Options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${Prefs}=    Create Dictionary    download.default_directory=${DOWNLOAD DIRECTORY}
    Call Method    ${Chrome Options}    add_experimental_option    prefs    ${Prefs}
    Create Webdriver    ${CHROME}    chrome_options=${Chrome Options}
    Modified Browser Navigate To Home Page

Open Download Location Modified Firefox Browser
    Set Suite Variable    ${DOWNLOAD DIRECTORY}    C:\\AutomationDownload\\
    Set Suite Variable    ${FF Profile Directory}   ${CURDIR}\\..\\..\\firefoxProfile
    Create Directory    ${DOWNLOAD DIRECTORY}
    Set Browser For Firefox
    # Use the FF profile which has the download directory set
    Open Browser    ${LOGIN URL}    ${BROWSER}    desired_capabilities=${FF capabilities}   ff_profile_dir=${FF Profile Directory}
    Modified Browser Navigate To Home Page

Open Download Location Modified Ie Browser
    Set Suite Variable    ${DOWNLOAD DIRECTORY}    ${OUTPUT DIR}\\config_download
    Open Browser To Home Page

Modified Browser Navigate To Home Page
    [Arguments]     ${browserDelay}=${DELAY}
    Set Selenium Speed    ${browserDelay}
    Go To     ${LOGIN URL}
    Login Page Should Be Open   5s
    Login Default User With Validation

# Only working for FF versions < 48 for now...
# For versions >=48, driver should/must run with marionette enabled
Set Browser For Firefox
    ${ff capabilities}    Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys, selenium.webdriver
    Set To Dictionary    ${ff capabilities}    marionette=${False}
    Set Suite Variable    ${ff capabilities}

#Browser Actions with API Setup.
Set API and Open Browser To Home Page
    Set API Variables
    Open Browser To Home Page

Set API And Open Browser To Login Page
    Set API Variables
    Open Browser To Login Page

Set API And Open Download Location Modified Browser
    Set API Variables
    Open Download Location Modified Browser To Home Page
