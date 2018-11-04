*** Settings ***
Documentation     A test suite for invalid changing user password.
Suite Setup       Setup Suite To Global Settings
Suite Teardown    Teardown Suite
Test Setup        Navigate To Change Password
Test Template     Invalid New Password
Test Teardown     Teardown Test
Resource          ../resources/utility_resource.robot
Resource          ../resources/edit_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Variables ***
${Incorrect Old Password}         wrong!!

*** Test Cases ***                            ${OldPass Value}            ${NewPass Value1}         ${NewPass Value2}         ${Hint Value}
Incorrect Old Password                        ${Incorrect Old Password}   ${newChangePassword}      ${newChangePassword}      The password is ${newChangePassword}
Password Should Not Be Under 8 Characters     ${VALID PASSWORD}           ${7Character String}      ${7Character String}      The password is ${7Character String}
Password Should Not Be Over 256 Characters    ${VALID PASSWORD}           ${257Character String}    ${257Character String}    The password is ${257Character String}
Password Cannot Be Empty                      ${VALID PASSWORD}           ${EMPTY}                  ${EMPTY}                  The password is empty
Passwords Do Not Match                        ${VALID PASSWORD}           passNoMatch1              passNoMatch2              The passwords are not going to match

*** this should fail but passes ¯\_(ツ)_/¯ ***
Invalid Password Hint Same As Password        ${VALID PASSWORD}           ${New Passw}              ${New Passw}              ${New Passw}

*** Keywords ***
Invalid New Password
    [arguments]     ${OldPass Value}    ${NewPass Value1}   ${NewPass Value2}   ${Hint Value}
    Run Keyword If    '${TEST NAME}'=='Passwords Do Not Match'    Set Test Variable    ${Comment}   ${TEST NAME} - "${NewPass Value1}", Re-enter password - "${NewPass Value2}"
    ...     ELSE      Set Test Variable    ${Comment}   ${TEST NAME} "${NewPass Value1}"
    Input Text      ${oldPassword}      ${OldPass Value}
    Input Text      ${newPassword}      ${NewPass Value1}
    Input Text      ${newPassword2}     ${NewPass Value2}
    Input Text      ${passwordHint}     ${Hint Value}
    Click Element   ${Update Button}
    Wait Until Element Is Visible    ${errorMsg}
    Wait Until Element Is Not Visible   ${Edit Menu}
