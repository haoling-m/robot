*** Settings ***
Library 	Selenium2Library
Library  	Collections

*** Variables ***
${value1}   Ramiro is so cool
${value2}   Devops is the best
@{list}  1  2  three  four

*** Keywords ***
Open Browser And Go To Google 
	Open Browser	 https://www.google.ca	 Chrome
	${zScalerAppeared}=	   Run Keyword And Return Status
	...    Wait Until Page Contains Element   okta-signin-username   10s
	Run Keyword If   ${zScalerAppeared}
	...   Input Text   okta-signin-username    your.name@codanradio.com
	Wait Until Page Contains Element     lga     30s
	Log To Console 		\nOpened browser to Google wahoo\n
