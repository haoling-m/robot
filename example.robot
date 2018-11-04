*** Settings ***
Documentation  Base robot file for lab
Test Template  Log Text
Resource 	example_resource.robot
Suite Setup 	Open Browser And Go To Google
Suite Teardown 		Close Browser
*** Variables ***

*** Test Cases ***
My Test 1  ${value1}
My Test 2  ${value2}
Test Case 3  ${list}
*** Keywords ***
Log Text
	[arguments] 	${arg}
	Run Keyword If   '${TEST NAME}'=='Test Case 3'
	...	 Handle List   ${arg}
	...  ELSE   Log To Console   ${arg}

Handle List
	[arguments]  ${listArg}
	:FOR  ${item}  IN  ${listArg}
	\  Log To Console  \n${item