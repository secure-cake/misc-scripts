Import-Module ActiveDirectory
#Uncomment the lines below to import names from file
#$lastnames = get-content $env:USERPROFILE\Downloads\lastnames.txt
#$firstnames = get-content $env:USERPROFILE\Downloads\firstnames.txt
$lastnames = "smith","johnson","williams","brown","jones","miller","davis","garcia","rodriguez","wilson","martinez","hernandez","lopez","anderson","gonzlez","white","harris","taylor"
$firstnames = "james","john","robert","michael","william","david","richard","joseph","thomas","charles","christopher","daniel","matthew","anthony","mary","patricia","jennifer","linda","elizabeth","barbara","susan","jessica","sarah","margaret","karen","nancy","lisa","betty","dorothy","melissa","amanda","amy","nicole","megan","rebecca","kimberly","christina","amber","rachel","tiffany","laura","emily"
#Prompt for input regarding number of characters to use from first and last name, for unique permutations, eg "John Smith" = josmit (2x4)
$firstname_chars = read-host "Enter desired number of characters from the first name"
$lastname_chars = read-host "Enter desired number of characters from the last name (max of 5)"
foreach ($lastname in $lastnames) {
    #Comment out the line below if you want to use the entire last name, instead of limited characters
    $lastname_truncated = $lastname.substring(0,$lastname_chars)
    foreach ($firstname in $firstnames) {
        $firstname_truncated = $firstname.substring(0,$firstname_chars)
        $username = $firstname_truncated+$lastname_truncated
        $username | Out-File $env:USERPROFILE\Downloads\usernames-output.txt -Append
        #Add 1 through 20 to the end of each username, eg johsmith1
        for ($i = 1; $i -le 20; $i++) {$username+$i | Out-File $env:USERPROFILE\Downloads\usernames-output.txt -Append} 
        }
 clear-variable i       
 } 
 #Sort and remove duplicates, in case you chose characters that result in potential duplicates
 get-content $env:USERPROFILE\Downloads\usernames-output.txt | sort | Get-Unique > $env:USERPROFILE\Downloads\usernames-output-unique.txt

 #Use for internal validation of valid, enabled user accounts
 $valid_users = get-content $env:USERPROFILE\Downloads\usernames-output-unique.txt
 foreach ($valid_user in $valid_users){
    Try {
    Get-ADUser $valid_user | where enabled -eq $true | select -ExpandProperty name | out-file $env:USERPROFILE\Downloads\valid_users.txt -Append
    }
    Catch {
        $errors
        }
    }
#How many usernames in your output list
get-content $env:USERPROFILE\Downloads\usernames-output-unique.txt | measure -Line
#If you ran internal validation, how many valid usernames you discovered
get-content $env:USERPROFILE\Downloads\valid_users.txt | measure -Line
