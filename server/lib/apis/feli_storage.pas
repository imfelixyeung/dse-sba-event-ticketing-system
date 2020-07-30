unit feli_storage;

{$mode objfpc}

interface

uses
    feli_user,
    fpjson;

type
    FeliStorageAPI = class(TObject)
    private
    public
        class function getUser(usernameOrEmail: ansiString): FeliUser;
        class function getUsers(): TJsonArray;
        class procedure addUser(user: FeliUser);
        class procedure removeUser(usernameOrEmail: ansiString);
        class procedure setUsers(users: TJsonArray);
        class procedure debug(); static;
    end;



implementation
uses 
    feli_logger,
    feli_file,
    feli_constants,
    jsonparser,
    feli_exceptions,
    sysutils;


class function FeliStorageAPI.getUser(usernameOrEmail: ansiString): FeliUser;
var
    users: TJsonArray;
    userEnum: TJsonEnum;
    userTemp: TJsonObject;
    usernameTemp, emailTemp: ansiString;
begin
    result := nil;
    users := FeliStorageAPI.getUsers();
    for userEnum in users do
    begin
        userTemp := TJsonObject(userEnum.value);
        usernameTemp := userTemp.getPath('username').asString;
        emailTemp := userTemp.getPath('email').asString;
        if (usernameTemp = usernameOrEmail) or (emailTemp = usernameOrEmail) then
            result := FeliUser.fromTJsonObject(userTemp);
    end;
end;

class function FeliStorageAPI.getUsers(): TJsonArray;
begin
    result := FeliFileAPI.getJsonArray(users_file_path);
end;

class procedure FeliStorageAPI.addUser(user: FeliUser);
var
    users: TJsonArray;
begin
    if (FeliStorageAPI.getUser(user.username) <> nil) then
        raise FeliExceptions.FeliStorageUserExist.Create('User already exist')
    else
        begin
            users := FeliStorageAPI.getUsers();
            users.add(user.toTJsonObject());
            FeliStorageAPI.setUsers(users);
        end;
end;

class procedure FeliStorageAPI.setUsers(users: TJsonArray);
begin
    FeliFileAPI.put(users_file_path, users.formatJson);
end;

class procedure FeliStorageAPI.removeUser(usernameOrEmail: ansiString);
var
    users: TJsonArray;
    userEnum: TJsonEnum;
    userTemp: TJsonObject;
    usernameTemp, emailTemp: ansiString;
begin
 
end;

class procedure FeliStorageAPI.debug(); static;
begin
    FeliLogger.info(format('[FeliStorageAPI.debug] Events file using %s', [events_file_path]));
    FeliLogger.info(format('[FeliStorageAPI.debug] Users file using %s', [users_file_path]));
end;

end.
