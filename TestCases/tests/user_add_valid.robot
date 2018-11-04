*** Settings ***
Documentation     A test suite for valid adding a user.
Suite Setup       Setup Suite To Global Settings
Suite Teardown    Teardown Suite
Test Setup        Navigate To Add User
Test Teardown     Teardown Test
Test Template     Valid Add
Resource          ../resources/utility_resource.robot
Resource          ../resources/edit_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Variables ***
${newPassword8Charac}             passWor!

*** Test Cases ***           Field ID                  Field Value
Valid Username At Min        ${txtUserName}            a
Valid Username Default       ${txtUserName}            User Name
Valid Username At Max        ${txtUserName}            ${40Character String}
Valid Username has Symbol    ${txtUserName}            ${Symbols String}

Valid Password At Min        ${txtUserPassword1}       ${newPassword8Charac}
Valid Password Default       ${txtUserPassword1}       password
Valid Password At Max        ${txtUserPassword1}       ${256Character String}

Valid Password Hint At Min   ${txtUserPasswordHint}    a
Valid Password Hint At Max   ${txtUserPasswordHint}    ${256Character String}

Valid roles Admin            ${roles}                  Administrator
Valid roles User             ${roles}                  User

*** Keywords ***
Valid Add
    [Arguments]    ${Field ID}    ${Field Value}
    Wait Until Element Is Visible   ${Field ID}
    Run Keyword if    "${Field ID}"=="${txtUserName}"   Test Username    ${Field ID}   ${Field Value}    Should accept ${TEST NAME}: "${Field Value}"
    ...         ELSE IF   "${Field ID}"=="${txtUserPassword1}"   Test Password    ${Field ID}   ${Field Value}    Should accept ${TEST NAME}: "${Field Value}"
    ...         ELSE IF   "${Field ID}"=="${txtUserPasswordHint}"    Test Password Hint    ${Field ID}   ${Field Value}    Valid   Should accept ${TEST NAME}: "${Field Value}"
    ...         ELSE IF   "${Field ID}"=="${roles}"    Test Roles   ${Field Value}    Should accept ${TEST NAME}
    Click Element                   ${Update Button}
    Wait Until Page Contains        ${User Add Success Msg}
    Wait Until Page Does Not Contain    ${User Add Success Msg}   timeout=10s
