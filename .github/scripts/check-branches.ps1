git branch -vva

param (
    [Parameter(Mandatory=$true)]
    [int]$thresholdDays
)

# GitHub API endpoint for branches
$repoOwner = "pradumchintamani"
$repoName = "Clean_Branch"
$token = $env:GITHUB_TOKEN  # GITHUB_TOKEN is automatically provided by GitHub Actions

# Get the list of branches using GitHub API
$headers = @{
    Authorization = "Bearer $token"
}

$branchesUrl = "https://api.github.com/repos/$repoOwner/$repoName/branches"
$branches = Invoke-RestMethod -Uri $branchesUrl -Headers $headers

# Get current date
$currentDate = Get-Date

# Filter branches based on last commit date
foreach ($branch in $branches) {
    $lastCommitUrl = $branch.commit.url
    $lastCommit = Invoke-RestMethod -Uri $lastCommitUrl -Headers $headers
    $lastCommitDate = [datetime]$lastCommit.commit.author.date
    $daysDifference = ($currentDate - $lastCommitDate).Days

    if ($daysDifference -gt $thresholdDays) {
        Write-Host "Branch $($branch.name) is older than $thresholdDays days (Last commit on $($lastCommitDate.ToShortDateString()))."
    }
}
