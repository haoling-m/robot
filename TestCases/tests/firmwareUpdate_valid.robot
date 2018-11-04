*** Settings ***
Documentation     Updates the firmware of the Cascade device
Test Setup        Open Browser To Home Page
Test Teardown     Log Out And Close Browser
Resource          ../resources/navigation_resource.robot

*** Variables ***
${updateFirmwareID}         upload-file-btn
${fileLocationID}           mngupdfile
${latestVersionID}          cascade_installer_version
${subrackStatusID}          infostatus_dialog
${loaderClass}              class=cs-loader

*** Test Cases ***
Upgrade Subrack Firmware
    Navigate To Subrack Firmware Update Page
    Update Firmware
    Sleep   2s
    Click Element   ${subrackFirmwareLink}
    Click Element   ${HardwareLink}
    Click Element   ${subrackFirmwareLink}

Upgrade Device Firmware
    Navigate To Firmware Update Page
    Update Firmware
    Check Device Update Finished
    Navigate To Firmware Update Page
    #Validate the version number is correct
    Wait Until Element Contains    ${latestVersionID}    ${EXPECTEDPATCHVERSION}

*** Keywords ***
Update Firmware
    Wait Until Keyword Succeeds     5s     1s		 Wait Until Element Is Visible    ${updateFirmwareID}
    Choose File     ${fileLocationID}         ${DFWFILENAME}
    #hacky I know but the uploaded file item doesn't display text
    Sleep     2s
    Click Element    ${updateFirmwareID}
    # Allow the firmware enough time to flash unit and restart
    Wait Until Keyword Succeeds   5m    10s   Wait Until Element Is Not Visible   ${loadingSpinner}

Check Device Update Finished
    ${loggedOut}=   Run Keyword And Return Status   Login Page Should Be Open    5m
    Run Keyword If    ${loggedOut}==False   Log Out User
    # Make sure that the services are booted up prior to attempting to log in
    Sleep     5s
    # Reset the device because configuration can get cleared right after update
    Login User Without Validation   ${VALID USER}   ${VALID PASSWORD}
    Wait Visible Do Action    ${deviceMenu}   click   ${clickable}
    Wait Visible Do Action    ${FactoryResetLink}   click   ${clickable}
    Wait Visible Do Action    ${resetDeviceButton}   click   ${clickable}
    Wait Visible Do Action    ${confirmReset}   click   ${clickable}
    Wait Until Keyword Succeeds   2m    10s   Wait Until Element Is Not Visible   ${loadingSpinner}
    Login Default User With Validation

Navigate To Firmware Update Page
    Navigate To   ${deviceMenu}
    Navigate To   ${FirmwareUpdateLink}

Navigate To Subrack Firmware Update Page
    Navigate To   ${subrackMenu}
    Navigate To   ${subrackFirmwareLink}
