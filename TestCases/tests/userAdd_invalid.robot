*** Settings ***
Documentation     Invalid Add User test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Admin    ${addUserLink}
Test Teardown     Teardown Test
Resource          ../resources/user_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***
Username Cannot Be Empty
    Set Test Variable        ${Comment}    ${TEST NAME}: ${SPACE}
    Wait Visible Do Action   ${addUser}   ${SPACE}    ${textBox}
    Edit Should Fail         ${addUserOK}   ${addUserError}    ${addUserErrorEmpty}

Username Shorter Then 4 Characters
    Set Test Variable        ${Comment}    ${TEST NAME}: ${addUserLow}
    Wait Visible Do Action   ${addUser}   ${addUserLow}    ${textBox}
    Edit Should Fail         ${addUserOK}   ${addUserError}    ${addUserErrorEmpty}

Username Longer Than 25 Characters
    Set Test Variable        ${Comment}    ${TEST NAME}: ${addUserLong}
    Wait Visible Do Action   ${addUser}   ${addUserLong}    ${textBox}
    Element Should Contain   ${userErrorTooltip}    ${addUserErrorLong}

Username Contains Specials Characters
    Set Test Variable        ${Comment}    ${TEST NAME}: ${addUserFormat}
    Wait Visible Do Action   ${addUser}   ${addUserFormat}    ${textBox}
    Edit Should Fail         ${addUserOK}   ${addUserError}    ${addUserErrorSpaceFormat}

Username Contains Space Characters
    Set Test Variable        ${Comment}    ${TEST NAME}: ${addUserSpace}
    Wait Visible Do Action   ${addUser}   ${addUserSpace}    ${textBox}
    Edit Should Fail         ${addUserOK}   ${addUserError}    ${addUserErrorSpaceFormat}

Username Already Exists
    Set Test Variable        ${Comment}    ${TEST NAME}: ${VALID USER}
    Wait Visible Do Action   ${addUser}   ${VALID USER}    ${textBox}
    Wait Visible Do Action   ${addPassword}    ${changePasswordMin}    ${textBox}
    Wait Visible Do Action   ${addPassword2}   ${changePasswordMin}    ${textBox}
    Wait Visible Do Action   ${addPasswordHint}    ${editUserHintMin}    ${textBox}
    Edit Should Fail         ${addUserOK}   ${addUserError}    ${addUserErrorExists}

Password Cannot Be Empty
    Set Test Variable        ${Comment}    ${TEST NAME}: ${changePasswordMin}
    Wait Visible Do Action   ${addUser}   ${addUserMin}    ${textBox}
    Password Cannot Be Empty    ${addPassword2}    ${addUserOK}   ${addUserError}    ${changePasswordErrorEmpty}

Password Shorter Then 8 Characters
    Set Test Variable                     ${Comment}    ${TEST NAME}: ${changePasswordLow}
    Wait Visible Do Action                ${addUser}   ${addUserMin}    ${textBox}
    Password Shorter Then 8 Characters    ${addPassword}   ${addPassword2}    ${addUserOK}   ${addUserError}    ${changePasswordErrorLength}

Password Longer Than 25 Characters
    Set Test Variable                     ${Comment}    ${TEST NAME}: ${changePasswordLong}
    Wait Visible Do Action                ${addUser}   ${addUserMin}    ${textBox}
    Password Longer Than 25 Characters    ${addPassword}   ${addPassword2}    ${addUserOK}   ${userErrorTooltip}    ${changePasswordErrorLong}

Passwords Do Not Match
    Set Test Variable         ${Comment}    ${TEST NAME}
    Wait Visible Do Action    ${addUser}   ${addUserMin}    ${textBox}
    Passwords Do Not Match    ${addPassword}   ${addUserOK}   ${addUserError}    ${changePasswordErrorMatch}

Password Hint Cannot Be Empty
    Set Test Variable               ${Comment}    ${TEST NAME}
    Wait Visible Do Action          ${addUser}   ${addUserMin}    ${textBox}
    Password Hint Cannot Be Empty   ${addPassword}   ${addPassword2}    ${addUserOK}   ${addUserError}    ${changePasswordErrorHintEmpty}

Password Hint Cannot Contain Password
    Set Test Variable                       ${Comment}    ${TEST NAME}
    Wait Visible Do Action                  ${addUser}   ${addUserMin}    ${textBox}
    Password Hint Cannot Contain Password   ${addPassword}   ${addPassword2}    ${addPasswordHint}   ${addUserOK}   ${addUserError}    ${changePasswordErrorHintMatch}
