
# param (
#     [Parameter(Mandatory=$true)]
#     [int]$thresholdDays
# )

# # GitHub API endpoint for branches
# $repoOwner = "pradumchintamani"
# $repoName = "Clean_Branch"
# $token = $env:GITHUB_TOKEN  # GITHUB_TOKEN is automatically provided by GitHub Actions

# # Get the list of branches using GitHub API
# $headers = @{
#     Authorization = "Bearer $token"
# }

# $branchesUrl = "https://api.github.com/repos/$repoOwner/$repoName/branches?access_token=$($env:GITHUB_TOKEN)""
# $branches = Invoke-RestMethod -Uri $branchesUrl -Headers $headers

# # Get current date
# $currentDate = Get-Date

# # Filter branches based on last commit date
# foreach ($branch in $branches) {
#     $lastCommitUrl = $branch.commit.url
#     $lastCommit = Invoke-RestMethod -Uri $lastCommitUrl -Headers $headers
#     $lastCommitDate = [datetime]$lastCommit.commit.author.date
#     $daysDifference = ($currentDate - $lastCommitDate).Days

#     if ($daysDifference -gt $thresholdDays) {
#         Write-Host "Branch $($branch.name) is older than $thresholdDays days (Last commit on $($lastCommitDate.ToShortDateString()))."
#     }
# }

# ---------------------------------------------------------
param (
    [Parameter(Mandatory=$true)]
    [int]$thresholdDays
)

# Change to the repository directory
Set-Location $env:GITHUB_WORKSPACE

# Get the list of branches
$branches = git branch -r

# Get current date
$currentDate = Get-Date

foreach ($branch in $branches) {
    # Extract branch name
    $branchName = $branch -replace '^.*?/', ''

    # Get the last commit date of the branch
    $lastCommitDate = git log -n 1 --pretty=format:"%ai" $branchName

    # Convert the commit date to DateTime
    $lastCommitDate = Get-Date $lastCommitDate

    # Calculate the difference in days
    $daysDifference = ($currentDate - $lastCommitDate).Days

    if ($daysDifference -gt $thresholdDays) {
        Write-Host "Branch $branchName is older than $thresholdDays days (Last commit on $($lastCommitDate.ToShortDateString()))."
    }
}
