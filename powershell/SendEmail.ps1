$EmailFrom="jeff.moss@azurepremium.com"
$EmailTo="jeff.moss@azurepremium.com"
$Subject="Subject"
$Body="Body"
$SMTPServer="smtp.oramoss.com"
$SMTPClient=New-Object Net.Mail.SmtpClient($SMTPServer,25)
$SMTPClient.EnableSsl=$false
#$SMTPClient=New-Object Net.Mail.SmtpClient($SMTPServer,587)
#$SMTPClient.EnableSsl=$true
$SMTPClient.Credentials=New-Object System.Net.NetworkCredential("jeff.moss@oramoss.com","<MYPASSWORD>")
$SMTPClient.Send($EMailFrom,$EMailTo, $Subject,$Body)
