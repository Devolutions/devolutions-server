#the samples expect that credentials and the url to your server be defined
#in environment variables.  Since storing creds in scripts is frowned upon,
#adapt a local file for running your own tests.
$env:DS_URL= 'https://localhost/dvls'
$env:DS_USER = '{your user here}'
$env:DS_PASSWORD = '{your password here}'