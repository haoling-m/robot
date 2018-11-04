*** Settings ***
Documentation     Invalid User Edit test case suite.
Suite Setup       Set API And Create Test User
Suite Teardown    Delete Test User And Teardown Suite
Test Setup        Navigate To Admin    ${editUserLink}
Test Teardown     Teardown Test
Resource          ../resources/user_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           String

*** Test Cases ***
Username Must Be Selected
    Set Test Variable   ${Comment}    ${TEST NAME}
    Wait Visible Do Action   ${editPassword}    ${changePasswordMin}    ${textBox}
    Wait Visible Do Action   ${editPassword2}   ${changePasswordMin}    ${textBox}
    Wait Visible Do Action   ${editPasswordHint}    ${editUserHintMin}    ${textBox}
    Edit Should Fail    ${editUserOK}   ${editUserError}    ${editUserErrorSelect}

Password Cannot Be Empty
    Set Test Variable           ${Comment}    ${TEST NAME}
    Select User To Edit
    Password Cannot Be Empty    ${editPassword2}    ${editUserOK}   ${editUserError}    ${changePasswordErrorEmpty}

Password Shorter Then 8 Characters
    Set Test Variable                     ${Comment}    ${TEST NAME}
    Select User To Edit
    Password Shorter Then 8 Characters    ${editPassword}   ${editPassword2}    ${editUserOK}   ${editUserError}    ${changePasswordErrorLength}

Passwords Do Not Match
    Set Test Variable         ${Comment}    ${TEST NAME}
    Select User To Edit
    Passwords Do Not Match    ${editPassword}   ${editUserOK}   ${editUserError}    ${changePasswordErrorMatch}

Password Hint Cannot Be Empty
    Set Test Variable               ${Comment}    ${TEST NAME}
    Select User To Edit
    Password Hint Cannot Be Empty   ${editPassword}   ${editPassword2}    ${editUserOK}   ${editUserError}    ${changePasswordErrorHintEmpty}

Password Hint Cannot Contain Password
    Set Test Variable                       ${Comment}    ${TEST NAME}
    Select User To Edit
    Password Hint Cannot Contain Password   ${editPassword}   ${editPassword2}    ${editPasswordHint}   ${editUserOK}   ${editUserError}    ${changePasswordErrorHintMatch}

*** Keywords ***
Create Test User
    Open Browser To Home Page
    Navigate To Admin    ${addUserLink}
    ${ranUsername}=   Generate Random String    8   [LOWER]
    ${ranPassword}=   Generate Random String    8   [LETTERS][NUMBERS]
    ${ranHint}=       Generate Random String    8   [LETTERS]
    Set Suite Variable    ${ranUsername}
    Add New Valid User    ${ranUsername}   ${ranPassword}    ${ranHint}   ${roleUser}

Select User To Edit
    Select From List    ${editUser}   ${ranUsername}

Set API And Create Test User
    Set API Variables
    Create Test User

Delete Test User And Teardown Suite
    Navigate To Admin    ${deleteUserLink}
    Delete User     ${ranUsername}
    Teardown Suite
