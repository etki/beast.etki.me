# Data Bags

Current cookbook expects some sensitive information to be provided via
data bags.

## Credentials

### Yandex.Disk

Yandex disk credentials are expected to be located in 
`credentials/yandex-disk.json` with following structure:

```yaml
id: yandex-disk
user: (username)
password: (password)
```

### Transmission

Transmission credentials are stored in same way in 
`credentials/transmission.json`:

```yaml
id: transmission
user: (username)
password: (password)
```

### Let's Encrypt!

Only email is expected

```yaml
id: letsencrypt
email: nemyx@uguomeka.рф
```
