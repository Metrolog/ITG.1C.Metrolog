<# 
.Synopsis 
    Скрипт подготовки среды сборки и тестирования проекта
.Description 
    Скрипт подготовки среды сборки и тестирования проекта.
    Используется в том числе и для подготовки среды на серверах appveyor.
.Link 
    https://github.com/Metrolog/MeasurementUnits
.Example 
    .\install.ps1 -GUI;
    Устанавливаем необходимые пакеты, в том числе - и графические среды.
#> 
[CmdletBinding(
    SupportsShouldProcess = $true
    , ConfirmImpact = 'Medium'
    , HelpUri = 'https://github.com/Metrolog/MeasurementUnits'
)]
 
param (
    # Ключ, определяющий необходимость установки визуальных средств.
    # По умолчанию устанавливаются только средства для командной строки.
    [Switch]
    $GUI
) 

Function Execute-ExternalInstaller {
    [CmdletBinding(
        SupportsShouldProcess = $true
        , ConfirmImpact = 'Medium'
    )]
    param (
        [String]
        $LiteralPath
        ,
        [String]
        $ArgumentList
    )

    $pinfo = [System.Diagnostics.ProcessStartInfo]::new();
    $pinfo.FileName = $LiteralPath;
    $pinfo.RedirectStandardError = $true;
    $pinfo.RedirectStandardOutput = $true;
    $pinfo.RedirectStandardInput = $true;
    $pinfo.UseShellExecute = $false;
    $pinfo.Arguments = $ArgumentList;
    $p = [System.Diagnostics.Process]::new();
    try {
        $p.StartInfo = $pinfo;
        $p.Start() | Out-Null;
        $p.WaitForExit();
        $LASTEXITCODE = $p.ExitCode;
        $p.StandardOutput.ReadToEnd() `
        | Write-Output `
        ;
        if ( $p.ExitCode -ne 0 ) {
            $p.StandardError.ReadToEnd() `
            | Write-Error `
            ;
        };
    } finally {
        $p.Close();
    };
}

switch ( $env:PROCESSOR_ARCHITECTURE ) {
    'amd64' { $ArchPath = 'x64'; }
    'x86'   { $ArchPath = 'x86'; }
    default { Write-Error 'Unsupported processor architecture.'}
};
$ToPath = @();

if ( 
    ( -not ( $env:APPVEYOR -eq 'True' ) ) `
    -and ( -not $env:ChocolateyInstall ) `
) {
    Invoke-WebRequest -Uri 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression;
};

& choco install GitVersion.Portable --confirm --failonstderr | Out-String -Stream | Write-Verbose;
& choco install GitReleaseNotes.Portable --confirm --failonstderr | Out-String -Stream | Write-Verbose;

if ( -not ( $env:APPVEYOR -eq 'True' ) ) {
    & choco install git --confirm --failonstderr | Out-String -Stream | Write-Verbose;
    & choco install openssl --confirm --failonstderr | Out-String -Stream | Write-Verbose;
};

if ( $env:APPVEYOR -eq 'True' ) {

    $ITSLogin = '20005700694';
    $ITSPassword = ConvertTo-SecureString 'GhbznyjtGentitcndbt' -AsPlainText -Force;
    $ITSCredential = New-Object System.Management.Automation.PSCredential($ITSLogin, $ITSPassword);

    $OSInfo = @"
        {
            "key": "ClientOSVersion",
            "value": "version 6.2  (Build 9200)"
        },
        {
            "key": "SystemLanguage",
            "value": "ru"
        },
        {
            "key": "ClientPlatformType",
            "value": "Windows_x86"
        }
"@ `
    ;

    $UpdateInfoResponse = Invoke-WebRequest `
        -Uri 'https://update-api.1c.ru/update-platform/programs/update/info' `
        -Method Post `
        -ContentType 'application/json' `
        -DisableKeepAlive `
        -Body @"
{
    "programName": "SSL",
    "versionNumber": "2.3.4.8",
    "platformVersion": "",
    "programNewName": "",
    "redactionNumber": "",
    "updateType": "NewPlatform",
    "additionalParameters": [ $OSInfo ]
}
"@ `
    ;
    $UpdateInfo = $UpdateInfoResponse.Content | ConvertFrom-Json;

    $PlatformUpdateResponse = Invoke-WebRequest `
        -Uri "https://update-api.1c.ru/update-platform/programs/update/" `
        -Credential $ITSCredential `
        -Method Post `
        -ContentType 'application/json' `
        -DisableKeepAlive `
        -Body @"
{
    "upgradeSequence": null,
    "programVersionUin": null,
    "platformDistributionUin": "$( $UpdateInfo.platformUpdateResponse.distributionUin )",
    "login": "$ITSLogin",
    "password": "$( $ITSCredential.GetNetworkCredential().Password )",
    "additionalParameters": [ $OSInfo ]
}
"@ `
    ;
    $PlatformUpdateInfo = $PlatformUpdateResponse.Content | ConvertFrom-Json;
    $DownloadFileResponse = Invoke-WebRequest `
        -Uri ( $PlatformUpdateInfo.platformDistributionUrl ) `
        -OutFile 'setup.zip' `
        -Method Get `
        -Credential $ITSCredential `
        -DisableKeepAlive `
    ;

};

if ( $GUI ) {
    & choco install SourceTree --confirm --failonstderr | Out-String -Stream | Write-Verbose;
};

Write-Verbose 'Preparing PATH environment variable...';
if ($PSCmdLet.ShouldProcess('PATH', 'Установить переменную окружения')) {
    $Path = `
        ( `
            ( ( [Environment]::GetEnvironmentVariable( 'PATH', [System.EnvironmentVariableTarget]::Process ) ) -split ';' ) `
            + $ToPath `
            | Sort-Object -Unique `
        ) `
    ;
    Write-Verbose 'Path variable:';
    $Path | % { Write-Verbose "    $_" };
    $env:Path = $Path -join ';';
    [System.Environment]::SetEnvironmentVariable( 'PATH', $env:Path, [System.EnvironmentVariableTarget]::User );
};
