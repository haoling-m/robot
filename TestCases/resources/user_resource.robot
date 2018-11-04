*** Settings ***
Documentation     User related resource file with reusable keywords and variables.
Resource          properties.robot
Resource          utility_resource.robot
Resource          navigation_resource.robot
Library           Selenium2Library

*** Variables ***
#Field IDs
${userViewLink}                   popupuserList
${userViewTable}                  admin_user-list
${changePasswordLink}             popupChPass
${addUserLink}                    popupAddUser
${editUserLink}                   popupEditUser
${deleteUserLink}                 popupDelUser
${userErrorTooltip}               class=tooltip

${changePassword}                 newPassword
${changePassword2}                newPassword2
${changePasswordHint}             passwordHint
${changePasswordOK}               adm_passw_ch
${changePasswordError}            chpass_err_mess_lbl
${changePasswordErrorLong}        Max allowed characters are 25.
${changePasswordErrorEmpty}       Error: New password is not set.
${changePasswordErrorLength}      Password length must be at least 8 characters.
${changePasswordErrorMatch}       Error: New and re-entered passwords do not match.
${changePasswordErrorHintEmpty}   Error: Password hint is not set.
${changePasswordErrorHintMatch}   Error: Password hint must not contain password.
${changePasswordSuccess}          Success : Password changed successfully

${addUser}                        manadd_uname
${addPassword}                    manewPassword
${addPassword2}                   manewPassword2
${addPasswordHint}                mapasswordHint
${addRole}                        adu_select_role
${addUserOK}                      admin_add_user
${addUserError}                   adduser_err_mess_lbl
${addUserErrorEmpty}              Error : Username must be atleast 4 characters.
${addUserErrorSpaceFormat}        Error : No special characters or spaces allowed in username.
${addUserErrorExists}             Add user fail. User exists.
${addUserErrorLong}               ${changePasswordErrorLong}
${addUserSuccess}                 Success: User added successfully.

${editUser}                       adu_eselect_user
${editPassword}                   menewPassword
${editPassword2}                  menewPassword2
${editPasswordHint}               mepasswordHint
${editRole}                       adu_eselect_role
${editUserOK}                     adm_epassw_ch
${editUserError}                  editUser_err_mess_lbl
${editUserErrorSelect}            You must select a user to update
${editUserSuccess}                Success: User updated successfully.

${deleteUser}                     adu_dselect_user
${deleteUserOK}                   adm_dpassw_ch
${deleteUserConfirmTitle}         gen-dialog-title
${deleteUserConfirmTitleMsg}      Confirm User Delete
${deleteUserConfirmText}          gen-dialog-text
${deleteUserConfirmTextStart}     Are you sure you want to delete user
${deleteUserConfirmTextEnd}       ?
${deleteUserConfirmOK}            gen-dialog-confirm
${deleteUserSuccess}              delUser_err_mess_lbl
${deleteUserSuccessMsg}           Success: User deleted successfully.

#Input Values
#INVALID
${changePasswordLow}              1234567
${changePasswordLong}             12345678901234567890123456

