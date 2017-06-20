#Solarwinds passed parameters for script
param([string[]]$Caption,[string]$Status,[string]$Details,[string]$Node,[string]$AckUrl)

# Set the webhook endpoint on Spark, and format a tight datestamp 
$url = 'https://api.ciscospark.com/v1/messages'
$ftime = Get-Date -format “yyyy.MM.dd@HH:mm:ss” 

$headerJSON = @{}
$headerJSON.Authorization = 'Spark Authorization Bearer'

# build the JSON payload for the web request
$sparkJSON = @{}
$sparkJSON.roomId = ‘Spark Room ID’

# Spark formatted text string, (See Spark API for details)
$sparkJSON.markdown = $ftime + ‘- `’ + $Caption + ‘` status changed to *’ + $Status + ‘*’ + “<br>” + ‘ View: [Details](’ + $Details + ‘), [Node](’ + $Node + ‘)’ + “<br>” + ‘To acknowledge click [here](’ + $AckUrl + ‘)’

# Build the web request 
$webReq=@{
 Uri = $url
 ContentType = ‘application/json’
 Method = ‘Post’
 body = ConvertTo-Json $sparkJSON
 Headers = $headerJSON
}
# Send it to Spark
Invoke-WebRequest @webReq
