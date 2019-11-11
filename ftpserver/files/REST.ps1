 #This part allows us to connect to Vcamp API.
 function Token {
    $bearerAuthValue = "Bearer Jb9LmZtRuWdsEpmyRTMt"
    $headers = @{ Authorization = $bearerAuthValue }
    $Invoke = invoke-WebRequest -uri 'https://velocity.vcamp.io/api/data_centers/BNA4/servers?all=true&hostname=c0zm8898&running=true' -Headers $headers
    $Invoke
   }


