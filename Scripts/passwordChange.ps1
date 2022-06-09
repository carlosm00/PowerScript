<#
   .Description
   Project: PowerScript
   Author/Autor: Carlos Mena (https://github.com/carlosm00)
   Definition: PowerShell Script for forcing AD user password change and forbiding the change again. 
      Feel free to contribute on GitHub (https://github.com/carlosm00/PowerScript)

#>

#$ErrorActionPreference="SilentlyContinue"
$identity = Read-Host "Provide the group of users as an AD Organizational Unit Identity: "
$textToForget= Read-Host "Please, provide the new generic password: "
$newPass = convertto-securestring $textToForget -asplaintext -force
$textToForget = ""

$check= (Get-ADOrganizationalUnit -Identity $indentity).DistinguishedName

# Change function
function PasswordChange {
   
    # Collecting users from provided identity
    $users = @((Get-ADUser -Filter * -SearchBase $indentity ).SAMAccountName)
         
    # Iterative change of password
    foreach ($user in $users)
        Set-ADAccountPassword -Identity $user -NewPassword $newPass -reset

        # Block option to change password
        Set-ADUser -SamAccountName $user -Identity $indentity -CannotChangePassword:$true -PassThru
    }

    Write-host "Change completed!" -BackgroundColor black -ForegroundColor green
}

# Checking that they actually exist
if ($check -eq $indentity) {
        PasswordChange
}
else {
   Write-Host "ERROR: OU does not exists" -BackgroundColor red -ForegroundColor yellow
   $identity = Read-Host "Provide the group of users as an AD Organizational Unit Identity: "
   $textToForget= Read-Host "Please, provide the new generic password: "
   $newPass = convertto-securestring $textToForget -asplaintext -force
   $textToForget = ""
   $check= (Get-ADOrganizationalUnit -Identity $indentity).DistinguishedName

   if ($check -eq $indentity) {
        PasswordChange
    }
}