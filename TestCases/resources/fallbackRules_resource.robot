*** Settings ***
Documentation     Fallback Rules related resource file with reusable keywords and variables.
Resource          properties.robot
Resource          utility_resource.robot
Library           Selenium2Library
Library           Collections

*** Variables ***
#INPUT IDs
${rxSynthUnlock}    rec_synth_lock_0016
${rx1ppsUnlock}     rec_1pps_lock_0015
${txSynthUnlock}    tx_synth_lock_0018
${txRefFreqUnlock}  tx_ref_lock_0017
${fsiDisconnect}    fsi_state_0019
${high48V}          trx_highvolt_0010
${low48V}           trx_lowvolt_0011
${highCurrent}      trx_highcurr_0012
#POWER AMPLIFIER
${paDisconnect}     pa_connect_0014
${paHigh48V}        pa_highvolt_0001
${paLow48V}         pa_lowvolt_0002
${paHighCurrent}    pa_highcurr_0003
${paHighTemp}       pa_hightemp_0004
${paOutputPower}    pa_outpower_0005
#POWER SUPPLY
${leftFail48V}      psu_left_0008
${rightFail48V}     psu_right_0007

${updateLabel}        edit_failover_lbl
${updateLabelText}    Updated Successfully

#INPUT VALUES - DROPDOWN LIST
#TRANSCEIVER
@{rxSynthUnlockList}    Disable Alarm         Alarm Only    Fallback              Disable Receiver Only       Disable Transceiver
@{rx1ppsUnlockList}     Disable Alarm         Alarm Only    Fallback              Disable Receiver Only       Disable Transmitter Only   Disable Transceiver
@{txSynthUnlockList}    Disable Alarm         Alarm Only    Fallback              Disable Transmitter Only    Disable Transceiver
@{txRefFreqUnlockList}  @{rx1ppsUnlockList}
@{fsiDisconnectList}    Disable Alarm         Alarm Only    Fallback
@{high48VList}          Disable Alarm         Alarm Only    Disable Transceiver
@{low48VList}           @{high48VList}
@{highCurrentList}      @{high48VList}
#POWER AMPLIFIER
@{paDisconnectList}     @{txSynthUnlockList}
@{paHigh48VList}        Disable Alarm         Alarm Only    Disable Transmitter Only    Disable Transceiver
@{paLow48VList}         @{paHigh48VList}
@{paHighCurrentList}    @{paHigh48VList}
@{paHighTempList}       @{rx1ppsUnlockList}
@{paOutputPowerList}    @{paDisconnectList}
#POWER SUPPLY
@{leftFail48VList}      @{high48VList}
@{rightFail48VList}     @{high48VList}

${faultManagementTable}   failoverdiv

*** Keywords ***
Navigate To Fallback Rules
    Sleep   3s
    Reload Page
    Wait Visible Do Action    ${fallbackRules}    click   ${clickable}
    Wait Until Element Is Visible   ${faultManagementTable}
    Sleep   3s
