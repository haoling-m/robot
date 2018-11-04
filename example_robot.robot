
*** Settings ***
Documentation     Test description
Library           Selenium2Library

*** Variables ***
${var}                    var
${browser}         Chrome
${url}                    http://192.168.66.148

*** Test Cases ***
Example Test
    Open Browser    ${url}    ${browser}	
	Sleep   5s
	End The Test

*** Keywords ***
# The keywords that are used for tests go here
End The Test
    Log To Console    Ending the test and closing browser
    Close Browser
