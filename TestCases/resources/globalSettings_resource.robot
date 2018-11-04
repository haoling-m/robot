*** Settings ***
Documentation     Global Settings related resource file with reusable keywords and variables.
Resource          properties.robot
Resource          utility_resource.robot
Resource          navigation_resource.robot
Library           Selenium2Library

*** Variables ***
${endpointName}               rss_uname_glb
${endpointNameEdit}           trnsvr_generic_edit_icon
${endpointNameErr}            tooltip_rss_uname_glb
${endpointNameErrClass}       class=tooltip-inner
${endpointNameErrClassText}   Max allowed characters are 25.
${endpointLabel}              trnsvr_generic_lbl
${unitID}                     rss_uid_glb
${unitIDErr}                  tooltip_rss_uid_glb
${channelList}                view_ch_list
${updateSuccessful}           edit_generic_lbl
${updateSuccessfulMsg}        Transceiver updated successfully.
${channelListTable}           channel-list
${defaultActiveChannel}       rad_set_active_ch
${fallbackChannel}            rad_set_fallback_ch

#Input Values
#INVALID
${invalidendpointName1}   $
${invalidendpointName2}   @@@
${invalidendpointName3}   (()
${invalidendpointName4}   ^^^
${25CharLimit}            01234567890123456789123456
${NumberOnlyWrong}        Z8
${unitIDLow}              -1
${unitIDHigh}             989680

#VALID
${endpointNameMin}        0
${endpointNameMax}        0123456789012345678912345

${unitIDMin}              000001
${unitIDMax}              98967f

${dropdownTest}           dropdownTest

*** Keywords ***
Refresh Page
    Reload Page
    Welcome Page Should Be Open

Make Endpoint Name Editable
    Wait Visible Do Action   ${endpointNameEdit}   Click   ${clickable}
