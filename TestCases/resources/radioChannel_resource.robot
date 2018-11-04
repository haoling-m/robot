*** Settings ***
Documentation     Radio Channel related resource file with reusable keywords and variables.
Resource          properties.robot
Resource          utility_resource.robot
Resource          navigation_resource.robot
Library           Selenium2Library
Library           Collections

*** Variables ***
#INPUT IDs
${radioChannelLink}       edit_radio_channel
${defaultChannel}         rad_set_active_ch
${updateLabel}            ch_updt_mess_lbl
${updateLabelText}        Channel updated successfully.
${channelApplyAll}        all_ch_edit_ok
#COMMON - SINGLE
${channelNumber}          rx_edit_ch
${channelName}            trnsvr_ch_name
${channelNameErr}         tooltip_trnsvr_ch_name
${channelMode}            trnsvr_ch_radmod
${channelType}            rx_modul_p25
${rxFreq}                 rx_addch_rxfr
${rxFreqErr}              tooltip_freq_rx
${txFreq}                 tx_addch_txfr
${txFreqErr}              tooltip_freq_tx
${txOutput}               tx_addch_pow
${txOutputErr}            tooltip_pow
${txOffset}               tx_addch_txfrof
${txTimeout}              tx_addch_to
${txTimeoutErr}           tooltip_tto
#COMMON - ALL
${channelNumberAll}       global_edit_ch
${channelModeAll}         global_ch_radmod
${channelTypeAll}         global_ch_radtype
${rxFreqAll}              global_rx_frequency
${rxFreqErrAll}           tooltip_global_rx_frequency
${txFreqAll}              global_tx_addch_txfr
${txFreqErrAll}           tooltip_global_tx_addch_txfr
${txOutputAll}            global_tx_addch_pow
${txOutputErrAll}         tooltip_global_tx_addch_pow
${txOffsetAll}            global_tx_addch_txfrof   #TODO Remove from global?
${txTimeoutAll}           global_tx_addch_to
${txTimeoutErrAll}        tooltip_global_tx_addch_to
#ANALOG ONLY - SINGLE
${rxSquelch}              rx_squelch_ch
${rxNoiseOpen}            noise_sq_open
${rxNoiseClose}           noise_sq_close
${rxRSSIOpen}             rssi_sq_open
${rxRSSIClose}            rssi_sq_close
${rxAnalogUnmute}         rx_anunmute_ch
${rxCTCSSTone}            rx_ctcss_tone
${rxDeEmph}               rx_deemph_ch
${txSignal}               tx_txsignal_ch
${txCTCSSTone}            tx_txctcss_tone
${txCTCSSLevel}           tx_txctcssl_tone
${txCTCSSLevelErr}        tooltip_tx_txctcssl_tone
${txReverseBurst}         tx_txbrst_ch
${txPreEmph}              tx_preemph_ch
${txAnalogHangtime}       tx_hang_time
${txAnalogHangtimeErr}    tooltip_tx_hang_time
#ANALOG ONLY - ALL
${rxSquelchAll}             WILL_ADD             #TODO Needs to be added to global
${rxAnalogUnmuteAll}        global_unmute
${rxCTCSSToneAll}           global_rx_ctcss_tone
${rxDeEmphAll}              deempallch
${txSignalAll}              global_tx_txsignal_ch
${txCTCSSToneAll}           global_tx_txctcssl_tone
${txCTCSSLevelAll}          ctcsstnlvlallch
${txCTCSSLevelErrAll}       tooltip_ctcsstnlvlallch
${txPreEmphAll}             preempallch
${txAnalogHangtimeAll}      global_tx_hang_time
${txAnalogHangtimeErrAll}   tooltip_global_tx_hang_time
#DIGITAL ONLY - SINGLE
${rxDigitalUnmute}        rx_digunmute_ch
${rxNAC}                  rx_addch_nac
${rxNACErr}               tooltip_nac
${rxTGID}                 rx_addch_tgid
${rxTGIDErr}              tooltip_tgid
${txNAC}                  tx_addch_tnac
${txNACErr}               tooltip_nac_tx
${txDigitalHangtime}      tx_hangd_time
${txDigitalHangtimeErr}   tooltip_tx_hangd_time
#DIGITAL ONLY - ALL
${rxDigitalUnmuteAll}       global_rx_unmute
${rxNACAll}                 global_rx_nac
${rxNACErrAll}              tooltip_global_rx_nac
${rxTGIDAll}                global_rx_tgid
${rxTGIDErrAll}             tooltip_global_rx_tgid
${txNACAll}                 global_tx_addch_tnac
${txNACErrAll}              tooltip_global_tx_addch_tnac
${txDigitalHangtimeAll}     global_tx_hangd_time
${txDigitalHangtimeErrAll}  tooltip_global_tx_hangd_time

