*** Settings ***
Documentation     A resource to navigate and the help menu.
Resource          navigation_resource.robot

*** Variables ***
${Help Menu Button}               //*[@id="smoothmenu-ajax"]/ul/li[4]/a
${Help Menu}                      //*[@id="smoothmenu-ajax"]/ul/li[4]/ul
${About Button}                   //*[@id="smoothmenu-ajax"]/ul/li[4]/ul/li[1]/a
${Version History Accordion}      accordionHeaderVersionHistory
${Contact Us Accordion}           accordionHeaderContactUs
${Codan Website Button}           //*[@id="smoothmenu-ajax"]/ul/li[4]/ul/li[2]/a
${License Agreement Accordion}    accordionHeaderLicenseAgreement
${Update Version Button}          //*[@id="smoothmenu-ajax"]/ul/li[4]/ul/li[3]/a
${Web Link}                       //*[@id="smoothmenu-ajax"]/ul/li[4]/ul/li[2]/a
${UPDATE FIRMWARE BUTTON}         //*[@id="divAccordion"]/div/form/table/tbody/tr[4]/td[2]/input
${LMR URL}                        http://www.codanradio.com/lmr/
${Codan Address}                  43 Erie Street

*** Keywords ***
Open Help Menu
    #Sleep to let menu load
    Sleep   2s
    Run Keyword If    '${BROWSER}'=='${INTERNETEXPLORER}'    Mouse Over   ${Help Menu Button}
    Click Element    ${Help Menu Button}
    Capture Page Screenshot
    Wait Until Element Is Visible   ${About Button}

Check If Help Menu Open
    Capture Page Screenshot
    ${Help Menu Open}=    Run Keyword And Return Status   Element Should Be Visible   ${Help Menu}
    Run Keyword Unless    ${Help Menu Open}==True    Open Help Menu
    Capture Page Screenshot

Click About
    Wait Until Element Is Visible   ${About Button}
    Capture Page Screenshot
    Mouse Over    ${About Button}
    Click Element   ${About Button}
    Sleep   1s
    Capture Page Screenshot

Navigate To Version History
    Check If Help Menu Open
    Click About
    Wait Until Element Is Visible   ${Version History Accordion}
    Click Element                   ${Version History Accordion}
    Wait Until Element Is Visible   VersionHistory
    Capture Page Screenshot

Navigate To Contact Us
    Run Keyword If    '${BROWSER}'=='${FIREFOX}'   Run Keywords    Check If Help Menu Open   Click About
    Wait Until Element Is Visible   ${Contact Us Accordion}
    Click Element                   ${Contact Us Accordion}
    Capture Page Screenshot
    Wait Until Page Contains        ${Codan Address}
    Capture Page Screenshot

Navigate To Codan Website
    Check If Help Menu Open
    Wait Until Element Is Visible   ${Codan Website Button}
    Capture Page Screenshot

Navigate To License Agreement
    Check If Help Menu Open
    Click About
    Wait Until Element Is Visible   ${License Agreement Accordion}
    Click Element                   ${License Agreement Accordion}
    Capture Page Screenshot
    Wait Until Page Contains        These Terms apply to the UIC-5

Navigate To Update Software Version
    Check If Help Menu Open
    Wait Until Element Is Visible   ${Update Version Button}
	  Click Element                   ${Update Version Button}
    Capture Page Screenshot
    Wait Until Element Is Visible   uploadedfile    timeout=10s
