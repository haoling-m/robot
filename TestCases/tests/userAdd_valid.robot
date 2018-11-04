*** Settings ***
Documentation     Valid Add User test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Admin    ${addUserLink}
Test Teardown     Teardown Test
Resource          ../resources/user_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           String

*** Test Cases ***
Add New User
    Set Test Variable   ${Comment}    ${TEST NAME}
    ${ranUsername}=   Generate Random String    8   [LOWER]
    ${ranPassword}=   Generate Random String    8   [LETTERS][NUMBERS]
    ${ranHint}=       Generate Random String    8   [LETTERS]
    Add New Valid User    ${ranUsername}   ${ranPassword}    ${ranHint}   ${roleUser}
    Log Out User
    Password Hint Matches   ${ranUsername}   ${ranHint}
    Login User With Validation    ${ranUsername}   ${ranPassword}
    Log Out User
    Login Default User With Validation
    Navigate To Admin    ${deleteUserLink}
    Delete User     ${ranUsername}
    Log Out User
