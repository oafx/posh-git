Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git


# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {

    #Added prompt binding - Inspired by http://einsteintech.wordpress.com/2009/01/19/a-powershell-prompt-with-a-purpose/
    #See URL for usage and description.

    [CmdletBinding(DefaultParameterSetName='Prompt')]
    param ( 
        
        [Parameter(ParameterSetName='Minimize')]
        [Switch] $Minimize,
        
        [Parameter(ParameterSetName='Hide')]
        [Switch] $Hide,
        
        [Parameter(ParameterSetName='Show')]
        [Switch] $Show
        
    )

    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    #Write-Host($pwd.ProviderPath) -nonewline

    switch ( $PSCmdlet.ParameterSetName ) {
        Minimize { $Global:PromptVisibility = 'Minimized' }
        Hide     { $Global:PromptVisibility = 'Hidden' }
        Show     { $Global:PromptVisibility = 'Default' }
        Prompt   {
            switch ( $PromptVisibility ) {
                Minimized { Write-Host("PS $(Split-Path $PWD -Leaf)") -nonewline }
                Hidden    { Write-Host("PS") -nonewline }
                Default   { Write-Host("$PWD") -nonewline }
            }
        }
    }

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Enable-GitColors

Pop-Location

Start-SshAgent -Quiet
