# Feli Crypto
`class FeliCrypto`

## Methods
### Generate Salt
```pascal
class function FeliCrypto.generateSalt(saltLength: integer): ansiString; static;
```
Returns a random string

### Hash
```pascal
class function FeliCrypto.hashMD5(payload: ansiString): ansiString; static;
```
Returns hashed payload with MD5 hashing