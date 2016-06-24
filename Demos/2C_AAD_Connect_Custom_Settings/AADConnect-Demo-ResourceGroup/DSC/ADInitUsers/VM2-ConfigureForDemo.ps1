#
# VM2_ConfigureForDemo.ps1
#
$UserPassword = "P@ssword1" | ConvertTo-SecureString -AsPlainText -Force

New-ADUser -Name Bob -GivenName Bob -Surname Jasper -DisplayName "Bob Jasper" -UserPrincipalName bob@contoso.com -AccountPassword @UserPassword -ChangePasswordAtLog $False -PasswordNeverExpires $True -Enabled $True

New-ADUser -Name Sam -GivenName Sam -Surname Vineyard -DisplayName "Sam Vineyard" -UserPrincipalName sam@contoso.com -AccountPassword @UserPassword -ChangePasswordAtLog $False -PasswordNeverExpires $True -Enabled $True

New-ADUser -Name David -GivenName David -Surname Devready -DisplayName "David Devready" -UserPrincipalName david@contoso.com -AccountPassword @UserPassword -ChangePasswordAtLog $False -PasswordNeverExpires $True -Enabled $True

New-ADUser -Name Larry -GivenName Larry -Surname Goza -DisplayName "Larry Goza" -UserPrincipalName larry@contoso.com -AccountPassword @UserPassword -ChangePasswordAtLog $False -PasswordNeverExpires $True -Enabled $True

$salesGroupName = "Sales"
New-ADGroup -Name $salesGroupName -DisplayName "Contoso Sales" -Description "Users in the Sales dept." -GroupScope Global 

$userBob = Get-ADUser -Identity Bob
Add-ADGroupMember -Identity $salesGroupName -Members $userBob

$devGroupName = "Development"
New-ADGroup -Name $devGroupName -DisplayName "Development and Test Team" -Description "Users in the Engineering" -GroupScope Global 

$userDavid = Get-ADUser -Identity David
Add-ADGroupMember -Identity $devGroupName -Members $userDavid

$userLarry = Get-ADUser -Identity Larry
Add-ADGroupMember -Identity $devGroupName -Members $userLarry 

# Add DNS Conditional Forwarder
Add-DnsServerConditionalForwarderZone -Name "azurecoe.com" -MasterServers "10.0.0.4"