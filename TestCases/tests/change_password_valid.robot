*** Settings ***
Documentation     A test suite for valid changing user password.
Suite Setup       Setup Suite To Global Settings
Suite Teardown    Teardown Suite
Test Setup        Change Password Valid Test Setup
Test Template     Password Valid
Test Teardown     Change Password Valid Test Teardown
Resource          ../resources/utility_resource.robot
Resource          ../resources/edit_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Variables ***
${newChangeHint}        a valid hint!
${newPasswordforHint}   newpasswordForHint!

*** Test Cases ***    ${OldPass Value}        ${NewPass Value}        ${Hint Value}                           ${Comment}
Valid New Password    ${VALID PASSWORD}       ${newChangePassword}    The password is ${newChangePassword}    Should accept valid password "${newChangePassword}"
Valid Password Hint   ${newChangePassword}    ${newPasswordforHint}   ${newChangeHint}                        Should accept valid password hint "${newChangeHint}"

*** Keywords ***
Password Valid
    [arguments]     ${OldPass Value}    ${NewPass Value}    ${Hint Value}   ${Comment}
    Set Test Variable    ${Comment}
    Navigate To Change Password
    Input Text      ${oldPassword}      ${ranPassword}
    Input Text      ${newPassword}      ${NewPass Value}
    Input Text      ${newPassword2}     ${NewPass Value}
    Input Text      ${passwordHint}     ${Hint Value}
    Click Element   ${Update Button}
    Wait Until Page Contains            ${Update Success Msg}
    Wait Until Page Does Not Contain    ${Update Success Msg}   10s
    Logout User
    Login Page Should Be Open
    Run Keyword If   '${TEST NAME}'=='Valid Password Hint'
    ...   Run Keywords
    ...   Input Text    ${USERNAME FIELD}   ${ranUsername}   AND
    ...   Click Element   ${PASSWORD HINT BUTTON}   AND
    ...   Sleep   1s   AND
    ...   Element Should Contain    ${PASSWORD HINT DIALOG}   ${Hint Value}
    Login User    ${ranUsername}   ${NewPass Value}
    Page Should Contain    ${TreeTitle}

Change Password Valid Test Setup
    Navigate To Add User
    ${ranUsername}=   Generate Random String    8   [LETTERS]
    ${ranPassword}=   Generate Random String    8   [LETTERS][NUMBERS]
    Set Suite Variable    ${ranUsername}
    Set Suite Variable    ${ranPassword}
    Add User    ${ranUsername}    ${ranPassword}    Administrator
    Log Out User
    Login User    ${ranUsername}    ${ranPassword}

Change Password Valid Test Teardown
    # Delete the user created in test setup
    Navigate To Delete User
    Select From List          ${Delete Users Dropdown}  ${ranUsername}
    Click Element             ${Delete Button}
    Wait Until Page Contains  ${User Delete Confirm Msg}
    Confirm Delete
    ${Delete Admin Confirm Msg}=   Run Keyword And Return Status   Page Should Contain   ${Admin Delete Confirm Msg}
    Run Keyword if    ${Delete Admin Confirm Msg}   Confirm Delete
    Sleep   0.2s
    Teardown Test
    Log Out User
    Login Page Should Be Open
    Login User    ${VALID USER}   ${VALID PASSWORD}
    Go To Global Settings Page
