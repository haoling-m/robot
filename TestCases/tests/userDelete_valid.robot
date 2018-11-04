*** Settings ***
Documentation     Valid User Delete test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Admin    ${addUserLink}
Test Teardown     Teardown Test
Resource          ../resources/user_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           String

*** Test Cases ***
Delete User
    ${ranUsername}=   Generate Random String    8   [LOWER]
    ${ranPassword}=   Generate Random String    8   [LETTERS][NUMBERS]
    ${ranHint}=       Generate Random String    8   [LETTERS]
    Set Test Variable   ${Comment}    Generate and delete user - name: ${ranUsername}, password: ${ranPassword}, hint: ${ranHint}
    Add New Valid User    ${ranUsername}   ${ranPassword}    ${ranHint}   ${roleUser}
    Log Out User
    Login User With Validation    ${ranUsername}   ${ranPassword}
    Log Out User
    Login Default User With Validation
    Navigate To Admin    ${deleteUserLink}
    Delete User     ${ranUsername}
    Log Out User
    Login User Without Validation    ${ranUsername}   ${ranPassword}
    Login Should Have Failed
