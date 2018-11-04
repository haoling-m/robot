*** Settings ***
Documentation     Utility related resource file with reusable keywords and variables.
Library           Selenium2Library
Resource          properties.robot

*** Variables ***
#Field Types
${textBox}        textBox
${checkBox}       checkBox
${dropdownList}   dropdownList
${radioButton}    radioButton
${clickable}      clickable

${placeholderFlag}        placeholder

*** Keywords ***
Wait Visible Do Action
    [Arguments]   ${fieldID}   ${fieldValue}    ${fieldType}
    Wait Until Element Is Visible   ${fieldID}
    Run Keyword If    "${fieldType}"=="${textBox}"    Run Keywords
    ...               Run Keyword If    '${BROWSER}'=='Firefox'   Backspace Delete    ${fieldID}
    ...                         ELSE    Clear Element Text    ${fieldID}    AND
    ...               Input Text    ${fieldID}    ${fieldValue}
    ...    ELSE IF    "${fieldType}"=="${dropdownList}"   Select From List    ${fieldID}    ${fieldValue}
    ...    ELSE IF    "${fieldType}"=="${checkBox}"       Click Element       ${fieldID}
    ...    ELSE IF    "${fieldType}"=="${radioButton}"    Click Element       ${fieldID}
    ...    ELSE IF    "${fieldType}"=="${clickable}"      Click Element       ${fieldID}
    ...       ELSE    Fail    Field Type Not Recognized

Backspace Delete
    [Arguments]   ${fieldID}
    Click Element   ${fieldID}
    ${currTextValue}=   Get Value   ${fieldID}
    ${textLength}=    Get Length    ${currTextValue}
    # press Backspace key ${i} times
    :FOR    ${i}    IN RANGE    ${textLength}
    \   Press Key   ${fieldID}    \\08

Wait Visible Get Attribute
    [Arguments]   ${fieldID}   ${fieldAttribute}
    Wait Until Element Is Visible   ${fieldID}
    ${placeholderValue}=            Get Element Attribute   ${fieldID}  ${fieldAttribute}
    [Return]    ${placeholderValue}
