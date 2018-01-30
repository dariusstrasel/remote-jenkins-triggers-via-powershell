$JenkinsServerUrl = ""
$RemoteToken = "abc"
$Cause = "Remotely triggered by PowerShell"

# Builds a Jenkins remote job URL with a default 'freestyle' configuration.
function getDefaultUrlEndpoint {
    param($jenkinsServerUrl, $projectName, $remoteToken, $cause)
    return "http://${jenkinsServerUrl}/job/${projectName}/build?token=${remoteToken}&cause=${cause}"
}

# Builds a Jenkins remote job URL for a parameterized build.
function getParameterizedBuildEndpoint {
    param($jenkinsServerUrl, $projectName, $remoteToken, $cause, $verbatimUrlParametersUsingAmpersand)
    return "http://${jenkinsServerUrl}/job/${projectName}/buildWithParameters?token=${remoteToken}&cause=${cause}${verbatimUrlParametersUsingAmpersand}"
}

$projectEndPoints = @{
"ExampleFreeStyleJob" = getDefaultUrlEndpoint $(JenkinsServerUrl) "ExampleFreeStyleJob" $(RemoteToken) $(Cause); 
"ExampleParameterizedJob" = getParameterizedBuildEndpoint $(JenkinsServerUrl) "ExampleParameterizedJob" $(RemoteToken) $(Cause) "&environment=production"; 
}

foreach ($projectEntry in $projectEndPoints.GetEnumerator()) {
    Write-Host "Triggering '$($projectEntry.Name)': $($projectEntry.Value)"
    Invoke-WebRequest "$($projectEntry.Value)"
    Start-Sleep -s 10
}