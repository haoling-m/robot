*** Settings ***
Documentation     A resource to navigate and utilize the edit menu.
Resource          navigation_resource.robot
Library           String

*** Variables ***
# BUTTONS
${Edit Button}                    //*[@id="smoothmenu-ajax"]/ul/li[2]/a
${Edit Menu}                      //*[@id="smoothmenu-ajax"]/ul/li[2]/ul
${User Button}                    //*[@id="smoothmenu-ajax"]/ul/li[2]/ul/li/a
${User Menu}                      //*[@id="smoothmenu-ajax"]/ul/li[2]/ul/li/ul
${Add User Button}                addUser
${Edit User Button}               editUser
${Delete User Button}             deleteUser
${Change your Password Button}    changePassword
${Delete Users Dropdown}          ddlUsers
${Delete Button}                  //*[@id="divAccordion"]/div/table/tbody/tr[3]/td/input
${Delete OK Button}               class=ui-button-text-only
${Update Button}                  btnUpdate

# FIELDS
${txtUserName}                    txtUserName
${txtUserPassword1}               txtUserPassword1
${txtUserPassword2}               txtUserPassword2
${oldPassword}                    oldPassword
${newPassword}                    newPassword
${newPassword2}                   newPassword2
${passwordHint}                   passwordHint
${roles}                          roles
${Users Dropdown}                 ddlUsers
${txtUserPasswordHint}            txtUserPasswordHint

# VALUES
# Used in: change password valid + invalid
${newChangePassword}              newpassword!
# For generating different names for adding users (user0, user1 etc)
${UserCounter}                    0

# Confirmation messages
${User Update Success Msg}        successfully updated
${User Add Success Msg}           User successfully added
${User Delete Confirm Msg}        You are about to delete the user
${Admin Delete Confirm Msg}       You are about to delete an Administrator
${User Delete Success Msg}        successfully deleted

*** Keywords ***
Edit Menu Should Be Open
    Wait Until Element Is Visible    ${Edit Menu}
    Capture Page Screenshot
    Sleep    0.1s

Open Edit Menu
    Run Keyword If    '${BROWSER}'=='${INTERNETEXPLORER}'    Mouse Over    ${Edit Button}
    ...         ELSE    Click Element    ${Edit Button}
    Capture Page Screenshot
    Edit Menu Should Be Open

Check If Edit Menu Open
    ${Edit Menu Open}=    Run Keyword And Return Status   Element Should Be Visible   ${Edit Menu}
    Run Keyword Unless    ${Edit Menu Open}   Open Edit Menu
    Capture Page Screenshot

Open User Menu
    Check If Edit Menu Open
    Run Keyword If    '${BROWSER}'=='${INTERNETEXPLORER}'    Mouse Over   ${User Button}
    ...         ELSE    Click Element    ${User Button}
    Wait Until Element Is Visible   ${User Menu}
    Sleep   1s
    Mouse Over    ${Add User Button}
    Capture Page Screenshot

Check If User Menu Open
    # Sleep to let menu load
    Sleep   1s
    ${User Menu Open}=    Run Keyword And Return Status   Element Should Be Visible   ${User Menu}
    Run Keyword Unless    ${User Menu Open}   Open User Menu
    Capture Page Screenshot

Navigate To Add User
    Check If User Menu Open
    Wait Until Element Is Visible   ${Add User Button}
    Click Element    ${Add User Button}
    ${usernameVisible}=   Run Keyword And Return Status   Wait Until Element Is Visible   ${txtUserName}
    # redundant checking because GUI is not stable
    Run Keyword Unless    ${usernameVisible}    Run Keywords
    ...   Reload Page   AND
    ...   Check If User Menu Open   AND
    ...   Wait Until Element Is Visible   ${Add User Button}   AND
    ...   Click Element    ${Add User Button}
    Wait Until Element Is Visible   ${User Menu}
    Capture Page Screenshot