${addUserLow}                     low
${addUserLong}                    ${changePasswordLong}
${addUserFormat}                  !@*(
${addUserSpace}                   Test Space

#VALID
${changePasswordMin}              12345678

${addUserMin}                     test

${editUserToSelect}               p25user
${editUserHintMin}                A

${roleUser}                       user
${roleAdmin}                      administrator

*** Keywords ***
Navigate To Admin
    [Arguments]                     ${testLocation}
    Click Element                   ${logoutLink}
    Click Element                   ${adminButton}
    Run Keyword If                  '${BROWSER}'=='Ie'    Sleep   1s
    Wait Until Element Is Visible   ${userViewLink}
    Click Element                   ${testLocation}

Edit Should Fail
    [Arguments]                   ${confirmButton}    ${errorID}    ${errorMsg}
    Wait Visible Do Action        ${confirmButton}    Click         ${clickable}
    Wait Until Element Contains   ${errorID}          ${errorMsg}

Password Cannot Be Empty
    [Arguments]              ${passwordField}   ${confirmButton}        ${errorID}    ${errorMsg}
    Wait Visible Do Action   ${passwordField}   ${changePasswordMin}    ${textBox}
    Edit Should Fail         ${confirmButton}   ${errorID}              ${errorMsg}

Password Shorter Then 8 Characters
    [Arguments]              ${passwordField}     ${passwordField2}       ${confirmButton}    ${errorID}    ${errorMsg}
    Wait Visible Do Action   ${passwordField}     ${changePasswordLow}    ${textBox}
    Wait Visible Do Action   ${passwordField2}    ${changePasswordLow}    ${textBox}
    Edit Should Fail         ${confirmButton}     ${errorID}              ${errorMsg}

Password Longer Than 25 Characters
    [Arguments]              ${passwordField}     ${passwordField2}       ${confirmButton}    ${errorID}    ${errorMsg}
    Wait Visible Do Action   ${passwordField}     ${changePasswordLong}   ${textBox}
    Element Should Contain    ${errorID}    ${errorMsg}

Passwords Do Not Match
    [Arguments]              ${passwordField}   ${confirmButton}        ${errorID}    ${errorMsg}
    Wait Visible Do Action   ${passwordField}   ${changePasswordLow}    ${textBox}
    Edit Should Fail         ${confirmButton}   ${errorID}              ${errorMsg}

Password Hint Cannot Be Empty
    [Arguments]              ${passwordField}    ${passwordField2}       ${confirmButton}    ${errorID}    ${errorMsg}
    Wait Visible Do Action   ${passwordField}    ${changePasswordMin}    ${textBox}
    Wait Visible Do Action   ${passwordField2}   ${changePasswordMin}    ${textBox}
    Edit Should Fail         ${confirmButton}    ${errorID}              ${errorMsg}

Password Hint Cannot Contain Password
    [Arguments]              ${passwordField}       ${passwordField2}       ${passwordHintField}    ${confirmButton}    ${errorID}    ${errorMsg}
    Wait Visible Do Action   ${passwordField}       ${changePasswordMin}    ${textBox}
    Wait Visible Do Action   ${passwordField2}      ${changePasswordMin}    ${textBox}
    Wait Visible Do Action   ${passwordHintField}   ${changePasswordMin}    ${textBox}
    Edit Should Fail         ${confirmButton}       ${errorID}              ${errorMsg}

Password Hint Matches
    [Arguments]   ${username}   ${expectedPasswordHint}
    Wait Visible Do Action        ${loginUsername}        ${username}   ${textBox}
    Wait Visible Do Action        ${passwordHintButton}   Click         ${clickable}
    Wait Until Element Contains   ${passwordHintLabel}    ${passwordHintMsg}${expectedPasswordHint}

Add New Valid User
    [Arguments]   ${username}    ${password}           ${passwordHint}    ${role}
    Wait Visible Do Action        ${addUser}           ${username}        ${textBox}
    Wait Visible Do Action        ${addPassword}       ${password}        ${textBox}
    Wait Visible Do Action        ${addPassword2}      ${password}        ${textBox}
    Wait Visible Do Action        ${addPasswordHint}   ${passwordHint}    ${textBox}
    Wait Visible Do Action        ${addRole}           ${role}            ${dropdownList}
    Wait Visible Do Action        ${addUserOK}         Click              ${clickable}
    Wait Until Element Contains   ${addUserError}      ${addUserSuccess}

Delete User
    [Arguments]   ${userToDelete}
    Wait Until Element Is Visible   ${deleteUser}
    Select From List                ${deleteUser}               ${userToDelete}
    Wait Visible Do Action          ${deleteUserOK}             Click     ${clickable}
    Wait Until Element Contains     ${deleteUserConfirmTitle}   ${deleteUserConfirmTitleMsg}
    Wait Until Element Contains     ${deleteUserConfirmText}    ${deleteUserConfirmTextStart} ${userToDelete} ${deleteUserConfirmTextEnd}
    Wait Visible Do Action          ${deleteUserConfirmOK}      Click     ${clickable}
    Wait Until Element Contains     ${deleteUserSuccess}        ${deleteUserSuccessMsg}
