#!/bin/bash
poststr=`cat`
# Get data from Client, Use POST method.
# Data format: username=abc&pwd=def&pwd2=def
decodestr=$(printf $(echo -n $poststr | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g'))
# Decode URL
username=$(echo -n $decodestr | cut -d \& -f 1)
# Get username=abc
pwdstr=$(echo -n $decodestr | cut -d \& -f 2)
# Get pwd=def
pwd2str=$(echo -n $decodestr | cut -d \& -f 3)
# Get pwd2=def
usernamevalue=$(echo -n $username | cut -d \= -f 2)
# Split $username to get value 'abc'
pwdvalue=$(echo -n $pwdstr | cut -d \= -f 2)
# Split $pwd to get value 'def'
pwd2value=$(echo -n $pwd2str | cut -d \= -f 2)
# Split $pwd2 to get value 'def'
user=$(echo -n $(echo -n $usernamevalue | sed 's/+/ /g'))
# Replace '+' with ' '
realm="Downloads"
# This Must match what you wrote in auth module config file
pwd=$(echo -n $(echo -n $pwdvalue | sed 's/+/ /g'))
pwd2=$(echo -n $(echo -n $pwd2value | sed 's/+/ /g'))
if [ "$pwd" == "$pwd2" ] && [ `grep -c "$user" /etc/lighttpd/lighttpd.user` -eq '0' ]
# /etc/lighttpd/lighttpd.user is user data file of lighttpd auth module, with htdigest method
then
    hash=$(echo -n "$user:$realm:$pass" | md5sum | cut -b -32)
    text="$user:$realm:$hash"
    echo $text >> /etc/lighttpd/lighttpd.user
    echo "Content-Type:text/html;charset=utf-8"
    echo ""
    echo "<html>"
    echo "<head>"
    echo "<title>注册完成!</title>"
    echo "</head>"
    echo "<style>"
    echo ".text{display:inline-block;text-align:right;width:100px;}"
    echo ".info{display:inline-block;text-align:left;width:100px}"
    echo ".return{width:300px;left:70px;border: 1px;border-color: rgba(0, 153, 204, 0.3);border-radius: 5px;background: rgba(0, 183, 234, 0.8);}"
    echo ".return:hover{background: rgba(0, 183, 234, 0.5);}"
    echo "</style>"
    echo "<body style=\"background-color: rgba(0, 153, 204, 0.6);\">"
    echo "<div style=\"font-weight:bold;font-family:YouYuan,'Microsoft  YaHei',SimSun;position:fixed;background:rgb(0,153,204);left:0px;right:0px;height:226px;margin-left:auto;margin-right:auto;top:300px;text-align:center;\">"
    echo "<br/>"
    echo "<label class=\"text\">写入的信息:</label><label class=\"info\">$text</label><br/>"
    echo "<label class=\"text\">用户名:</label><label class=\"info\">$user</label><br/>"
    echo "<label class=\"text\">密码:</label><label class=\"info\">$pwd</label><br/>"
    echo "<br/>"
    echo "<button type=\"button\" class=\"return\" onclick=\"javascript:history.back();\">返回</button>"
    echo "</div>"
    echo "</body>"
    echo "</html>"  
elif [ "$pwd" != "$pwd2" ]
then
    echo "Content-Type:text/html;charset=utf-8"
    echo ""
    echo "<html>"
    echo "<head>"
    echo "<title>注册失败!</title>"
    echo "</head>"
    echo "<style>"
    echo ".text{display:inline-block;text-align:right;width:150px;}"
    echo ".info{display:inline-block;text-align:left;width:150px}"
    echo ".title{display:inline-block;text-align:center;width:300px}"
    echo ".return{width:300px;left:70px;border: 1px;border-color: rgba(0, 153, 204, 0.3);border-radius: 5px;background: rgba(0, 183, 234, 0.8);}"
    echo ".return:hover{background: rgba(0, 183, 234, 0.5);}"
    echo "</style>"
    echo "<body style=\"background-color: rgba(0, 153, 204, 0.6);\">"
    echo "<div style=\"font-weight:bold;font-family:YouYuan,'Microsoft  YaHei',SimSun;position:fixed;background:rgb(0,153,204);left:0px;right:0px;height:226px;margin-left:auto;margin-right:auto;top:300px;text-align:center;\">"
    echo "<br/>"
    echo "<label class=\"title\">两次输入的密码不一致!</label><br/><br/>"
    echo "<label class=\"text\">第一次的密码:</label><label class=\"info\">$pwd</label><br/>"
    echo "<label class=\"text\">第二次的密码:</label><label class=\"info\">$pwd2</label><br/>"
    echo "<br/>"
    echo "<button type=\"button\" class=\"return\" onclick=\"javascript:history.back();\">返回</button>"
else
    echo "Content-Type:text/html;charset=utf-8"
    echo ""
    echo "<html>"
    echo "<head>"
    echo "<title>注册失败!</title>"
    echo "</head>"
    echo "<style>"
    echo ".text{display:inline-block;text-align:right;width:150px;}"
    echo ".info{display:inline-block;text-align:left;width:150px}"
    echo ".title{display:inline-block;text-align:center;width:300px}"
    echo ".return{width:300px;left:70px;border: 1px;border-color: rgba(0, 153, 204, 0.3);border-radius: 5px;background: rgba(0, 183, 234, 0.8);}"
    echo ".return:hover{background: rgba(0, 183, 234, 0.5);}"
    echo "</style>"
    echo "<body style=\"background-color: rgba(0, 153, 204, 0.6);\">"
    echo "<div style=\"font-weight:bold;font-family:YouYuan,'Microsoft  YaHei',SimSun;position:fixed;background:rgb(0,153,204);left:0px;right:0px;height:226px;margin-left:auto;margin-right:auto;top:300px;text-align:center;\">"
    echo "<br/>"
    echo "<label class=\"title\">用户$user已存在!</label><br/><br/>"
    echo "<button type=\"button\" class=\"return\" onclick=\"javascript:history.back();\">返回</button>"
fi
