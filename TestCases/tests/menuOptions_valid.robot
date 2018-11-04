*** Settings ***
Documentation     Valid Menu Options test case suite.
Suite Setup       Config Based Set API And Open Download Location Modified Browser
Suite Teardown    Config Based Teardown Suite
Test Teardown     Config Based Teardown Test
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           ../resources/clipboard.py
Library           String
Library           OperatingSystem
Library           Collections

*** Variables ***
${alarmContent}             alarm_data_content
${alarmContentCopy}         copy_to_clipboard_alarms
${firmwareContent}          firware_data_content
${firmwareContentCopy}      copy_clipboard_firmware
${firmwareUpload}           upload-file
${IPSettingsContent}        popupEditNetworkdlg
${importContent}            upload-imported-file
${exportContent}            popupExpConfigdlg
${exportDownload}           mngexpsoft
${importFile}               imp-upd-file
${importUpload}             upload-imp_file-btn
${importOverlay}            adm_refresh_modal
${resetContent}             popupResetConfigdlg
${hardwareContent}          popupHwInfodlg
${hardwareFactoryAccess}    access-factory-btn
${stateContent}             status_data_content
${stateContentCopy}         cpytoclpbrd_state_info
${rebootContent}            popupRebootdlg
${rebootButton}             rebootdev
${rebootConfirmLbl}         rebootnowlbl
${rebootConfirmMsg}         Rebooting the device will result in the system functionality interruption.
${rebootConfirmButton}      rebootnowok
@{alarmNames}           Power amplifier high 48V   Power amplifier low 48V    Power amplifier current   Power amplifier temperature   Power amplifier output power  Power amplifier front panel   Power supply right side 48V   Power supply left side 48V    Power supply front panel    Transceiver high 48V    Transceiver low 48V   Transceiver current   Transceiver front panel   Power amplifier   Receiver 1pps   Receiver synthesizer    Transmitter reference frequency   Transmitter synthesizer   FSI
@{alarmStatuses}        ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""    ""
@{orderOfAlarmIDsInGIU}     16    15    18    17    19    10    11  12    13    14    01    02    03    04    05    06    07    08    09
@{alarmResults}
${popupMsg}               adm_pub_mess_modal_fail
${databaseErrMsg}         Save Operation failed, Database version mismatched
${savingChangeMsg}        Saving Changes..

#USED FOR CUSTOM CONFIG IMPORT GRADLE TASK
${CONFIGFILENAME}       ${EMPTY}

#If using IE - bypass the dialog prompt by enabling Programmatic clipboard access in Security Settings
*** Test Cases ***
Test Alarm Page Copy
    ${scrapedResults}=        Scrape Alarm Results
    Set Test Variable         ${scrapedResults}
    Compare Copied Content    ${homeMenu}   ${AlarmsLink}   ${alarmContentCopy}     ${alarmContent}

Test Firmware Page Copy
    Set Test Variable         ${Comment}      ${TEST NAME}: ${firmwareContentCopy} - ${firmwareContent}
    Compare Copied Content    ${deviceMenu}   ${FirmwareUpdateLink}   ${firmwareContentCopy}     ${firmwareContent}

# State Info Page Copy
#     Set Test Variable         ${Comment}    ${TEST NAME}: ${stateContentCopy} - ${stateContent}
#     Compare Copied Content    ${homeMenu}   ${StateLink}   ${stateContentCopy}     ${stateContent}

#Hardware Info Factory Access
#    Navigate To     ${deviceMenu}
#    Navigate To     ${HardwareLink}
#    Hardware Info Visible   False
#    Wait Visible Do Action      ${hardwareFactoryAccess}     click       ${clickable}
#    Hardware Info Visible   True

Export Configuration
    Set Test Variable   ${Comment}              ${TEST NAME}
    Export Configuration To Folder
    Remove Directory    ${DOWNLOAD DIRECTORY}   True

Import Configuration
    Run Keyword If  "${CONFIGFILENAME}"=="${EMPTY}"     Set Test Variable   ${Comment}   ${TEST NAME}
    Run Keyword If  "${CONFIGFILENAME}"=="${EMPTY}"     Export Configuration To Folder
    Import Configuration From Folder
    Run Keyword If  "${CONFIGFILENAME}"=="${EMPTY}"     Remove Directory    ${DOWNLOAD DIRECTORY}   True

