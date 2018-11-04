*** Settings ***
Documentation     A test suite for invalid editing a user(p25admin)
Suite Setup       User Edit Suite Setup
Suite Teardown    User Edit Suite Teardown
Test Setup        Navigate To Edit User
Test Template     Invalid Edit
Test Teardown     Teardown Test
Resource          ../resources/utility_resource.robot
Resource          ../resources/edit_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***                               ${Field ID}           ${Field Value}            ${User To Test}
Invalid p25admin Password Under 8 Characters     ${txtUserPassword1}   ${7Character String}      ${VALID USER}
Invalid p25admin Password Over 256 Characters    ${txtUserPassword1}   ${257Character String}    ${VALID USER}

Invalid testUser Password Under 8 Characters     ${txtUserPassword1}   ${7Character String}      ${ranUsername}
Invalid testUser Password Over 256 Characters    ${txtUserPassword1}   ${257Character String}    ${ranUsername}
Invalid testUser Passwords Do Not Match          ${txtUserPassword2}   ${newPassword}            ${ranUsername}

*** should not pass, GUI needs updating ***
Invalid passwordHint              ${passwordHint}          ${VALID PASSWORD}

*** Keywords ***
Invalid Edit
    [arguments]   ${Field ID}   ${Field Value}    ${User To Test}
    Set Test Variable   ${Comment}    Should not accept ${TEST NAME} "${Field Value}"
    Wait Until Element Is Visible   ${Field ID}
    Select From List By Value   ${Users Dropdown}    ${User To Test}
    Input Text    ${Field ID}   ${Field Value}
    Run Keyword if    '${Field ID}'=='${txtUserPassword1}'   Input Text    ${txtUserPassword2}   ${Field Value}
    ...         ELSE IF   "${Field ID}"=="${txtUserPassword2}"   Test Non Matching Password    ${Field ID}   ${Field Value}    Should not accept non matching passwords
    Click Element                   ${Update Button}
    Wait Until Element Is Visible   ${errorMsg}
    Wait Until Element Is Not Visible   ${Edit Menu}