Navigate To Edit User
    Check If User Menu Open
    Wait Until Element Is Visible   ${Edit User Button}
    Click Element    ${Edit User Button}
    ${dropdownVisible}=   Run Keyword And Return Status   Wait Until Element Is Visible   ${Users Dropdown}
    # redundant checking because GUI is not stable
    Run Keyword Unless    ${dropdownVisible}    Run Keywords
    ...   Reload Page   AND
    ...   Check If User Menu Open   AND
    ...   Wait Until Element Is Visible   ${Edit User Button}   AND
    ...   Click Element    ${Edit User Button}
    Wait Until Element Is Visible   ${Users Dropdown}
    Mouse Over    ${Users Dropdown}
    Wait Until Element Is Not Visible   ${User Menu}
    Capture Page Screenshot

Navigate To Delete User
    Check If User Menu Open
    Wait Until Element Is Visible   ${Delete User Button}
    Click Element                   ${Delete User Button}
    ${dropdownVisible}=   Run Keyword And Return Status   Wait Until Element Is Visible   ${Users Dropdown}
    # redundant checking because GUI is not stable
    Run Keyword Unless    ${dropdownVisible}    Run Keywords
    ...   Reload Page   AND
    ...   Check If User Menu Open   AND
    ...   Wait Until Element Is Visible   ${Delete User Button}   AND
    ...   Click Element    ${Delete User Button}
    Wait Until Element Is Visible   ${Users Dropdown}
    Mouse Over    ${Users Dropdown}
    Wait Until Element Is Visible   ${Users Dropdown}
    Mouse Over                      ${Delete Users Dropdown}
    Wait Until Element Is Not Visible   ${User Menu}
    Capture Page Screenshot
    Sleep   0.2s

Navigate To Change Password
    Check If User Menu Open
    Wait Until Element Is Visible   ${Change your Password Button}
    Click Element                   ${Change your Password Button}
    ${oldPassVisible}=   Run Keyword And Return Status   Wait Until Element Is Visible   ${oldPassword}
    # redundant checking because GUI is not stable
    Run Keyword Unless    ${oldPassVisible}    Run Keywords
    ...   Reload Page   AND
    ...   Check If User Menu Open   AND
    ...   Wait Until Element Is Visible   ${Change your Password Button}   AND
    ...   Click Element    ${Change your Password Button}
    Wait Until Element Is Visible   ${oldPassword}
    Click Element                   ${oldPassword}
    Wait Until Element Is Not Visible   ${User Menu}
    Capture Page Screenshot

### Adding Users ###
Add New User
    ${Str}=   Convert To String   ${UserCounter}
    ${UserName}=    Catenate    SEPARATOR=    aUser   ${Str}
    Wait Until Element Is Visible   ${txtUserName}
    Input Text                      ${txtUserName}           ${UserName}
    ${UserCounter}=   Evaluate    ${UserCounter}+1
    Set Suite Variable    ${UserCounter}

Fill Non UserName Fields
    [Arguments]   ${Field ID}   ${Field Value}
    ${ranPassword}=   Generate Random String    8   [LETTERS]
    Wait Until Element Is Visible   ${txtUserPassword1}
    Input Text                      ${txtUserPassword1}      ${ranPassword}
    Input Text                      ${txtUserPassword2}      ${ranPassword}
    Input Text                      ${txtUserPasswordHint}   The password is ${ranPassword}
    Select From List                ${roles}                 User
    Input Text                      ${Field ID}              ${Field Value}

Fill Non Password Fields
    [Arguments]   ${Field ID}   ${Field Value}
    Input Text                      ${txtUserPassword2}      ${Field Value}
    Input Text                      ${txtUserPasswordHint}   the password is ${Field Value}
    Select From List                ${roles}                 User
    Input Text                      ${Field ID}              ${Field Value}

Fill Non Roles Fields
    [Arguments]   ${Field Value}
    Add New User
    ${ranPassword}=   Generate Random String    8   [LETTERS]
    Input Text                      ${txtUserPassword1}      ${ranPassword}
    Input Text                      ${txtUserPassword2}      ${ranPassword}
    Input Text                      ${txtUserPasswordHint}   the password is ${ranPassword}
    Select From List                ${roles}                 ${Field Value}

