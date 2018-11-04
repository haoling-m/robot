*** Settings ***
Documentation     FSI related resource file with reusable keywords and variables.
Resource          properties.robot
Resource          utility_resource.robot
Library           Selenium2Library

*** Variables ***
#INPUT IDs
${fsiLink}              edit_radio_fsi

${controlPort}          fsi_control_port
${controlPortErr}       tooltip_fsi_control_port

${voicePort}            fsi_voice_port
${voicePortErr}         tooltip_fsi_voice_port

${controlAttempt}       ctrl_attempt_limit
${controlAttemptErr}    tooltip_ctrl_attempt_limit

${connLossLimit}        connectivity_loss_limit
${connLossLimitErr}     tooltip_connectivity_loss_limit

${controlRetry}         ctrl_retry_timer
${controlRetryErr}      tooltip_ctrl_retry_timer

${voterReport}          voter_report_period
${voterReportErr}       tooltip_voter_report_period

${voiceEoSTimeout}      fsi_edit_con_eos
${voiceEoSTimeoutErr}   tooltip_fsi_edit_con_eos

${voiceBuffer}          voice_buffer_size
${voiceBufferErr}       tooltip_voice_buffer_size

${lenthErrClass}        tooltip-inner
${lenthErrClassMsg}     Max allowed characters are 25.
${success}              error_lbl_editFSI
${successMsg}           Updated Successfully
${portErrEven}          Only even numbers are allowed.
${controlRetryErrStep}  Only two decimal points numbers are allowed.
${errNumber}            Only numbers are allowed.
${errRange}             Invalid Range.

#INPUT VALUES
#INVALID
${NumberOnlyWrong}      Z8

${portLow}              998
${portHigh}             65536
${portOdd}              1001
${portStep}             1000.1

${controlAttemptLow}    0
${controlAttemptHigh}   11
${controlAttemptStep}   1.1

${connLossLimitLow}     0
${connLossLimitHigh}    101
${connLossLimitStep}    1.1

${controlRetryLow}      0.00
${controlRetryHigh}     10.01
${controlRetryStep}     0.011

${voterReportLow}       0
${voterReportHigh}      80001
${voterReportStep}      1.1

${voiceEoSTimeoutLow}   0.009
${voiceEoSTimeoutHigh}    11
${voiceEoSTimeoutStep}    0.001

${voiceBufferLow}       1
${voiceBufferHigh}      501
${voiceBufferStep}      2.1

#VALID
${portMin}              1000
${portMax}              65534

${controlAttemptMin}    1
${controlAttemptMax}    10

${connLossLimitMin}     1
${connLossLimitMax}     100

${controlRetryMin}      0.01
${controlRetryMax}      10.00

${voterReportMin}       1
${voterReportMax}       80000

${voiceEoSTimeoutMin}   0.01
${voiceEoSTimeoutMax}   10.00

${voiceBufferMin}       2
${voiceBufferMax}       500

*** Keywords ***
Navigate To FSI Advanced
    Reload Page
    Sleep   5s
    Wait Visible Do Action    ${fsiLink}    click   ${clickable}
    Sleep   1s
