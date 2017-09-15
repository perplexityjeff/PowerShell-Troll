# PowerShell-Troll
A PowerShell module that contains different functions that can be used for pranking your fellow co-worker. Keep in mind that this is a very simply module and not alot of time was spend making all of them as good or well documented at all.

All of the functions can either be copy pasted in a PSSession or import the module on the victim PC. All of the functions are designed for a laugh and not destruction. They functions are scrapped of the internet by various sources or transformed into functions by me.

I am not responsible for any damage caused. 

## Usage

```
Import-Module .\PSTrollFunctions.psm1
```

## Functions

<table>
  <tr>
    <td><tt>Start-AudioControl</tt></td>
	<td>Enables you control the audio level by for example [audio]::Volume = 1 (100%)</td>
  </tr>
  <tr>
    <td><tt>Set-AudioMax</tt></td>
	<td>Enables you control the audio level and set it to 100% to maximize Rick Ashley output.</td>
  </tr>
  <tr>
    <td><tt>Set-AudioMin</tt></td>
	<td>Enables you control the audio level and set it to 0% to minimize [insert far to loud of a song here].</td>
  </tr>
  <tr>
    <td><tt>Start-CatFact</tt></td>
	<td>Retrieves a random $CatFact and plays it in audio to the victim.</td>
  </tr>
  <tr>
    <td><tt>Start-RickRoll</tt></td>
	<td>Starts playing the best song of all time.</td>
  </tr>
  <tr>
    <td><tt>Start-RowBoat</tt></td>
	<td>Starts an attempt to sing Row, Row Row your boat.</td>
  </tr>
  <tr>
    <td><tt>Send-Message</tt></td>
	<td>Send a messagebox with your text to all logged in users.</td>
  </tr>
  <tr>
    <td><tt>Open-CDDrive</tt></td>
	<td>Loops and attempts to command every CD Drive it finds to Eject.</td>
  </tr>
  <tr>
    <td><tt>Start-NotificationSoundSpam</tt></td>
	<td>Loops through the whole C:\Windows\Media directory and plays every wav file it finds in there with a 4 second delay.</td>
  </tr>
  <tr>
    <td><tt>Send-VoiceMessage</tt></td>
	<td>Send your lovely message to your co-worker in all its robot computer voice glory.</td>
  </tr>
 </table>
