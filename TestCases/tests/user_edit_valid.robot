*** Settings ***
Documentation     A test suite for valid editing a user
Suite Setup       User Edit Suite Setup
Suite Teardown    User Edit Suite Teardown
Test Setup        Navigate To Edit User
Test Teardown     Teardown Test
Resource          ../resources/utility_resource.robot
Resource          ../resources/edit_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Variables ***
${newUserEditPassword}            password!
${newUserEditHint}                a pass hint for user edit

*** Test Cases ***
Valid p25admin Password
    Valid Edit    ${VALID USER}     ${txtUserPassword1}     ${newUserEditPassword}
Valid p25admin Password Hint
    Valid Edit    ${VALID USER}     ${passwordHint}         ${newUserEditHint}
Valid TestUser Password
    Valid Edit    ${ranUsername}    ${txtUserPassword1}     ${newUserEditPassword}
Valid TestUser Password Hint
    Valid Edit    ${ranUsername}    ${passwordHint}         ${newUserEditHint}

*** Keywords ***
Valid Edit
    [arguments]   ${UserToEdit}   ${Field ID}   ${Field Value}
    Set Test Variable   ${Comment}    Editing "${UserToEdit}", should accept value "${Field Value}" into field "${Field ID}"
    Select From List By Value   ${Users Dropdown}    ${UserToEdit}
    Input Text         ${Field ID}   ${Field Value}
    Run Keyword if    '${Field ID}'=='${txtUserPassword1}'   Re-enter Password   ${Field Value}
    Click Element     ${Update Button}
    Wait Until Page Contains    ${Update Success Msg}
    Wait Until Page Does Not Contain    ${Update Success Msg}

Re-enter Password
    [arguments]   ${Field Value}
    Input Text      ${txtUserPassword2}   ${Field Value}
    Input Text      ${passwordHint}       The password is ${Field Value}
