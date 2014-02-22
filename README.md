# Alfred 2 Jira user search workflow

Search for a Jira username by full name

## Usage

* `jlookup <username>`
* Action an item to paste the username in `[~username]` format to the frontmost app
* Cmd-action an item to copy to the clipboard (same format)

## Setup

For this workflow to function, you first need to download a csv list of user data from Jira.  This can be obtained with the following `bash` (assuming you have the [Atlassian CLI tools]( https://bobswift.atlassian.net/wiki/display/ACLI ) installed and configured):

```
PATH=/path/to/local/dir
FILE=${PATH}/file.csv
for char in {a..z}; do ./atlassian.sh jira --action getUserList --name $char 2> /dev/null; done | awk '/^"/' | sort | uniq > ${FILE}
```

You can then download user avatars to the same folder (Alfred will use them in place of the default icon, when set):

```
cd ${PATH}
awk -F, -vjira_pass=\'jira_password\' -vjira_un=\'jira_username\' '{un=$1; gsub("\"","",un); url=$5; gsub("\"$","\\&os_authType=basic\"",url); printf "wget --user=%s --password=%s %s -O %s.png\n",jira_un,jira_pass,url,un}' ${FILE} | bash
```

Then simply edit the `main.rb` and change the `@path` variable to the folder you set in `$PATH` above.
