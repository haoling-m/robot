*** Settings ***
Documentation     A resource to navigate and the file menu.
Resource          navigation_resource.robot

*** Variables ***
# Buttons
${File Button}                    //*[@id="smoothmenu-ajax"]/ul/li[1]/a
${File Menu}                      //*[@id="smoothmenu-ajax"]/ul/li[1]/ul
${Commands Button}                //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[1]/a
${Commands Menu}                  //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[1]/ul
${Save Config Button}             //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[1]/ul/li[1]/a
${File Logout Button}             //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[4]/a
${File Upload Config Button}      //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[1]/ul/li[2]/a
${File Upload Submit Button}      //*[@id="divAccordion"]/div/form/table/tbody/tr[3]/td[2]/input
${Set Time Button}                //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[1]/ul/li[3]/a
${Factory Reset Button}           //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[1]/ul/li[4]/a
${Restart Radio Button}           //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[1]/ul/li[5]/a
${Reboot Controller Button}       //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[1]/ul/li[6]/a
${File Cancel Changes Button}     //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[2]/a
${File Save Changes Button}       //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[3]/a
${File Logout Button}             //*[@id="smoothmenu-ajax"]/ul/li[1]/ul/li[4]/a
${Popup OK Button}                /html/body/div[12]/div[3]/div/button[1]

# Popups
${Change Confirm Popup}           class=ui-helper-clearfix
${Popup Close Button}             class=ui-dialog-titlebar-close
${Popup Confirm Button}           class=ui-button-text
${Update Status}                  slaveServer_status
${Config File Name}               p25configuration.sql

*** Keywords ***
Cancel Popup
    Page Should Contain             Cancel
    Click Element                   ${Popup Close Button}

Valid File Suite Setup
    Set API Variables
    Run Keyword If    '${BROWSER}'=='${CHROME}'    Set Chrome Download Directory
    ...       ELSE IF   '${BROWSER}'=='${FIREFOX}'    Set Firefox Download Directory
    ...       ELSE IF   '${BROWSER}'=='${INTERNETEXPLORER}'      Set Ie Download Directory
    ...         ELSE      Open New Browser
    Navigate Browser To Login Page
    Login User                       ${VALID USER}   ${VALID PASSWORD}
    Wait Until Page Contains         ${TreeTitle}
    Wait Until Element Is Visible    ${Global Settings Tree Button}
    #Clicking will get past the change password prompt
    Click Element                    ${Global Settings Tree Button}

Valid File Suite Teardown
    Remove Directory    ${Download Directory}   recursive=${TRUE}
    Teardown Suite

Valid File Test Teardown
    #Sleep so the menu fully clears
    Sleep   1s
    Teardown Test

Open New Browser
    Run Keyword If    '${BROWSER}'=='${FIREFOX}'   Create For Firefox
    ...       ELSE    Create Webdriver    ${BROWSER}
    Go To   ${LOGIN URL}

Set Chrome Download Directory
    Set Suite Variable    ${Download Directory}    ${CURDIR}\\Downloads\\${SUITE_NAME}
    ${Chrome Options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${Prefs}=    Create Dictionary    download.default_directory=${Download Directory}
    Call Method    ${Chrome Options}    add_experimental_option    prefs    ${Prefs}
    Create Webdriver    Chrome    chrome_options=${Chrome Options}

Set Firefox Download Directory
    Set Suite Variable    ${Download Directory}    C:\\AutomationDownload\\
    Set Suite Variable    ${FF Profile Directory}   ${CURDIR}\\..\\..\\firefoxProfile
    Create Directory    ${Download Directory}
    ${FF capabilities}    Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys, selenium.webdriver
    Set To Dictionary    ${FF capabilities}    marionette=${False}
    # Use the FF profile which has the download directory set
    Open Browser    ${LOGIN URL}    ${BROWSER}    desired_capabilities=${FF capabilities}   ff_profile_dir=${FF Profile Directory}

Set Ie Download Directory
    Set Suite Variable    ${Download Directory}    ${CURDIR}\\Downloads\\${SUITE_NAME}
    Open New Browser

Check If File Downloaded
    Run Keyword If    '${BROWSER}'=='${FIREFOX}'     File Should Exist   C:\\AutomationDownload\\${Config File Name}
    ...       ELSE    File Should Exist   ${CURDIR}\\Downloads\\${SUITE_NAME}\\${Config File Name}

### Navigation ###
Open File Menu
    Capture Page Screenshot
    Run Keyword If    '${BROWSER}'=='${INTERNETEXPLORER}'    Mouse Over   ${File Button}
    ...         ELSE    Click Element    ${File Button}
    Wait Until Element Is Visible    ${File Menu}
    # Sleep while dropdown animates
    Sleep    0.5s

Click Commands
    Wait Until Element Is Visible   ${Commands Button}
    Run Keyword If    '${BROWSER}'=='${INTERNETEXPLORER}'    Mouse Over   ${Commands Button}
    ...         ELSE    Click Element    ${Commands Button}
    Wait Until Element Is Visible   ${Commands Menu}
    Run Keyword If    '${BROWSER}'=='${INTERNETEXPLORER}'    Mouse Over   ${Save Config Button}
    Capture Page Screenshot

Check If File Menu Open
    ${File Menu Open}=    Run Keyword And Return Status   Element Should Be Visible   ${File Menu}
    Run Keyword Unless    ${File Menu Open}==True    Open File Menu
    Run Keyword If    '${BROWSER}'=='${INTERNETEXPLORER}'    Mouse Over   ${Commands Button}
    Capture Page Screenshot

Check If Commands Menu Open
    Check If File Menu Open
    ${Commands Menu Open}=    Run Keyword And Return Status   Element Should Be Visible   ${Commands Menu}
    Run Keyword Unless    ${Commands Menu Open}==True     Click Commands
    Mouse Over    ${Save Config Button}
    Capture Page Screenshot

Navigate To File Commands
    [Arguments]   ${Location}
    Check If Commands Menu Open
    Run Keyword If    '${Location}'=='Save Config'            Click Element    ${Save Config Button}
    ...    ELSE IF    '${Location}'=='Upload Config'          Click Element    ${File Upload Config Button}
    ...    ELSE IF    '${Location}'=='Set Time'               Click Element    ${Set Time Button}
    ...    ELSE IF    '${Location}'=='Factory Reset'          Click Element    ${Factory Reset Button}
    ...    ELSE IF    '${Location}'=='Restart Radio System'   Click Element    ${Restart Radio Button}
    ...    ELSE IF    '${Location}'=='Reboot Controller'      Click Element    ${Reboot Controller Button}
    Capture Page Screenshot

Navigate To File Menu
    [Arguments]   ${Location}
    Check If File Menu Open
    Run Keyword If    '${Location}'=='Save Changes'     Click Element    ${File Save Changes Button}
    ...    ELSE IF    '${Location}'=='Cancel Changes'   Click Element    ${File Cancel Changes Button}
    ...    ELSE IF    '${Location}'=='Logout'           Click Element    ${File Logout Button}
    Capture Page Screenshot

Wait For Loading Wheel To Disappear And Reload
    Wait Until Keyword Succeeds   2 min    5 sec   Element Should Not Be Visible    class=modal
    # Keep reloading to clear the connection error page and start GUI again
    :FOR    ${i}    IN RANGE    10
    \   ${Page Loaded}=   Run Keyword And Return Status   Wait Until Page Contains   Welcome to Codan UIC-5
    \   Reload Page
    \   Exit For Loop If    ${Page Loaded}
    Reload Page
    Capture Page Screenshot
