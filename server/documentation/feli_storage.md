# Feli Storage API
`FeliStorageAPI`

## Methods
### Get User
```pascal
class function getUser(usernameOrEmail: ansiString): FeliUser;
```
Get an instance of FeliUser matching username or email

### Get Users
```pascal
class function getUsers(): TJsonArray;
```
Get all users

### Add User
```pascal
class procedure addUser(user: FeliUser);
```
Adds user to database

### Remove User
```pascal
class procedure removeUser(usernameOrEmail: ansiString);
```
Removes users matching username or email

### Remove User
```pascal
class procedure setUsers(users: TJsonArray);
```
Saves users to database