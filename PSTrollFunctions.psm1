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

#MAIN FUNCTIONS
Function Set-AudioMax {
    Start-AudioControl
    [audio]::Volume = 1
}

Function Set-AudioMin {
    Start-AudioControl
    [audio]::Volume = 0
}

Function Set-AudioLevel {
    Param(
        [parameter(Mandatory=$true)]
        [ValidateRange(0,1)]
        [double]$AudioLevel
    )

    Start-AudioControl
    [audio]::Volume = $AudioLevel
}

Function Send-CatFact 
{
    Add-Type -AssemblyName System.speech
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $CatFact = Invoke-RestMethod -Uri 'https://catfact.ninja/fact' -Method Get | Select-Object -ExpandProperty fact
    $SpeechSynth.Speak("did you know?")
    $SpeechSynth.Speak($CatFact)
}

Function Send-RickRoll 
{
    Invoke-Expression (New-Object Net.WebClient).DownloadString("http://bit.ly/e0Mw9w")
}

Function Send-RowBoat 
{
    Add-Type -AssemblyName System.speech
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $SpeechSynth.Speak("Row, Row, Row your boat gently down the stream. Merrily! Merrily! Merrily! Life is but a dream.")    
}

Function Send-Message([string]$Message)
{
    msg.exe * $Message
}

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

Function Send-NotificationSoundSpam
{
    param
    (
        [Parameter()][int]$Interval = 4
    )

    Get-ChildItem C:\Windows\Media\ -File -Filter *.wav | Select-Object -ExpandProperty Name | Foreach-Object { Start-Sleep -Seconds $Interval; (New-Object Media.SoundPlayer "C:\WINDOWS\Media\$_").Play(); }
}

Function Send-VoiceMessage([string]$Message)
{
    Add-Type -AssemblyName System.speech
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $SpeechSynth.Speak($Message)
}

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


