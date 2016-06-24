#
# ConfigureVM.ps1
#
Configuration Main
{
	param(
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds
	)

	Import-DscResource -ModuleName xActiveDirectory, PSDesiredStateConfiguration

	Node localhost
    {
    	[System.Management.Automation.PSCredential ]$DomainCreds = `
    	  New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)

    	Script InitDataDisk {
    		TestScript = {
	    		Test-Path "F:\"
	    	}

	        SetScript  = {
        		Get-Disk -FriendlyName "Microsoft Virtual Disk" | `
        		Initialize-Disk –PassThru | `
        		New-Partition -AssignDriveLetter -UseMaximumSize | `
        		Format-Volume –Confirm:$False –Force 
        	}

        	GetScript = {
    	    	@{Result = "InitDataDisk"}
    	    }
        }    

    	File adNTDSFolder {
	    	DestinationPath = "F:\NTDS"
    		Ensure = "Present"
    		Type = "Directory"
    		DependsOn = "[Script]InitDataDisk"
    	}
	
    	File adSYSVOLFolder {
    		DestinationPath = "F:\SYSVOL"
    		Ensure = "Present"
    		Type = "Directory"
	    	DependsOn = "[Script]InitDataDisk"
	    }

    	WindowsFeature ADDSInstall { 
            Ensure = "Present" 
            Name = "AD-Domain-Services"
		    DependsOn = "[File]adNTDSFolder","[File]adSYSVOLFolder"
        } 

		WindowsFeature ADDSTools { 
            Ensure = "Present" 
            Name = "RSAT-ADDS"
		    DependsOn = "[WindowsFeature]ADDSInstall"
        } 

    	xADDomain FirstDS {
            DomainName = $DomainName
            DomainAdministratorCredential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            DatabasePath = "F:\NTDS"
            LogPath = "F:\NTDS"
            SysvolPath = "F:\SYSVOL"
	    	DependsOn = "[WindowsFeature]ADDSTools"
        }
	}
}

