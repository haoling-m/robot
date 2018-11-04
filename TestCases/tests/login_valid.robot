*** Settings ***
Documentation     Valid Login test case suite.
Suite Setup       Set API And Open Browser To Login Page
Suite Teardown    Teardown Suite
Test Template     Valid Login
Test Teardown     Teardown Test
Resource          ../resources/testrail_api_resource.robot
Resource          ../resources/navigation_resource.robot

*** Test Cases ***    USER NAME             PASSWORD
Valid Login 01        ${VALID USER}         ${VALID PASSWORD}
Valid Login 02        ${VALID USER}         ${VALID PASSWORD}
Valid Login 03        ${VALID USER}         ${VALID PASSWORD}
Valid Login 04        ${VALID USER}         ${VALID PASSWORD}
Valid Login 05        ${VALID USER}         ${VALID PASSWORD}
Valid Login 06        ${VALID USER}         ${VALID PASSWORD}
Valid Login 07        ${VALID USER}         ${VALID PASSWORD}
Valid Login 08        ${VALID USER}         ${VALID PASSWORD}
Valid Login 09        ${VALID USER}         ${VALID PASSWORD}
Valid Login 10        ${VALID USER}         ${VALID PASSWORD}

*** Keywords ***
Valid Login
    [Arguments]    ${username}    ${password}
    Set Test Variable   ${Comment}    ${TEST NAME} - Username: ${username}, Password: ${password}
    Login User With Validation    ${username}    ${password}
    Log Out User
