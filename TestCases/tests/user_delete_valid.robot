*** Settings ***
Documentation     A test suite for deleting users. Deletes all users that are not 'p25admin'
Suite Setup       Setup Suite To Global Settings
Suite Teardown    Teardown Suite
Test Setup        Navigate To Delete User
Test Teardown     Teardown Test
Resource          ../resources/edit_menu_resource.robot
Resource          ../resources/testrail_api_resource.robot
Resource          ../resources/utility_resource.robot

*** Test Cases ***
Valid Delete
    ${ranUsername1}=   Generate Random String    8   [LETTERS]
    ${ranUsername2}=   Generate Random String    8   [LETTERS]
    ${ranPassword1}=   Generate Random String    8   [LETTERS]
    ${ranPassword2}=   Generate Random String    8   [LETTERS]
    Set Suite Variable   ${Comment}    Add 2 users '${ranUsername1}' and '${ranUsername2}', then delete them
    # Add a couple users
    Navigate To Add User
    Add User    ${ranUsername1}   ${ranPassword1}   User
    Navigate To Add User
    Add User    ${ranUsername2}   ${ranPassword2}   User
    # Delete all users except p25admin
    Navigate To Delete User
    ${Users}=   Get List Items    ${Delete Users Dropdown}
    Remove Values From List   ${Users}    ${VALID USER}  ${EMPTY}
    Wait Until Element Is Visible   ${Delete Users Dropdown}
    :FOR    ${User}   in    @{Users}
    \   Select From List   ${Delete Users Dropdown}  ${User}
    \   Click Element   ${Delete Button}
    \   Wait Until Page Contains  ${User Delete Confirm Msg}
    \   Confirm Delete
    \   ${Delete Admin Confirm Msg}=   Run Keyword And Return Status   Page Should Contain   ${Admin Delete Confirm Msg}
    \   Run Keyword if    ${Delete Admin Confirm Msg}   Confirm Delete
    \   ${UpdatedUsers}=   Get List Items    ${Delete Users Dropdown}
    \   Sleep   0.2s
    \   List Should Not Contain Value   ${UpdatedUsers}   ${User}
    \   ${Success Msg}=   Catenate    ${User}   ${User Delete Success Msg}
    \   Wait Until Page Contains    ${Success Msg}
    \   Wait Until Page Does Not Contain    ${Success Msg}    timeout=10s
    # Make sure you can't log in with the deleted users' info
    Log Out User
    Login User Expect Error   ${ranUsername1}    ${ranPassword1}
    Reload Page
    Login User Expect Error   ${ranUsername2}    ${ranPassword2}
