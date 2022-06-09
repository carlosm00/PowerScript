#Script 2 de ASO02_T08 de Alex Covalencu y Carlos Mena.

#$ErrorActionPreference="SilentlyContinue"
$nuevaPass = convertto-securestring "Monitor?2" -asplaintext -force
$clase = Read-Host "Introduzca un nombre de grupo/clase existente [p.e. asir1]"

$indentity= "OU=$clase,OU=Usuarios,DC=ASO212-220,DC=priv"
$comproba= (Get-ADOrganizationalUnit -Identity $indentity).DistinguishedName

#Función de cambio
function cambioContra {
   
    #recogemos cada uno de los usuarios en una variable
    $usuarios = @((Get-ADUser -Filter * -SearchBase $indentity ).SAMAccountName)
         
    #Cambiamos la password y prohibimos su cambio

    for($i=0;$usuarios[$i] -ne $NULL;$i++){
       
        $indentity2 ="CN=$($usuarios[$i]),OU=$clase,OU=Usuarios,DC=ASO212-220,DC=priv"

        Set-ADAccountPassword -Identity $usuarios[$i] -NewPassword $nuevaPass -reset

        #bloqueamos el cambio de password
        Set-ADUser -SamAccountName $usuarios[$i] -Identity $indentity2 -CannotChangePassword:$true -PassThru
    }

    Write-host "Cambio realizado!" -BackgroundColor black -ForegroundColor green
}

#comprobar que existe
if ($comproba -eq $indentity) {
        cambioContra
}
else {
   Write-Host "ERROR: Que esa OU no existe!" -BackgroundColor red -ForegroundColor yellow
   $clase = Read-Host "Introduzca un nombre de grupo/clase EXISTENTE [p.e. asir1]"
   $indentity= "OU=$clase,OU=Usuarios,DC=ASO212-220,DC=priv"
   $comproba= (Get-ADOrganizationalUnit -Identity $indentity).DistinguishedName

   if ($comproba -eq $indentity) {
        cambioContra
    }
}