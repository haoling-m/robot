*** Settings ***
Documentation     Invalid Login test case suite.
Suite Setup       Set API And Open Browser To Login Page
Suite Teardown    Teardown Suite
Test Setup        Go To Login Page
Test Template     Login With Invalid Credentials Should Fail
Test Teardown     Teardown Test
Resource          ../resources/navigation_resource.robot
Resource          ../resources/testrail_api_resource.robot

*** Test Cases ***               USER NAME        PASSWORD
Invalid Username                 invalid          ${VALID PASSWORD}
Invalid Password                 ${VALID USER}    invalid
Invalid Username And Password    invalid          whatever
Empty Username                   ${EMPTY}         ${VALID PASSWORD}
Empty Password                   ${VALID USER}    ${EMPTY}
Empty Username And Password      ${EMPTY}         ${EMPTY}

*** Keywords ***
Login With Invalid Credentials Should Fail
    [Arguments]    ${username}    ${password}
    Set Test Variable   ${Comment}    ${TEST NAME} - Username: ${username}, Password: ${password}
    Login User Without Validation   ${username}    ${password}
    Login Should Have Failed

Go To Login Page
    Go To    ${LOGIN URL}
    Login Page Should Be Open   5s
