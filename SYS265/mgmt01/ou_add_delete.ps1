# Allows user to add a computer or user, move those objects to another OU, or delete an OU

$computer = Read-Host "Enter the name of a computer you would like to move"
$ou_placement = Read-Host "Enter the OU placement for that computer (ex. OU=Test,DC=savannah,DC=local)"

$computer_check = Get-ADComputer -Identity $computer

if ($computer_check -ne $null) {
   Move-ADObject -Identity $computer_check -TargetPath $ou_placement
   Write-Output "Computer '$computer' was moved to '$ou_placement' successfully"
} else {
   Write-Output "Computer '$computer' was not found." 
