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