Reboot Device
    Set Test Variable   ${Comment}   ${TEST NAME}
    Reboot Device and Test Login

*** Keywords ***
Confirm Menu Option Present
    [Arguments]   ${linkID}   ${contentID}
    Navigate To                     ${linkID}
    Wait Until Element Is Visible   ${contentID}

Compare Copied Content
    [Arguments]   ${navID}  ${linkID}   ${copyID}     ${contentID}
    Navigate To                   ${navID}
    Run Keyword If                '${BROWSER}'=='${INTERNETEXPLORER}'    Sleep   1s
    Navigate To                   ${linkID}
    Wait Visible Do Action        ${copyID}     click       ${clickable}
    ${pageData}=                  Get Text      ${contentID}
    Run Keyword If                '${TEST NAME}'=='Test Alarm Page Copy'    Set Test Variable   ${pageData}   ${scrapedResults}
    ${copiedData}=                Paste From Clipboard
    ${compressedPageData}=        Return Compressed String  ${pageData}           ${linkID}
    ${compressedCopiedData}=      Return Compressed String  ${copiedData}     ${linkID}
    Run Keyword If                '${TEST NAME}'=='State Info Page Copy'    Run Keywords    Set Test Variable   ${compressedCopiedData}   AND   Fix State Copy String
    Sleep                         2s
    Set Test Variable             ${Comment}    ${TEST NAME} - **Content copy**: ${compressedCopiedData} **Content**: ${compressedPageData}
    Should Be Equal As Strings    ${compressedCopiedData}       ${compressedPageData}

Return Compressed String
    [Arguments]   ${stringToCompress}    ${linkID}
    ${compressedString}         Convert To String   ${linkID}
    @{stringToCompressLines}=   Split To Lines   ${stringToCompress}
    :FOR    ${line}             IN      @{stringToCompressLines}
    \   ${line}=                Strip String   ${line}
    \   ${length}=              Get Length  ${line}
    \   Continue For Loop If    ${length}==0
    \   ${timeString}=          Run Keyword And Return Status   Should Start With   ${line}     Time
    \   Continue For Loop If    '${linkID}'=='${StateLink}' and ${timeString}
    \   ${compressedString}=    Catenate    ${compressedString}     ${line}
    [Return]    ${compressedString}

Scrape Alarm Results
    # Generate a list of alarm names and a list of alarm statuses with correspondings indexes
    Set Test Variable   ${alarmNameIndex}   1
    :FOR    ${name}    IN    @{alarmNames}
    \   Log                   ${alarmNameIndex}
    \   Run Keyword If        ${alarmNameIndex}<10    Set Test Variable   ${alarmResultID}    alarm_000${alarmNameIndex}_passed
    \   ...         ELSE      Set Test Variable   ${alarmResultID}    alarm_00${alarmNameIndex}_passed
    \   ${styleAttribute}=    Get Element Attribute   ${alarmResultID}   style
    \   ${listIndex}=         Evaluate    ${alarmNameIndex}-1
    \   Run Keyword If        '${styleAttribute}'==''   Set List Value    ${alarmStatuses}    ${listIndex}   Failed
    \   ...       ELSE        Set List Value    ${alarmStatuses}    ${listIndex}   Passed
    \   ${alarmNameIndex}=    Evaluate    ${alarmNameIndex}+1
    Log   ${alarmNames}
    Log   ${alarmStatuses}
    # Generate a final string of names and statuses by combining lists above
    :FOR    ${index}   IN    @{orderOfAlarmIDsInGIU}
    \   ${nameIndex}=     Convert To Integer    ${index}
    \   ${listIndex}=     Evaluate    ${nameIndex}-1
    \   ${alarmName}=     Get From List   ${alarmNames}   ${listIndex}
    \   Append To List    ${alarmResults}    ${alarmName}
    \   Append To List    ${alarmResults}    :
    \   ${alarmStatus}    Get From List   ${alarmStatuses}   ${listIndex}
    \   Append To List    ${alarmResults}    ${alarmStatus}
    ${alarmResults}       Convert To String   ${alarmResults}
    ${alarmResults}=      Remove String   ${alarmResults}    [   ]   '   ,
    ${alarmResults}=      Replace String    ${alarmResults}   ${SPACE}u   ${SPACE}
    ${alarmResults}=      Replace String    ${alarmResults}   ${SPACE}:${SPACE}   :${SPACE}
    ${alarmResults}=      Replace String    ${alarmResults}   uReceiver   Receiver
    Return From Keyword   ${alarmResults}

