$testpath="\\embarkserv.company.local\c$"
if((Test-Path -Path $testpath))
  {
	  
$imagesource="\\fileserv.company.local\shared\Museum\EmbARK\Images"
$imagedestination="C:\EmbARK Web Kiosk\Database\Webfolder\Media\images"
$datasource="\\embarkserv.company.local\c$\Embark_Data"
$datadestination="C:\EmbARK Web Kiosk\Datafile\."
# Stop services
Get-Service -computername embarkserv.company.local -name "4DS embark" | stop-service
Get-Service -name "Web Kiosk (managed by AlwaysUpService)" | stop-service
# Copy Images
RoboCopy $imagesource $imagedestination *.jpg *.pdf *.mp4 *.png /XO /fft /W:5 /R:0
# Copy Embark data file
RoboCopy $datasource $datadestination *.4DD  /XO /fft /W:5 /R:0
#xcopy '\\embarkserv.company.local\c$\Embark_Data\EmbARK_Server6_2NOV06.4DD' 'C:\EmbARK Web Kiosk\Datafile\' /D /Y
# Start services again
Get-Service -computername embarkserv.company.local -name "4DS embark" | start-service
Get-Service -name "Web Kiosk (managed by AlwaysUpService)" | start-service
# Send notification to MS Teams via webhook
Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body '{"text":"Embark data file and images copied. Services started"}' -Uri https://company.webhook.office.com/webhookb2/[EXAMPLE]
exit 0
  
	}
else
  {
Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body '{"text":"Embark copy job FAILED!!!!"}' -Uri https://company.webhook.office.com/webhookb2/[EXAMPLE]
  }
  
