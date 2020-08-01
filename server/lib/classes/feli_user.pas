unit feli_user;

{$mode objfpc}

interface
uses
    feli_collection,
    feli_document,
    fpjson;

type
    FeliUserKeys = class
        public
            const
                username = 'username';
                displayName = 'display_name';
                salt = 'salt';
                saltedPassword = 'salted_password';
                password = 'password';
                email = 'email';
                firstName = 'first_name';
                lastName = 'last_name';
                accessLevel = 'access_level';
                joinedEvents = 'joined_events';
                createdEvents = 'created_events';
                pendingEvents = 'pending_events';
        end;

    FeliUser = class(FeliDocument)
        private
            salt, saltedPassword: ansiString;
        public
            username, password, displayName, email, firstName, lastName, accessLevel: ansiString;
            createdAt: int64;
            joinedEvents, createdEvents, pendingEvents: TJsonArray;
            
            constructor create();
            function toTJsonObject(secure: boolean = false): TJsonObject; override;
            // function toJson(): ansiString;
            function verify(): boolean;
            function validate(): boolean;
            procedure generateSaltedPassword();
            // Factory Methods
            class function fromTJsonObject(userObject: TJsonObject): FeliUser; static;
        end;

    FeliUserCollection = class(FeliCollection)
        private
        public
            // data: TJsonArray;
            // constructor create();
            // function where(key: ansiString; operation: ansiString; value: ansiString): FeliUserCollection;
            // function toTJsonArray(): TJsonArray;
            // function toJson(): ansiString;
            procedure add(user: FeliUser);
            procedure join(newCollection: FeliUserCollection);
            // function length(): int64;
            // class function fromTJsonArray(usersArray: TJsonArray): FeliUserCollection; static;
            class function fromFeliCollection(collection: FeliCollection): FeliUserCollection; static;
        end;

implementation
uses
    feli_storage,
    feli_crypto,
    feli_validation,
    feli_operators,
    feli_access_level,
    feli_errors,
    sysutils;

constructor FeliUser.create();
begin
    joinedEvents := TJsonArray.Create;
    createdEvents := TJsonArray.Create;
    pendingEvents := TJsonArray.Create;
end;


function FeliUser.toTJsonObject(secure: boolean = false): TJsonObject;
var
    user, userData: TJsonObject;

begin
    writeln('begin function FeliUser.toTJsonObject(secure: boolean = false): TJsonObject;');
    user := TJsonObject.create();
    
    user.add(FeliUserKeys.username, username);
    user.add(FeliUserKeys.displayName, displayName);
    if not secure then user.add(FeliUserKeys.salt, salt);
    if not secure then user.add(FeliUserKeys.saltedPassword, saltedPassword);
    user.add(FeliUserKeys.email, email);
    user.add(FeliUserKeys.firstName, firstName);
    user.add(FeliUserKeys.lastName, lastName);
    user.add(FeliUserKeys.accessLevel, accessLevel);

    case accessLevel of
        FeliAccessLevel.admin: 
            begin
                user.add(FeliUserKeys.joinedEvents, joinedEvents);
                user.add(FeliUserKeys.createdEvents, createdEvents);
                user.add(FeliUserKeys.pendingEvents, pendingEvents);
            end;
        FeliAccessLevel.organiser:
            begin
                user.add(FeliUserKeys.createdEvents, createdEvents);
            end;
        FeliAccessLevel.participator:
            begin
                user.add(FeliUserKeys.joinedEvents, joinedEvents);                
                user.add(FeliUserKeys.pendingEvents, pendingEvents);                
            end;
        FeliAccessLevel.anonymous:
            begin
                
            end;
    end;

    result := user;
    writeln('end function FeliUser.toTJsonObject(secure: boolean = false): TJsonObject;');
end;

// function FeliUser.toJson(): ansiString;
// begin
//     result := self.toTJsonObject().formatJson;
// end;

function FeliUser.verify(): boolean;
begin
    result := (saltedPassword = FeliCrypto.hashMD5(salt + password));
end;