# Remove the space causing comparison to fail
Fix State Copy String
    ${compressedCopiedData}=    Replace String    ${compressedCopiedData}   No_Data Band lower limit (MHz) ${SPACE}:   No_Data Band lower limit (MHz) :    count=1
    Set Test Variable           ${compressedCopiedData}

Hardware Info Visible
    [Arguments]   ${isVisible}
    @{slotIDs}=     Create List   slot_0  slot_1  slot_2  slot_3  slot_4  slot_5  slot_6  slot_7
    :FOR    ${slotID}    IN    @{slotIDs}
    \    Run Keyword If    "${isVisible}"=="True"    Wait Until Element Is Visible    ${slotID}
    \     ...      ELSE    Wait Until Element Is Not Visible    ${slotID}

Export Configuration To Folder
    Navigate To       ${homeMenu}
    Run Keyword If    '${BROWSER}'=='${INTERNETEXPLORER}'   Download For Ie
    ...       ELSE    Run Keywords    Navigate To     ${ImportExportLink}   AND   Wait Visible Do Action  ${exportDownload}   click   ${clickable}
    Sleep   5s
    File Should Exist   ${DOWNLOAD DIRECTORY}\\cascade_config.sql

Import Configuration From Folder
    Navigate To     ${ImportExportLink}
    Wait Until Element Is Visible    ${importUpload}
    Run Keyword If  "${CONFIGFILENAME}"=="${EMPTY}"     Choose File     ${importFile}   ${DOWNLOAD DIRECTORY}\\cascade_config.sql
    ...       ELSE  Choose File     ${importFile}       ${CONFIGFILENAME}
    #hacky I know but the uploaded file item doesn't display text
    Sleep     5s
    Click Element                   ${importUpload}
    Wait Until Keyword Succeeds     2m      5s      Wait Until Element Is Visible   ${channelListContent}
    Wait Until Keyword Succeeds     2m      5s      Welcome Page Should Be Open
    Wait Visible Do Action    ${saveChanges}    click    ${clickable}
    Wait Visible Do Action    ${confirmSaveChanges}   click   ${clickable}
    ${popupExists}=   Run Keyword And Return Status   Wait Until Element Is Visible   ${popupMsg}
    Run Keyword If    ${popupExists}    Element Should Not Contain   ${popupMsg}    ${databaseErrMsg}
    Wait Until Keyword Succeeds     2m      5s      Wait Until Element Does Not Contain   ${loadingSpinner}    ${savingChangeMsg}

Reboot Device and Test Login
    Navigate To                   ${deviceMenu}
    Navigate To                   ${RebootLink}
    Wait Visible Do Action        ${rebootButton}           click   ${clickable}
    Wait Until Element Contains   ${rebootConfirmLbl}       ${rebootConfirmMsg}
    Wait Visible Do Action        ${rebootConfirmButton}    click   ${clickable}
    Login Page Should Be Open     2m
    # Make sure that the services are booted up prior to attempting to log in
    Close Browser
    Open Browser To Home Page

# use Get request to download because the download dialog for IE can't be interacted with
Download For Ie
    ${URL}=           Get Location
    ${token}=         Fetch From Right    ${URL}    token=
    ${Header}=        Create Dictionary     Content-Type=application/sql
    Create Session    downloadConfig        http://${SERVER}   headers=${Header}   verify=True
    ${Response}=      Get Request           downloadConfig   api/v3/system/cascade_config.sql?authorization=${token}    headers=${Header}
    Should be Equal As Strings    ${Response.status_code}   200
    Create Binary File   ${Download Directory}\\cascade_config.sql   ${Response.content}

Config Based Set API And Open Download Location Modified Browser
    Run Keyword If  "${CONFIGFILENAME}"=="${EMPTY}"     Set API And Open Download Location Modified Browser
    ...       ELSE  Open Browser To Home Page

Config Based Teardown Suite
    Run Keyword If  "${CONFIGFILENAME}"=="${EMPTY}"     Teardown Suite
    ...       ELSE  Log Out And Close Browser

Config Based Teardown Test
    Run Keyword If  "${CONFIGFILENAME}"=="${EMPTY}"     Teardown Test
    ...       ELSE  No Operation
