# PowerShell-Troll
A PowerShell module that contains different functions that can be used for pranking your fellow co-worker or anyone else for that matter. Keep in mind that this is a very simply module and not alot of time was spend making all of them as good or well documented at all.

All of the functions can either be copy pasted in a PSSession or import the module on the victim PC. All of the functions are designed for a laugh and not destruction. The functions are scraped of the internet by various sources or transformed into functions by me.

I am not responsible for any damage caused. 

## Usage

```
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/perplexityjeff/PowerShell-Troll/master/PSTrollFunctions.psm1" -OutFile "PSTrollFunctions.psm1"
Import-Module .\PSTrollFunctions.psm1
```

## Functions

<table>
  <tr>
    <td><tt>Disable-Mouse</tt></td>
	<td>Disables the victims mouse.</td>
  </tr>
  <tr>
    <td><tt>Enable-Mouse</tt></td>
	<td>Enables the victims mouse again.</td>
  </tr>
  <tr>
    <td><tt>Set-Wallpaper</tt></td>
	<td>Enables you to set the wallpaper of a victim. Work in progress currently as it doesn't trigger an update.</td>
  </tr>
  <tr>
    <td><tt>Start-AudioControl</tt></td>
	<td>Enables you to control the audio level by for example [audio]::Volume = 1 (100%).</td>
  </tr>
  <tr>
    <td><tt>Set-AudioLevel</tt></td>
	<td>Enables you to control the audio level in a range from 0 to 1.0 (100%) by using a double e.g 0.25.</td>
  </tr>
  <tr>
    <td><tt>Set-AudioMax</tt></td>
	<td>Enables you to control the audio level and set it to 100% to maximize Rick Ashley output.</td>
  </tr>
  <tr>
    <td><tt>Set-AudioMin</tt></td>
	<td>Enables you to control the audio level and set it to 0% to minimize [insert far to loud of a song here].</td>
  </tr>
	<tr>
    <td><tt>Unmute-Audio</tt></td>
	<td>Enables you to control the audio to unmute it.</td>
  </tr>
  <tr>
    <td><tt>Mute-Audio</tt></td>
	<td>Enables you to control the audio to mute it.</td>
  </tr>
  <tr>
    <td><tt>Send-Alarm</tt></td>
	<td>Send the traditional annoyingly great alarm clock sound you know and love.</td>
  </tr>
    <td><tt>Send-CatFact</tt></td>
	<td>Retrieves a random $CatFact and plays it in audio to the victim.</td>
  </tr>
  </tr>
    <td><tt>Send-Joke</tt></td>
	<td>Sends a random joke to your victim, has a switch to send as a messagebox.</td>
  </tr>
  </tr>
    <td><tt>Send-ChuckNorrisFact</tt></td>
	<td>Retrieves a random $ChuckFact and plays it in audio to the victim.</td>
  </tr>
  </tr>
    <td><tt>Send-DadJoke</tt></td>
	<td>Retrieves a random $DadJoke and plays it in audio to the victim.</td>
  </tr>
  <tr>
    <td><tt>Send-FakeUpdate</tt></td>
        <td>Starts a fake Windows 10 update screen</td>
  </tr>
  <tr>
    <td><tt>Send-Gandalf</tt></td>
        <td>Starts playing the epic sax guy gandalf edition.</td>
  </tr>
  <tr>
    <td><tt>Send-Message</tt></td>
        <td>Send a messagebox with your text to all logged in users.</td>
  </tr>
  <tr>
    <td><tt>Send-RickRoll</tt></td>
	<td>Starts playing the best song of all time.</td>
  </tr>
  <tr>
    <td><tt>Send-RowBoat</tt></td>
	<td>Sends an attempt of sing Row, Row Row your boat.</td>
  </tr>
  <tr>
    <td><tt>Open-CDDrive</tt></td>
	<td>Attempts to command the CD Drive it finds to Eject.</td>
  </tr>
  <tr>
    <td><tt>Close-CDDrive</tt></td>
	<td>Attempts to command the CD Drive it finds to Close.</td>
  </tr>
  <tr>
    <td><tt>Send-NotificationSoundSpam</tt></td>
	<td>Loops through the whole C:\Windows\Media directory and plays every wav file it finds in there with a default but customizable 4 second delay.</td>
  </tr>
  <tr>
    <td><tt>Send-VoiceMessage</tt></td>
	<td>Send your lovely message to your co-worker in all its robot computer voice glory.</td>
  </tr>
  <tr>
    <td><tt>Send-SuperMario</tt></td>
	<td>Start playing Super Mario using console beeps.</td>
  </tr>
   <tr>
    <td><tt>Send-HappyBirthday</tt></td>
	<td>Start playing Happy Birthday using console beeps.</td>
  </tr>
</table>

## License

This project is licensed under the [MIT license](LICENSE)
 
## Tested
 
All of them were tested and working as far as I know.
 
