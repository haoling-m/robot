*** Settings ***
Documentation     Invalid Change Password test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Admin    ${changePasswordLink}
Test Teardown     Teardown Test
Resource          ../resources/user_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***
Password Cannot Be Empty
    Set Test Variable           ${Comment}            ${TEST NAME}
    Password Cannot Be Empty    ${changePassword2}    ${changePasswordOK}   ${changePasswordError}    ${changePasswordErrorEmpty}

Password Shorter Then 8 Characters
    Set Test Variable                     ${Comment}          ${TEST NAME}
    Password Shorter Then 8 Characters    ${changePassword}   ${changePassword2}    ${changePasswordOK}   ${changePasswordError}    ${changePasswordErrorLength}

Password Longer Than 25 Characters
    Set Test Variable                     ${Comment}          ${TEST NAME}
    Password Longer Than 25 Characters    ${changePassword}   ${changePassword2}    ${changePasswordOK}   ${userErrorTooltip}    ${changePasswordErrorLong}

Passwords Do Not Match
    Set Test Variable         ${Comment}          ${TEST NAME}
    Passwords Do Not Match    ${changePassword}   ${changePasswordOK}   ${changePasswordError}    ${changePasswordErrorMatch}

Password Hint Cannot Be Empty
    Set Test Variable               ${Comment}          ${TEST NAME}
    Password Hint Cannot Be Empty   ${changePassword}   ${changePassword2}    ${changePasswordOK}   ${changePasswordError}    ${changePasswordErrorHintEmpty}

Password Hint Cannot Contain Password
    Set Test Variable                       ${Comment}          ${TEST NAME}
    Password Hint Cannot Contain Password   ${changePassword}   ${changePassword2}    ${changePasswordHint}   ${changePasswordOK}   ${changePasswordError}    ${changePasswordErrorHintMatch}