#ERROR MESSAGES - ALL
${errFormat}                Invalid Character Entered.
${errRange}                 Invalid Range.
${errRange2}                Invalid range
${errFrequency}             Invalid Frequency.
${errFormatNumber}          Only numbers are allowed.
${errFormatPeriod}          Only numbers and . are allowed.

#INPUT REQUIREMENTS
${noRequirements}           noRequirements
${analogOnly}               analogOnly
${analogRxSquelchNoise}     analogRxSquelchNoise
${analogRxSquelchRSSI}      analogRxSquelchRSSI
${analogRxUnmuteCTCSS}      analogRxUnmuteCTCSS
${analogTxUnmuteCTCSS}      analogTxUnmuteCTCSS
${digitalOnly}              digitalOnly
${digitalRxUnmuteNACTGID}   digitalRxUnmuteNACTGID

#INPUT VALUES - INCORRECT
#COMMON
${invalidChannelName1}    $
${invalidChannelName2}    @@@
${invalidChannelName3}    (()
${invalidChannelName4}    ^^^
#Rx
${NumberOnlyWrong}        Z8

${FreqLow}                -1
${FreqHigh}               1001

${txTimeoutLow}           14
${txTimeoutHigh}          466
${txTimeoutStep}          10.1

${txOutputLow}            9
${txOutputHigh}           101
${txOutputStep}           10.1

${txCTCSSLevelLow}        -1
${txCTCSSLevelHigh}       101
${txCTCSSLevelStep}       10.1

${txAnalogHangtimeLow}    -1
${txAnalogHangtimeHigh}   4

${rxNACLow}               -1
${rxNACHigh}              1000

${rxTGIDLow}              -1
${rxTGIDHigh}             10000

${txNACLow}               -1
${txNACHigh}              1000

${txDigitalHangtimeLow}    -1
${txDigitalHangtimeHigh}   4

${txNACNonAllowed1}        $F7E
${txNACNonAllowed2}        $F7F

#INPUT VALUES - CORRECT
#COMMON
${ChannelNameFormat}       Valid-Channel_Name.
${ChannelNameMin}          a
${ChannelNameMax}          thisnameisatthemaxlimital

${FreqMin}                 148.00000
${FreqMax}                 175.00000

${txTimeoutMin}            15
${txTimeoutMax}            465

${txOutputMin}             10
${txOutputMax}             100

${txCTCSSLevelMin}         1
${txCTCSSLevelMax}         30

${txAnalogHangtimeMin}     0
${txAnalogHangtimeMax}     3
${txAnalogHangtimeStep}    1.5

${rxNACMin}                001
${rxNACMax}                fff

${rxTGIDMin}               0001
${rxTGIDMax}               ffff

${txNACMin}                001
${txNACMax}                fff

${txDigitalHangtimeMin}    0
${txDigitalHangtimeMax}    3.75
${txDigitalHangtimeStep}   1.5

#Valid dropdownLists
@{channelModeList}        Local Repeat    Transmit And Receive    Receive Only    Transmit Only   Disabled
@{channelTypeList}        P25 Digital     Analog
@{rxSquelchList}          Noise   RSSI
@{rxAnalogUnmuteList}     CarrierSquelch    CTCSS
@{rxCTCSSToneList}        67 Hz   69.3 Hz   71.9 Hz   74.4 Hz   77 Hz   79.7 Hz   82.5 Hz   85.4 Hz   88.5 Hz   91.5 Hz   94.8 Hz   97.4 Hz   100 Hz   103.5 Hz   107.2 Hz    110.9 Hz    114.8 Hz    118.8 Hz    123 Hz    127.3 Hz    131.8 Hz    136.5 Hz    141.3 Hz    146.2 Hz    151.4 Hz    156.7 Hz    162.2 Hz    167.9 Hz    173.8 Hz    179.9 Hz    186.2 Hz    192.8 Hz    203.5 Hz    206.5 Hz    210.7 Hz    218.1 Hz    225.7 Hz    229.1 Hz    233.6 Hz    241.8 Hz    250.3 Hz    254.1 Hz
@{rxDigitalUnmuteList}    Any P25 Signal    NAC   NAC and TGID
@{rxDeEmphList}           Disable   Enable
@{txSignalList}           No Tone   CTCSS
@{txCTCSSToneList}        @{rxCTCSSToneList}
@{txPreEmphList}          Disable   Enable

#Navigation Flags
${analogFlag}               f
${digitalFlag}              t
${CTCSSFlag}                Ctcss
${NACTGIDFlag}              NacAndTgid
${listFlag}                 <class 'list'>
${typeListFlag}             <type 'list'>
${channelNumberValueAll}    all

*** Keywords ***
Click Radio Channel Then Advanced View
    Wait Visible Do Action    ${radioChannelLink}   click   ${clickable}
    Wait Visible Do Action    ${defaultChannel}   click   ${clickable}
    ${activeChannel}=   Get Selected List Value   ${defaultChannel}
    Wait Until Element Contains    ${channelNumber}   ${activeChannel}
    Sleep   1s

Click All Radio Channel Then Advanced View
    Wait Visible Do Action    ${radioChannelLink}   click   ${clickable}
    Wait Visible Do Action    ${defaultChannel}   click   ${clickable}
    ${activeChannel}=   Get Selected List Value   ${defaultChannel}
    Wait Until Element Contains    ${channelNumber}   ${activeChannel}
    Select From List By Value    ${channelNumber}   ${channelNumberValueAll}
    Wait Until Element Is Visible    ${channelApplyAll}     5s
    Click Element     ${radioName}
    Sleep   1s

Show Required Fields
    [Arguments]   ${Field Requirements}
    Run Keyword If    "${Field Requirements}"=="${analogOnly}"              Wait Visible Do Action   ${channelType}    ${analogFlag}    ${dropdownList}
    ...    ELSE IF    "${Field Requirements}"=="${analogTxUnmuteCTCSS}"     Show Analog Tx Unmute CTCSS Fields
    ...    ELSE IF    "${Field Requirements}"=="${analogRxUnmuteCTCSS}"     Show Analog Rx Unmute CTCSS Fields
    ...    ELSE IF    "${Field Requirements}"=="${digitalOnly}"             Wait Visible Do Action   ${channelType}    ${digitalFlag}   ${dropdownList}
    ...    ELSE IF    "${Field Requirements}"=="${digitalRxUnmuteNACTGID}"  Show Digital Rx Unmute NAC TGID Fields
    Sleep   5s

Show Analog Tx Unmute CTCSS Fields
    Wait Visible Do Action   ${channelType}    ${analogFlag}    ${dropdownList}
    # sleep to let update msg appear
    Sleep   2s
    Wait Visible Do Action   ${txSignal}       ${CTCSSFlag}     ${dropdownList}

Show Analog Rx Unmute CTCSS Fields
    Wait Visible Do Action   ${channelType}       ${analogFlag}    ${dropdownList}
    # sleep to let update msg appear
    Sleep   2s
    Wait Visible Do Action   ${rxAnalogUnmute}    ${CTCSSFlag}     ${dropdownList}

Show Digital Rx Unmute NAC TGID Fields
    Wait Visible Do Action   ${channelType}       ${digitalFlag}    ${dropdownList}
    Sleep   3s
    ${selected}=    Get Selected List Value   ${channelType}
    Run Keyword If    '${selected}'=='${analogFlag}'    Run Keywords    Select From List By Value   ${channelType}    ${digitalFlag}   AND   Sleep   3s
    Wait Visible Do Action   ${rxDigitalUnmute}   ${NACTGIDFlag}    ${dropdownList}
