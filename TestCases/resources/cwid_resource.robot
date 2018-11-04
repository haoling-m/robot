*** Settings ***
Documentation     CWID related resource file with reusable keywords and variables.
Resource          properties.robot
Resource          utility_resource.robot
Library           Selenium2Library

*** Variables ***
#INPUT IDs
${cwidLink}               edit_radio_cwid
${cwidEnabled}            cwid_enabled
${cwidMode}               cwid_mode
${interval}               cwid_interval
${intervalErr}            tooltip_cwid_interval
${wpm}                    cwid_wpm
${wpmErr}                 tooltip_cwid_wpm
${transmit1}              cwid_transmit_string0
${transmit2}              cwid_transmit_string1
${transmit2Clr}           ts1b
${transmit3}              cwid_transmit_string2
${transmit3Clr}           ts2b
${transmit4}              cwid_transmit_string3
${transmit4Clr}           ts3b
${transmit5}              cwid_transmit_string4
${transmit5Clr}           ts4b
${transmit6}              cwid_transmit_string5
${transmit6Clr}           ts5b
${transmit7}              cwid_transmit_string6
${transmit7Clr}           ts6b
${transmit8}              cwid_transmit_string7
${transmit8Clr}           ts7b
${transmitClear}          Clear
${transmitErr}            tooltip_cwid_string
${transmitErrClass}       class=tooltip-inner
${transmitErrClassText}   Max allowed characters are 25.

${freq}                   cwid_tone_frequency
${freqErr}                tooltip_cwid_tone_freq
${level}                  cwid_tone_level
${levelErr}               tooltip_cwid_tone_level
${interrupt}              cwid_interruptible
${updateSuccessful}       edit_cwid_lbl
${updateSuccessfulMsg}    CWID updated successfully.

#INPUT VALUES
#INVALID
${NumberOnlyWrong}      Z8
${AlphanumericWrong}    ^^^

${intervalLow}          0
${intervalHigh}         241
${intervalStep}         1.1

${wpmLow}               19
${wpmHigh}              26
${wpmStep}              20.1

${transmitHigh}         01234567890123456789123456

${freqLow}              399
${freqHigh}             2001
${freqStep}             400.1

${levelLow}             29
${levelHigh}            101
${levelStep}            30.1

#VALID
@{cwidEnabledList}      Enabled         Disabled
@{cwidModeList}         Immediate       Wait for TX
@{interruptList}        Interruptible   Not interruptible

${intervalMin}          1
${intervalMax}          240

${wpmMin}               20
${wpmMax}               25

${transmitMin}          0
${transmitMax}          012345678901234567891234

${freqMin}              400
${freqMax}              2000

${levelMin}             30
${levelMax}             100

${listFlag}             <class 'list'>
${typeListFlag}         <type 'list'>

*** Keywords ***
Navigate To CWID
    Wait Visible Do Action    ${cwidLink}   click   ${clickable}
    Sleep   1s
