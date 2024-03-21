# Author: Savannah Ciak
# Class: SYS265, Champlain College
# Date: 21 March 2024

Write-Output "This script allows the user to move a computer or user objects to another OU, add an OU, or delete an OU" 
Write-Output "For any of the options below, simply hit the enter key if you do not want to complete the action"

# Creating a New OU 
$new_ou = Read-Host "Enter the name of the OU you would like to add (ex. TestOU)"

if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $new_ou})) {
   New-ADOrganizationalUnit -Name $new_ou -ProtectedFromAccidentalDeletion $False
   Write-Output "OU '$new_ou' was created successfully"
} else {
   Write-Output "Failed: OU '$new_ou' already exists."
}

# Moving a Computer Object
$computer = Read-Host "Enter the name of a computer you would like to move (ex. wks01-savannah)"
$ou_placement = Read-Host "Enter the OU placement for that computer (ex. OU=Test,DC=savannah,DC=local)"

$computer_check = Get-ADComputer -Identity $computer

if ($computer_check -ne $null) {
   Move-ADObject -Identity $computer_check -TargetPath $ou_placement
   Write-Output "Computer '$computer' was moved to '$ou_placement' successfully"
} else {
   Write-Output "Failed: Computer '$computer' was not found." 
}

# Moving a User Object
$user = Read-Host "Enter the name of a user you would like to move (ex. savannah-ciak):"
$ou_placement_02 = Read-Host "Enter the OU placement for that computer (ex. OU=Test,DC=savannah,DC=local)"

$user_check = Get-ADUser -Identity $user

if ($user_check -ne $null) {
   Move-ADObject -Identity $user_check -TargetPath $ou_placement_02
   Write-Output "User '$user' was moved to '$ou_placement_02' successfully"
} else {
   Write-Output "Failed: User '$user' was not found." 
}

# Deleteing an OU
$old_ou = Read-Host "Enter the name of the OU you would like to delete (ex. TestOU)"

if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $old_ou})) {
   Remove-ADOrganizationalUnit -Identity $old_ou -Confirm:$false
   Write-Output "OU '$old_ou' was deleted successfully"
} else {
   Write-Output "Failed: OU '$old_ou' does not exist."
}
