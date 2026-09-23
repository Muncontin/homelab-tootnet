AdGuardHome expects a bcrypt-encrypted password to authenticate the user. Therefore after retrieving the plaintext password from Bitwarden, it needs to then be encrypted using bcrypt for AdguardHome to authenticate the user. 

Source: 
https://adguard-dns.io/kb/adguard-home/configuration/#users