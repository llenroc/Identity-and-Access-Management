#
# VM1_ConfigureForDemo.ps1
#
$UserPassword = "P@ssword1" | ConvertTo-SecureString -AsPlainText -Force

New-ADUser -Name Jane -GivenName Jane -Surname Smith -DisplayName "Jane Smith" -UserPrincipalName jane@azurecoe.com -AccountPassword @UserPassword -ChangePasswordAtLog $False -PasswordNeverExpires $True -Enabled $True

New-ADUser -Name Adam -GivenName Adam -Surname Rolater -DisplayName "Adam Rolater" -UserPrincipalName adam@azurecoe.com -AccountPassword @UserPassword -ChangePasswordAtLog $False -PasswordNeverExpires $True -Enabled $True

$financeGroupName = "Finance"
New-ADGroup -Name $financeGroupName -DisplayName "Finance Group" -Description "Users in the Finance Dept." -GroupScope Global

$userJane = Get-ADUser -Identity Jane
Add-ADGroupMember -Identity $financeGroupName -Members $userJane  

# Add DNS Conditional Forwarder
Add-DnsServerConditionalForwarderZone -Name "contoso.com" -MasterServers "10.0.1.4"