function FeliUser.validate(): boolean;
begin
    if not FeliValidation.emailCheck(email) then
        raise Exception.Create(FeliErrors.invalidEmail);
    if not FeliValidation.lengthCheck(username, 4, 16) then
        raise Exception.Create(FeliErrors.invalidUsernameLength);
    if not FeliValidation.lengthCheck(password, 8, 32) then
        raise Exception.Create(FeliErrors.invalidPasswordLength);
    if not FeliValidation.lengthCheck(firstName, 1, 32) then
        raise Exception.Create(FeliErrors.emptyFirstName);
    if not FeliValidation.lengthCheck(lastName, 1, 32) then
        raise Exception.Create(FeliErrors.emptyLastName);
    if not FeliValidation.lengthCheck(displayName, 1, 32) then
        raise Exception.Create(FeliErrors.emptyDisplayName);
    if not FeliValidation.fixedValueCheck(accessLevel, [FeliAccessLevel.organiser, FeliAccessLevel.participator]) then
        raise Exception.Create(FeliErrors.accessLevelNotAllowed);

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
        try username := userObject.getPath(FeliUserKeys.username).asString; except on e: exception do begin end; end;
        try displayName := userObject.getPath(FeliUserKeys.displayName).asString; except on e: exception do begin end; end;
        try salt := userObject.getPath(FeliUserKeys.salt).asString; except on e: exception do begin end; end;
        try saltedPassword := userObject.getPath(FeliUserKeys.saltedPassword).asString; except on e: exception do begin end; end;
        try password := userObject.getPath(FeliUserKeys.password).asString; except on e: exception do begin end; end;
        try email := userObject.getPath(FeliUserKeys.email).asString; except on e: exception do begin end; end;
        try firstName := userObject.getPath(FeliUserKeys.firstName).asString; except on e: exception do begin end; end;
        try lastName := userObject.getPath(FeliUserKeys.lastName).asString; except on e: exception do begin end; end;
        try accessLevel := userObject.getPath(FeliUserKeys.accessLevel).asString; except on e: exception do begin end; end;

        try
            tempTJsonArray := TJsonArray(userObject.findPath(FeliUserKeys.joinedEvents));
            if not tempTJsonArray.isNull then 
            joinedEvents := tempTJsonArray;
        except
        end;
        try
            tempTJsonArray := TJsonArray(userObject.findPath(FeliUserKeys.createdEvents));
            if not tempTJsonArray.isNull then 
            createdEvents := tempTJsonArray;
        except
        end;
        try
            tempTJsonArray := TJsonArray(userObject.findPath(FeliUserKeys.pendingEvents));
            if not tempTJsonArray.isNull then 
            pendingEvents := tempTJsonArray;
        except
        end;
    end;
    result := feliUserInstance;
end;


// constructor FeliUserCollection.create();
// begin
//     data := TJsonArray.Create;
// end;

// function FeliUserCollection.where(key: ansiString; operation: ansiString; value: ansiString): FeliUserCollection;
// var
//     dataTemp: TJsonArray;
//     dataEnum: TJsonEnum;
//     dataSingle: TJsonObject;
// begin
//     dataTemp := TJsonArray.create();

//     for dataEnum in data do
//     begin
//         dataSingle := dataEnum.value as TJsonObject;
//         case operation of
//             FeliOperators.equalsTo: begin
//                 if (dataSingle.getPath(key).asString = value) then
//                     dataTemp.add(dataSingle);
//             end;
//             FeliOperators.notEqualsTo: begin
//                 if (dataSingle.getPath(key).asString <> value) then
//                     dataTemp.add(dataSingle);
//             end;
//             FeliOperators.largerThanOrEqualTo: begin
//                 if (dataSingle.getPath(key).asString >= value) then
//                     dataTemp.add(dataSingle);
//             end;
//             FeliOperators.largerThan: begin
//                 if (dataSingle.getPath(key).asString > value) then
//                     dataTemp.add(dataSingle);
//             end;
//             FeliOperators.smallerThanOrEqualTo: begin
//                 if (dataSingle.getPath(key).asString <= value) then
//                     dataTemp.add(dataSingle);
//             end;
//             FeliOperators.smallerThan: begin
//                 if (dataSingle.getPath(key).asString < value) then
//                     dataTemp.add(dataSingle);
//             end;

//         end;

//     end;

//     result := FeliUserCollection.fromTJsonArray(dataTemp);
// end;

procedure FeliUserCollection.add(user: FeliUser);
begin
    writeln('begin procedure FeliUserCollection.add(user: FeliUser);');
    writeln(user.toJson());
    writeln('test again');
    data.add(user.toTJsonObject());
    writeln('end procedure FeliUserCollection.add(user: FeliUser);');
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

// function FeliUserCollection.length(): int64;
// begin
//     result := data.count;
// end;

// function FeliUserCollection.toTJsonArray(): TJsonArray;
// begin
//     result := data;
// end;

// function FeliUserCollection.toJson(): ansiString;
// begin
//     result := self.toTJsonArray().formatJson;
// end;


// class function FeliUserCollection.fromTJsonArray(usersArray: TJsonArray): FeliUserCollection; static;
// var 
//     feliUserCollectionInstance: FeliUserCollection;
// begin
//     feliUserCollectionInstance := feliUserCollection.create();
//     feliUserCollectionInstance.data := usersArray;
//     result := feliUserCollectionInstance;
// end;


class function FeliUserCollection.fromFeliCollection(collection: FeliCollection): FeliUserCollection; static;
var
    feliUserCollectionInstance: FeliUserCollection;
begin
    feliUserCollectionInstance := FeliUserCollection.create();
    feliUserCollectionInstance.data := collection.data;
    result := feliUserCollectionInstance;
end;

end.