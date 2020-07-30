unit feli_user;

{$mode objfpc}

interface
uses
    feli_collection,
    fpjson;

type
    FeliUserKeys = class
        public
            const
                username = 'username';
                displayName = 'display_name';
                salt = 'salt';
                saltedPassword = 'salted_password';
                email = 'email';
                firstName = 'first_name';
                lastName = 'last_name';
                accessLevel = 'access_level';
                data = 'data';
        end;

    FeliUser = class(TObject)
        private
            salt, saltedPassword: ansiString;
        public
            username, password, displayName, email, firstName, lastName, accessLevel: ansiString;
            createdAt: int64;
            joinedEvents, createdEvents, pendingEvents: TJsonArray;
            
            constructor create();
            function toTJsonObject(): TJsonObject;
            function toJson(): ansiString;
            function verify(): boolean;
            procedure generateSaltedPassword();
            // Factory Methods
            class function fromTJsonObject(userObject: TJsonObject): FeliUser; static;
        end;

    FeliUserCollection = class(TObject)
        private
        public
            data: TJsonArray;
            constructor create();
            function where(key: ansiString; operation: ansiString; value: ansiString): FeliUserCollection;
            function toTJsonArray(): TJsonArray;
            function toJson(): ansiString;
            procedure add(user: FeliUser);
            procedure join(newCollection: FeliUserCollection);
            function length(): int64;
            class function fromTJsonArray(usersArray: TJsonArray): FeliUserCollection; static;
            class function fromFeliCollection(collection: FeliCollection): FeliUserCollection; static;
        end;

implementation
uses
    feli_crypto,
    feli_operators;

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

function FeliUser.toJson(): ansiString;
begin
    result := self.toTJsonObject().formatJson;
end;

function FeliUser.verify(): boolean;
begin
    result := (saltedPassword = FeliCrypto.hashMD5(salt + password));
end;

procedure FeliUser.generateSaltedPassword();
begin
    salt := FeliCrypto.generateSalt(32);
    saltedPassword := FeliCrypto.hashMD5(salt + password);
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


constructor FeliUserCollection.create();
begin
    data := TJsonArray.Create;
end;

function FeliUserCollection.where(key: ansiString; operation: ansiString; value: ansiString): FeliUserCollection;
var
    dataTemp: TJsonArray;
    dataEnum: TJsonEnum;
    dataSingle: TJsonObject;
begin
    dataTemp := TJsonArray.create();

    for dataEnum in data do
    begin
        dataSingle := dataEnum.value as TJsonObject;
        case operation of
            FeliOperators.equalsTo: begin
                if (dataSingle.getPath(key).asString = value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.notEqualsTo: begin
                if (dataSingle.getPath(key).asString <> value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.largerThanOrEqualTo: begin
                if (dataSingle.getPath(key).asString >= value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.largerThan: begin
                if (dataSingle.getPath(key).asString > value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.smallerThanOrEqualTo: begin
                if (dataSingle.getPath(key).asString <= value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.smallerThan: begin
                if (dataSingle.getPath(key).asString < value) then
                    dataTemp.add(dataSingle);
            end;

        end;

    end;

    result := FeliUserCollection.fromTJsonArray(dataTemp);
end;

procedure FeliUserCollection.add(user: FeliUser);
begin
    data.add(user.toTJsonObject());
end;

procedure FeliUserCollection.join(newCollection: FeliUserCollection);
var
    newArray: TJsonArray;
    newEnum: TJsonEnum;
    newDataSingle: TJsonObject;
begin
    newArray := newCollection.toTJsonArray();
    for newEnum in newArray do
    begin
        newDataSingle := newEnum.value as TJsonObject;
        data.add(newDataSingle);
    end;
end;

function FeliUserCollection.length(): int64;
begin
    result := data.count;
end;

function FeliUserCollection.toTJsonArray(): TJsonArray;
begin
    result := data;
end;

function FeliUserCollection.toJson(): ansiString;
begin
    result := self.toTJsonArray().formatJson;
end;


class function FeliUserCollection.fromTJsonArray(usersArray: TJsonArray): FeliUserCollection; static;
var 
    feliUserCollectionInstance: FeliUserCollection;
begin
    feliUserCollectionInstance := feliUserCollection.create();
    feliUserCollectionInstance.data := usersArray;
    result := feliUserCollectionInstance;
end;


class function FeliUserCollection.fromFeliCollection(collection: FeliCollection): FeliUserCollection; static;
var
    feliUserCollectionInstance: FeliUserCollection;
begin
    feliUserCollectionInstance := FeliUserCollection.create();
    feliUserCollectionInstance.data := collection.data;
    result := feliUserCollectionInstance;
end;

end.