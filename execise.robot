*** Settings ***
Documentation  Base robot file for lab
Test Template 		Log Text

*** Variables ***
${value1}   Ramiro is so cool
${value2}   Devops is the best
*** Test Cases ***
My Test 1		${value1}
My Test 2 		${value2}
*** Keywords ***
Log Text
	[arguments] 	${arg}
	Log To Console 		${arg}