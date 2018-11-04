*** Settings ***
Documentation     IP Settings related resource file with reusable keywords and variables.
Resource          properties.robot
Resource          utility_resource.robot
Library           Selenium2Library

*** Variables ***
#INPUT IDs
${editIP}           //*[@id="popupEditNetworkdlg"]/div/div/div[3]/button[1]
${confirmIP}        cls_upd_ip_now
${ipAddress}        cls_upd_ip_addres
${ipAddressErr}     tooltip_cls_upd_ip_addres
${ipAddressErrMsg}  IP is not valid.
${netmask}          cls_upd_netmask
${gateway}          cls_upd_gateway
${gatewayErr}       tooltip_cls_upd_gateway
${gatewayErrMsg}    Gateway is not valid.
${ntp1}             cls_upd_ntpserv_1
${ntp1Err}          tooltip_cls_upd_ntpserv_1
${ntp1ErrMsg}       Ntp Server1 Ip is not valid.
${ntp2}             cls_upd_ntpserv_2
${ntp2Err}          tooltip_cls_upd_ntpserv_2
${ntp2ErrMsg}       Ntp Server2 Ip is not valid.
${errMsg}           Only IPv4 address format is allowed.
${okErr}            ch_ip_err_mess_lbl

#INPUT VALUES
#INVALID
${ipv4Invalid1}    1.2.3
${ipv4Invalid2}    a.b.d.c
${ipv4Invalid3}    1.2.3/4
${ipv4Invalid4}    192.168.256.1

#VALID
@{netMaskOptions}   255.255.255.255/32     255.255.255.254/31      255.255.255.252/30      255.255.255.248/29      255.255.255.240/28      255.255.255.224/27      255.255.255.192/26      255.255.255.128/25      255.255.255.0/24        255.255.254.0/23    255.255.252.0/22    255.255.248.0/21    255.255.240.0/20    255.255.224.0/19    255.255.192.0/18    255.255.128.0/17    255.255.0.0/16   255.254.0.0/15     255.252.0.0/14      255.248.0.0/13      255.240.0.0/12      255.224.0.0/11      255.192.0.0/10      255.128.0.0/9       255.0.0.0/8     254.0.0.0/7     252.0.0.0/6     248.0.0.0/5     240.0.0.0/4     224.0.0.0/3     192.0.0.0/2     128.0.0.0/1

*** Keywords ***
Navigate To Editable IP Settings
    Navigate To     ${deviceMenu}
    Sleep           1s
    Navigate To     ${IPSettingsLink}
    Wait Visible Do Action  ${editIP}   click   ${clickable}
