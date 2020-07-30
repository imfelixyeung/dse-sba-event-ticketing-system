unit feli_storage;

{$mode objfpc}

interface

uses
    feli_user,
    feli_event,
    fpjson;

type
    FeliStorageAPI = class(TObject)
    private
    public
        // users
        class function getUser(usernameOrEmail: ansiString): FeliUser;
        class function getUsers(): FeliUserCollection;
        class procedure addUser(user: FeliUser);
        class procedure removeUser(usernameOrEmail: ansiString);
        class procedure setUsers(users: FeliUserCollection);

        // event
        class function getEvent(eventId: ansiString): FeliEvent;
        class function getEvents(): FeliEventCollection;
        class procedure addEvent(event: FeliEvent);
        class procedure removeEvent(eventId: ansiString);
        class procedure setEvents(events: FeliEventCollection);

        // DEBUG
        class procedure debug(); static;

    end;



implementation
uses 
    feli_logger,
    feli_file,
    feli_constants,
    feli_exceptions,
    feli_operators,
    jsonparser,
    sysutils;


class function FeliStorageAPI.getUser(usernameOrEmail: ansiString): FeliUser;
var
    usersJsonArray: TJsonArray;
    userObject: TJsonObject;
    users, filteredUsers, tempUsers: FeliUserCollection;
begin

    result := nil;
    users := FeliStorageAPI.getUsers();
    filteredUsers := users.where(FeliUserKeys.username, FeliOperators.equalsTo, usernameOrEmail);
    tempUsers := users.where(FeliUserKeys.email, FeliOperators.equalsTo, usernameOrEmail);
    filteredUsers.join(tempUsers);
    if (filteredUsers.length() = 0) then 
        result := nil 
    else
        begin
            userObject := filteredUsers.toTJsonArray()[0] as TJsonObject;
            result := FeliUser.fromTJsonObject(userObject);
        end;
end;

class function FeliStorageAPI.getUsers(): FeliUserCollection;
var usersJsonArray: TJsonArray;

begin

    usersJsonArray := FeliFileAPI.getJsonArray(users_file_path);
    result := FeliUserCollection.fromTJsonArray(usersJsonArray);

end;

class procedure FeliStorageAPI.addUser(user: FeliUser);
var
    users: FeliUserCollection;
begin

    if (FeliStorageAPI.getUser(user.username) <> nil) then
        begin
            raise FeliExceptions.FeliStorageUserExist.Create('User already exist');
        end
    else
        begin
            users := FeliStorageAPI.getUsers();
            users.add(user);
            FeliStorageAPI.setUsers(users);
        end;
end;

class procedure FeliStorageAPI.setUsers(users: FeliUserCollection);
begin
    FeliFileAPI.put(users_file_path, users.toJson());
end;

class procedure FeliStorageAPI.removeUser(usernameOrEmail: ansiString);
var
    users: FeliUserCollection;
    oldLength: int64;
begin
    users := FeliStorageAPI.getUsers();
    oldLength := users.length();
    users := users.where(FeliUserKeys.username, FeliOperators.notEqualsTo, usernameOrEmail);
    users := users.where(FeliUserKeys.email, FeliOperators.notEqualsTo, usernameOrEmail);
    if (users.length() = oldLength) then
        FeliLogger.error(format('User %s was not found, ergo unable to remove %s', [usernameOrEmail, usernameOrEmail])) 
    else 
        FeliLogger.info(format('User %s removed successfully', [usernameOrEmail]));
    FeliStorageAPI.setUsers(users);
end;


class function FeliStorageAPI.getEvent(eventId: ansiString): FeliEvent;
begin

end;


class function FeliStorageAPI.getEvents(): FeliEventCollection;
begin

end;


class procedure FeliStorageAPI.addEvent(event: FeliEvent);
begin

end;


class procedure FeliStorageAPI.removeEvent(eventId: ansiString);
begin

end;


class procedure FeliStorageAPI.setEvents(events: FeliEventCollection);
begin

end;





class procedure FeliStorageAPI.debug(); static;
begin
    FeliLogger.info(format('[FeliStorageAPI.debug] Events file using %s', [events_file_path]));
    FeliLogger.info(format('[FeliStorageAPI.debug] Users file using %s', [users_file_path]));
end;

end.
