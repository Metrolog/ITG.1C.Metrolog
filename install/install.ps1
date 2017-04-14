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
    "additionalParameters": [
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
    ]
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
    "login": "20005700694",
    "password": "GhbznyjtGentitcndbt",
    "additionalParameters": [
        {
            "key": "IBID",
            "value": "4b115c48-804b-41da-9218-9c3bd3a6a4d4"
        },
        {
            "key": "ClientOSVersion",
            "value": "version 6.2  (Build 9200)"
        },
        {
            "key": "ConfigMainLanguage",
            "value": "ru"
        },
        {
            "key": "SystemLanguage",
            "value": "ru"
        },
        {
            "key": "Vendor",
            "value": "Фирма \"1С\""
        },
        {
            "key": "ClientTimeOffsetGMT",
            "value": "10800"
        },
        {
            "key": "ConfigName",
            "value": "БиблиотекаСтандартныхПодсистемДемо"
        },
        {
            "key": "ClientPlatformType",
            "value": "Windows_x86"
        },
        {
            "key": "ConfigurationID",
            "value": "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\r\n"
        },
        {
            "key": "CurLocalizationCode",
            "value": "ru"
        },
        {
            "key": "ConfigVersion",
            "value": "2.3.4.8"
        },
        {
            "key": "ConfigLanguage",
            "value": "ru"
        },
        {
            "key": "LibraryVersion",
            "value": "2.1.8.4"
        },
        {
            "key": "DomainZone",
            "value": "ru"
        }
    ]
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
