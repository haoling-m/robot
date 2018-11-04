*** Settings ***
Documentation     Factory Reset of the Cascade device
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Teardown     Teardown Test
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Variables ***
${factoryResetBtn}        rsetbtnok
${radioChannelRange}      rad_setuprange_glb
${radioConfiguration}     reset_dev_config_mode
${radioMode}              reset_dev_dev_mode
${factoryResetConfirm}    resetnowok

*** Test Cases ***
Factory Reset
    Set Suite Variable    ${Comment}    Click Factory Reset and check that GUI reloads
    Navigate To Factory Reset Page
    Factory Reset
      # Allow the firmware enough time to flash unit and restart
    Login Page Should Be Open    5m
      # Make sure that the services are booted up prior to attempting to log in
    Sleep     5s
    Close Browser
    Open Browser To Home Page

*** Keywords ***
Navigate To Factory Reset Page
    Navigate To   ${deviceMenu}
    Navigate To   ${FactoryResetLink}

Factory Reset
    Wait Visible Do Action    ${radioMode}    True    ${dropdownList}
    Wait Visible Do Action    ${radioConfiguration}    standalone    ${dropdownList}
    Wait Visible Do Action    ${radioChannelRange}    2    ${dropdownList}
    Wait Visible Do Action    ${factoryResetBtn}    Click    ${clickable}
    Wait Visible Do Action    ${factoryResetConfirm}    Click     ${clickable}
