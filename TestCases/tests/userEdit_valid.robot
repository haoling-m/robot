*** Settings ***
Documentation     Valid Edit User test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Admin    ${addUserLink}
Test Teardown     Teardown Test
Resource          ../resources/user_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           String

*** Test Cases ***
Edit User
    ${ranUsername}=   Generate Random String    8   [LOWER]
    ${ranPassword}=   Generate Random String    8   [LETTERS][NUMBERS]
    ${ranHint}=       Generate Random String    8   [LETTERS]
    Add New Valid User    ${ranUsername}   ${ranPassword}    ${ranHint}   ${roleUser}
    Navigate To Admin    ${editUserLink}
    ${ranPassword2}=   Generate Random String    8   [LETTERS][NUMBERS]
    ${ranHint2}=       Generate Random String    8   [LETTERS]
    Set Test Variable   ${Comment}    Edit generated user - name: ${ranUsername}, pass: ${ranPassword}, hint: ${ranHint} with new pass: ${ranPassword2}, new hint: ${ranHint2}
    Edit Valid User    ${ranUsername}   ${ranPassword2}    ${ranHint2}   ${roleUser}
    Log Out User
    Password Hint Matches   ${ranUsername}   ${ranHint2}
    Login User With Validation    ${ranUsername}   ${ranPassword2}
    Log Out User
    Login Default User With Validation
    Navigate To Admin    ${deleteUserLink}
    Delete User     ${ranUsername}

*** Keywords ***
Edit Valid User
    [Arguments]   ${username}    ${password}   ${passwordHint}    ${role}
    Wait Until Element Is Visible   ${editUser}
    Select From List                ${editUser}           ${username}
    Wait Visible Do Action          ${editPassword}       ${password}        ${textBox}
    Wait Visible Do Action          ${editPassword2}      ${password}        ${textBox}
    Wait Visible Do Action          ${editPasswordHint}   ${passwordHint}    ${textBox}
    Wait Visible Do Action          ${editRole}           ${role}            ${dropdownList}
    Wait Visible Do Action          ${editUserOK}         Click              ${clickable}
    Wait Until Element Contains     ${editUserError}      ${editUserSuccess}
