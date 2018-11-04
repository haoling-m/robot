*** Settings ***
Documentation     Valid Delete User (All) test case suite.
Suite Setup       Set API and Open Browser To Home Page
Suite Teardown    Teardown Suite
Test Setup        Navigate To Admin    ${deleteUserLink}
Test Teardown     Teardown Test
Resource          ../resources/user_resource.robot
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot
Library           Collections

*** Variables ***
${listDefault}      Select User

*** Test Cases ***
Delete All Users
    Set Test Variable   ${Comment}    ${TEST NAME}
    ${foundUsers}=   Get List Items    ${deleteUser}
    Remove Values From List    ${foundUsers}    ${VALID USER2}
    Remove Values From List    ${foundUsers}    ${listDefault}
    Log    ${foundUsers}
    :FOR    ${username}    IN    @{foundUsers}
    \   Delete User     ${username}
    \   Wait Until Element Does Not Contain   ${deleteUserSuccess}    ${deleteUserSuccessMsg}
