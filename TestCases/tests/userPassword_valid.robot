*** Settings ***
Documentation     Valid Change Password test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Admin    ${addUserLink}
Test Teardown     Teardown Test
Library           String
Resource          ../resources/user_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***
Change Password
    # create a test user
    ${ranUsername}=   Generate Random String    8   [LOWER]
    ${ranPassword}=   Generate Random String    8   [LETTERS][NUMBERS]
    ${ranHint}=       Generate Random String    8   [LETTERS]
    Add New Valid User    ${ranUsername}    ${ranPassword}    ${ranHint}    ${roleAdmin}
    Log Out User
    Login User With Validation    ${ranUsername}    ${ranPassword}
    # change test user's password
    Navigate To Admin    ${changePasswordLink}
    Update Password   ${changePasswordMin}    ${editUserHintMin}
    Set Test Variable   ${Comment}    Update user ${ranUsername}'s password with new password: ${changePasswordMin}, new hint: ${editUserHintMin}
    Log Out User
    # log in with test user's changed password
    Password Hint Matches   ${ranUsername}   ${editUserHintMin}
    Login User With Validation    ${ranUsername}   ${changePasswordMin}
    Log Out User
    # log back into default user to delete the test user
    Login Default User With Validation
    Navigate To Admin    ${deleteUserLink}
    Delete User     ${ranUsername}
    Log Out User

*** Keywords ***
Update Password
    [Arguments]    ${newPassword}   ${newPasswordHint}
    Wait Visible Do Action        ${changePassword}        ${newPassword}        ${textBox}
    Wait Visible Do Action        ${changePassword2}       ${newPassword}        ${textBox}
    Wait Visible Do Action        ${changePasswordHint}    ${newPasswordHint}    ${textBox}
    Wait Visible Do Action        ${changePasswordOK}      Click                 ${clickable}
    Wait Until Element Contains   ${changePasswordError}   ${changePasswordSuccess}