Fill Non Hint Fields
    [Arguments]   ${Field ID}   ${Field Value}    ${Test Validity}
    Run Keyword if    '${Test Validity}'=='Valid'   Fill Valid Password
    ...         ELSE    Fill Invalid Password   ${Field Value}
    Select From List                ${roles}                 User
    Input Text                      ${Field ID}              ${Field Value}

Fill Valid Password
    ${ranPassword}=   Generate Random String    8   [LETTERS]
    Input Text                      ${txtUserPassword1}      ${ranPassword}
    Input Text                      ${txtUserPassword2}      ${ranPassword}

Fill Invalid Password
    [arguments]   ${Field Value}
    Input Text                      ${txtUserPassword1}      ${Field Value}
    Input Text                      ${txtUserPassword2}      ${Field Value}

### For use in invalid and valid add user tests ###
Test Username
    [Arguments]    ${Field ID}    ${Field Value}    ${Comment}
    Set Test Variable           ${Comment}
    Fill Non UserName Fields    ${Field ID}   ${Field Value}

Test Password
    [Arguments]    ${Field ID}    ${Field Value}    ${Comment}
    Set Test Variable           ${Comment}
    Add New User
    Fill Non Password Fields    ${Field ID}   ${Field Value}

Test Password Hint
    [Arguments]    ${Field ID}    ${Field Value}    ${Test Validity}    ${Comment}
    Set Test Variable       ${Comment}
    Add New User
    Fill Non Hint Fields    ${Field ID}   ${Field Value}    ${Test Validity}

Test Roles
    [Arguments]    ${Field Value}    ${Comment}
    Set Test Variable       ${Comment}
    Add New User
    Fill Non Roles Fields   ${Field Value}

### For use in invalid adding and editing user tests ###
Test Non Matching Password
    [arguments]   ${Field ID}   ${Field Value}    ${Comment}
    Set Test Variable   ${Comment}
    ${Test Type}=   Get SubString   ${TEST NAME}    5   8
    Run Keyword If    '${Test Type}'=='add'   Run Keywords
    ...   Add New User
    ...   Input Text     ${txtUserName}           a brand new user
    ...   Input Text     ${txtUserPasswordHint}   a hint
    Input Text           ${txtUserPassword1}      Codan!!!
    Input Text           ${txtUserPassword2}      ${Field Value}

### For use in delete valid and change password valid tests ###
Add User
    [Arguments]   ${User}   ${Pass}   ${Role}
    Wait Until Element Is Visible   ${txtUserName}
    Input Text                      ${txtUserName}   ${User}
    Wait Until Element Is Visible   ${txtUserPassword1}
    Input Text                      ${txtUserPassword1}      ${Pass}
    Input Text                      ${txtUserPassword2}      ${Pass}
    Input Text                      ${txtUserPasswordHint}   The password is ${Pass}
    Select From List                ${roles}                 ${Role}
    Click Element                   ${Update Button}
    Wait Until Page Contains        ${User Add Success Msg}
    Wait Until Page Does Not Contain    ${User Add Success Msg}

Confirm Delete
    Click Element   ${Delete OK Button}
    Sleep   0.1s

User Edit Suite Setup
    Setup Suite To Global Settings
    Navigate To Add User
    ${ranUsername}=   Generate Random String    8   [LETTERS]
    ${ranPassword}=   Generate Random String    8   [LETTERS][NUMBERS]
    Set Suite Variable    ${ranUsername}
    Set Suite Variable    ${ranPassword}
    Add User    ${ranUsername}    ${ranPassword}    User

User Edit Suite Teardown
    # Delete the user created in suite setup
    Navigate To Delete User
    Select From List          ${Delete Users Dropdown}  ${ranUsername}
    Click Element             ${Delete Button}
    Wait Until Page Contains  ${User Delete Confirm Msg}
    Confirm Delete
    Sleep   0.2s
    Teardown Suite
