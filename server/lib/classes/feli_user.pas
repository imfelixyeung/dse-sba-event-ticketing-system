unit feli_user;

{$mode objfpc}

interface
uses fpjson;

type
    FeliUser = class(TObject)
        private
        public
            username, password, salt, saltedPassword, displayName, email, firstName, lastName, accessLevel: ansiString;
            joinedEvents, createdEvents, pendingEvents: TJsonArray;
            constructor create();
            function toTJsonObject(): TJsonObject;
            function verify(): boolean;
            class function fromTJsonObject(userObject: TJsonObject): FeliUser; static;
        end;

implementation
uses
    feli_crypto;

constructor FeliUser.create();
begin
    joinedEvents := TJsonArray.Create;
    createdEvents := TJsonArray.Create;
    pendingEvents := TJsonArray.Create;
end;


function FeliUser.toTJsonObject(): TJsonObject;
var
    user, userData: TJsonObject;

begin
    userData := TJsonObject.create();
    user := TJsonObject.create();
    
    case accessLevel of
        'admin': 
            begin
                userData.add('joined_events', joinedEvents);
                userData.add('created_events', createdEvents);
                userData.add('pending_events', pendingEvents);
            end;
        'organiser':
            begin
                userData.add('created_events', createdEvents);
            end;
        'default':
            begin
                userData.add('joined_events', TJsonArray.Create);                
                userData.add('pending_events', TJsonArray.Create);                
            end;
        'anonymous':
            begin
                
            end;
    end;

    user.add('username', username);
    user.add('display_name', displayName);
    user.add('salt', salt);
    user.add('salted_password', saltedPassword);
    user.add('email', email);
    user.add('first_name', firstName);
    user.add('last_name', lastName);
    user.add('access_level', accessLevel);
    user.add('data', userData);

    result := user;
end;

function FeliUser.verify(): boolean;
begin
    result := (saltedPassword = FeliCrypto.hashMD5(salt + password));
end;

class function FeliUser.fromTJsonObject(userObject: TJsonObject): FeliUser; static;
var
    feliUserInstance: FeliUser;
    tempTJsonArray: TJsonArray;
begin
    feliUserInstance := FeliUser.create();
    with feliUserInstance do
    begin
        username := userObject.getPath('username').asString;
        username := userObject.getPath('display_name').asString;
        salt := userObject.getPath('salt').asString;
        saltedPassword := userObject.getPath('salted_password').asString;
        email := userObject.getPath('email').asString;
        firstName := userObject.getPath('first_name').asString;
        lastName := userObject.getPath('last_name').asString;
        accessLevel := userObject.getPath('access_level').asString;

        try
            tempTJsonArray := TJsonArray(userObject.findPath('data.joined_events'));
            if not tempTJsonArray.isNull then 
            joinedEvents := tempTJsonArray;
        except
        end;
        try
            tempTJsonArray := TJsonArray(userObject.findPath('data.created_events'));
            if not tempTJsonArray.isNull then 
            createdEvents := tempTJsonArray;
        except
        end;
        try
            tempTJsonArray := TJsonArray(userObject.findPath('data.pending_events'));
            if not tempTJsonArray.isNull then 
            pendingEvents := tempTJsonArray;
        except
        end;
    end;
    result := feliUserInstance;
end;

end.