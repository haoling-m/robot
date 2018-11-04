*** Settings ***
Documentation     A test suite for invalid adding a user.
Suite Setup       Setup Suite To Global Settings
Suite Teardown    Teardown Suite
Test Setup        Navigate To Add User
Test Teardown     Teardown Test
Test Template     Invalid Add
Resource          ../resources/utility_resource.robot
Resource          ../resources/edit_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***                        ${Field ID}               ${Field Value}
Invalid Username Empty                    ${txtUserName}            ${EMPTY}
Invalid Username Over 40 Characters       ${txtUserName}            ${41Character String}
Invalid Username Already Exists           ${txtUserName}            ${VALID USER}

Invalid Password Empty                    ${txtUserPassword1}       ${EMPTY}
Invalid Password Less Than 8 Characters   ${txtUserPassword1}       ${7Character String}
Invalid Password Over 256 Characters      ${txtUserPassword1}       ${257Character String}
Invalid Password Hint Empty               ${txtUserPasswordHint}    ${EMPTY}
Invalid Passwords Do Not Match            ${txtUserPassword2}       ${newPassword}

*** should not pass, GUI needs updating ***
Invalid txtUserPasswordHint       ${txtUserPasswordHint}   password!

*** Keywords ***
Invalid Add
    [Arguments]    ${Field ID}    ${Field Value}
    Wait Until Element Is Visible   ${Field ID}
    Run Keyword if    "${Field ID}"=="${txtUserName}"    Test Username    ${Field ID}   ${Field Value}    Should not accept ${TEST NAME}: "${Field Value}"
    ...         ELSE IF   "${Field ID}"=="${txtUserPassword1}"   Test Password    ${Field ID}   ${Field Value}    Should not accept ${TEST NAME}: "${Field Value}"
    ...         ELSE IF   "${Field ID}"=="${txtUserPasswordHint}"    Test Password Hint    ${Field ID}   ${Field Value}   Valid   Should not accept ${TEST NAME}: "${Field Value}"
    ...         ELSE IF   "${Field ID}"=="${txtUserPassword2}"   Test Non Matching Password    ${Field ID}   ${Field Value}    Should not accept non matching passwords
    Click Element                   ${Update Button}
    Wait Until Element Is Visible   ${errorMsg}
    Wait Until Element Is Not Visible   ${Edit Menu}
