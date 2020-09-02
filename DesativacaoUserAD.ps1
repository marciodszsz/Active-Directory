

#Script de remoção e desativação de contas de usuario de rede no Active Directory




#variavel onde se encontra o arquivo txt com usuario para ser desativados.
$Memberof  = Get-Content -Path  "c:\user.txt"
#Variável onde se encontra o arquivo csv para importar os usuarios
$Users     = Import-csv -Path c:\users.csv
#Variável para armazenamento de porcentagem da duração do arquivo.
$i         = 0

# --------------1º Passo-----------------------------------
    #Alteração do grupo primario de usuários.
    
    Foreach ($Groups in $Users) {
        $i++
        Set-ADUser $Groups -Replace @{primaryGroupID=513}
    
        Write-Progress -Activity 'Alterando grupo principal' `
        -CurrentOperation $Groups `
        -PercentComplete (($i/ $Users.Count)*100)
        Start-Sleep -Milliseconds 200
    }
    
# --------------2º Passo-----------------------------------
    #Remoção de grupos dos usuario que irão ser desativados
   
   Foreach ($User in $Users) {
        $i++
        Get-ADUser -Filter 'Name -eq $User' | Remove-ADPrincipalGroupMembership `
        -MemberOf $Memberof `
        -Confirm:$false `
        -Verbose
        
        Write-Progress -Activity 'Removendo grupo dos usuarios' `
        -CurrentOperation $User `
        -PercentComplete (($i/ $Users.Count)*100)
        Start-Sleep -Milliseconds 200
    }
    
# --------------3º Passo-----------------------------------
    #Desativação de contas de rede dos usuarios.

    Foreach ($User in $Users) {
        $i++
        Disable-ADAccount -Identity $User -Confirm:$false -Verbose
         
        Write-Progress -Activity 'Desativando contas de redes dos usuarios' `
        -CurrentOperation $User `
        -PercentComplete (($i/ $Users.Count)*100)
        Start-Sleep -Milliseconds 200

    }

# -------------4º Passo------------------------------------
    #Move contas dos medicos desativados para uma pasta de desativados 
    
    Foreach ($User in $Users) {
        $i++
        Get-ADUser $User | Move-ADObject -TargetPath "OU=Desligados,DC=com,DC=br" `
        -Verbose

        Write-Progress -Activity 'Movendo contas de redes usuarios' `
        -CurrentOperation $User `
        -PercentComplete (($i/ $Users.Count)*100)
        Start-Sleep -Milliseconds 200
    }

        
        
        
        
                                                                                                                    # By - Márcio de S.souza
