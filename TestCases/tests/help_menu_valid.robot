*** Settings ***
Documentation     A test suite for checking validity of help menu.
Suite Setup       Setup Suite To Global Settings
Suite Teardown    Teardown Suite
Test Setup        Open Help Menu
Test Teardown     Teardown Test
Resource          ../resources/help_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot
Resource          ../resources/utility_resource.robot

*** Test Cases ***
Valid Version History
    Set Test Variable   ${Comment}    Version History should contain link to "Update Version" page
    Navigate To Version History
    Wait Until Element Is Visible    VersionHistory
    Page Should Contain Link         Update Version

Valid Codan Website
    Set Test Variable   ${Comment}    Codan Website page should have link to the Codan website
    Navigate To Codan Website
    ${url}=  Get Element Attribute   ${Web Link}    href
    Should Be Equal                  ${url}    ${LMR URL}

Valid Contact Us
    Set Test Variable   ${Comment}    Contact Us page should have contact info for within and outside North America
    Navigate To Contact Us
    Wait Until Page Contains         Toll Free for US and Canada
    Wait Until Page Contains         Outside of US and Canada

Valid License Agreement
    Set Test Variable   ${Comment}    License Agreement page should display the EULA
    Navigate To License Agreement
    Wait Until Page Contains         End User License Agreement
