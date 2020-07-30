Program main;

{$mode objfpc}

uses 
    feli_storage,
    feli_file,
    feli_logger,
    feli_crypto,
    feli_validation,
    feli_config,
    feli_user,
    feli_exceptions,
    feli_operators,
    feli_event,
    feli_collection,
    sysutils,
    fpjson;


procedure debug();
begin
    FeliStorageAPI.debug;
    FeliFileAPI.debug;
    FeliValidation.debug;
end;

procedure init();
begin
    randomize;
end;

procedure test();
var 
    collection: FeliCollection;
    eventCollection: FeliEventCollection;
//     usersArray: TJsonArray;
//     userEnum: TJsonEnum;
//     testUsernameString: ansiString;
//     testUser: FeliUser;
//     users: FeliUserCollection;
//     testUser2: FeliUser;
//     testUserObject: TJsonObject;


begin

    // Test type casting
    // eventCollection := FeliEventCollection.create();
    // collection := eventCollection as FeliCollection;

    // collection := FeliCollection.create();
    // eventCollection := collection as FeliEventCollection;
    // writeln('Success');

    // Test events
    // event := FeliEvent.create();
    // with event do
    //     begin
    //         organiser := 'PascalGenerated';
    //         name := 'Lovely Event';
    //         description := 'Everyone should join this event, it will be epic';
    //         venue := 'Space';
    //         theme := 'Weightless';
    //     end;

    // FeliStorageAPI.addEvent(event);

    // event := FeliStorageAPI.getEvent('EB3444FB3A9F183C0');
    // if (event <> nil) then
    //     begin
    //         writeln('Event Found!');
    //     end
    // else
    //     begin
    //         writeln('Oh no, event not found')
    //     end;

    // Test for FeliStorageAPI methods
    // FeliStorageAPI.removeUser('add.user.test@example.com');
    // testUsernameString := 'FelixNPL';
    // testUser := FeliStorageAPI.getUser(testUsernameString);
    // FeliLogger.info(format('[User] Username %s', [testUser.username])); 
    // users := FeliStorageAPI.getUsers();
    // users := users.where(FeliUserKeys.username, FeliOperators.equalsTo, testUsernameString);
    // usersArray := users.toTJsonArray();
    // if (users.length = 0) then 
    //     FeliLogger.debug('[User] No users found') 
    // else
    //     for userEnum in usersArray do
    //     begin
    //         testUser := FeliUser.fromTJsonObject(TJsonObject(userEnum.value));
    //         FeliLogger.debug(format('[User] Display name: %s', [testUser.username]));
    //     end;

    // Test for FeliStorageAPI.addUser()
    // testUser := FeliUser.create();
    // with testUser do begin
    //     // username := 'FelixNPL';
    //     // password := '20151529';
    //     // email := 's20151529@home.npl.edu.hk';
    //     // firstName := 'Felix';
    //     // lastName := 'Yeung';
    //     // displayName := 'Felix NPL';
    //     // accessLevel := 'admin';
    //     // salt := 'CD5167D267431D269BA0DA40E692F14B';
    //     // saltedPassword := '91da52fb59d439167de2a21a87243e29';
    //     username := 'AddUserTest';
    //     password := '20151529';
    //     email := 'test@example.com';
    //     firstName := 'Test';
    //     lastName := 'User';
    //     displayName := 'Add User Test';
    //     accessLevel := 'organiser';
    // end;

    // testUser.generateSaltedPassword();
    // writeln(testUser.verify());
    // try
    //     FeliStorageAPI.addUser(testUser);
    // except
    //     on e: FeliExceptions.FeliStorageUserExist do writeln('EFeliStorageUserExist', e.message);
    //     on e: Exception do writeln('oh no', e.message);
    // end;
    // writeln(testUser.toJson());

    // Test for FeliStorageAPI.getUser()
    // testUsernameString := 'FelixNPL';
    // testUser := FeliStorageAPI.getUser(testUsernameString);
    // if (testUser <> nil) then
    //     begin
    //         writeln(format('User with username %s has been found', [testUsernameString]));
    //         writeln(testUser.ToTJsonObject().formatJson);
    //     end
    // else
    //     writeln(format('User with username %s cannot be found', [testUsernameString]));

    // Test for FeliUser
    // testUser := FeliUser.create();
    // with testUser do
    //     begin
    //         username := 'FelixNPL';
    //         password := '20151529';
    //         email := 's20151529@home.npl.edu.hk';
    //         firstName := 'Felix';
    //         lastName := 'Yeung';
    //         displayName := 'Felix NPL';
    //         accessLevel := 'admin';
    //         salt := 'CD5167D267431D269BA0DA40E692F14B';
    //         saltedPassword := '91da52fb59d439167de2a21a87243e29';
    //     end;
    
    // testUserObject := testUser.ToTJsonObject();
    // usersArray := FeliStorageAPI.getUsers();
    // writeln(usersArray[0].formatJson());
    // writeln(testUser.verify());
    // testUser2 := FeliUser.fromTJsonObject(TJsonObject(usersArray[0]));
    // testUserObject := testUser2.ToTJsonObject();
    // writeln(testUserObject.formatJson());

    // Test for FeliValidation.emailCheck
    // writeln(FeliValidation.emailCheck('info@example.com'));
    // writeln(FeliValidation.emailCheck('not.an.email.com'));

    // Test for FeliValidation.lengthCheck string inclusively
    // writeln(FeliValidation.lengthCheck('123456789', 10, 15, true));
    // writeln(FeliValidation.lengthCheck('1234567890', 10, 15, true));
    // writeln(FeliValidation.lengthCheck('1234567890123', 10, 15, true));
    // writeln(FeliValidation.lengthCheck('123456789012345', 10, 15, true));
    // writeln(FeliValidation.lengthCheck('123456789012345678', 10, 15, true));

    // Test for FeliValidation.lengthCheck string exclusively
    // writeln(FeliValidation.lengthCheck('123456789', 10, 15, false));
    // writeln(FeliValidation.lengthCheck('1234567890', 10, 15, false));
    // writeln(FeliValidation.lengthCheck('1234567890123', 10, 15, false));
    // writeln(FeliValidation.lengthCheck('123456789012345', 10, 15, false));
    // writeln(FeliValidation.lengthCheck('123456789012345678', 10, 15, false));

    // Test for FeliConfig.getApplicationTerminalLog
    // writeln(FeliConfig.getApplicationTerminalLog());

    // Test for FeliValidation.rangeCheck integer inclusively
    // writeln(FeliValidation.rangeCheck(9, 10, 15, true));
    // writeln(FeliValidation.rangeCheck(10, 10, 15, true));
    // writeln(FeliValidation.rangeCheck(13, 10, 15, true));
    // writeln(FeliValidation.rangeCheck(15, 10, 15, true));
    // writeln(FeliValidation.rangeCheck(18, 10, 15, true));

    // Test for FeliValidation.rangeCheck integer exclusively
    // writeln(FeliValidation.rangeCheck(9, 10, 15, false));
    // writeln(FeliValidation.rangeCheck(10, 10, 15, false));
    // writeln(FeliValidation.rangeCheck(13, 10, 15, false));
    // writeln(FeliValidation.rangeCheck(15, 10, 15, false));
    // writeln(FeliValidation.rangeCheck(18, 10, 15, false));

    // Test for FeliValidation.rangeCheck float inclusively
    // writeln(FeliValidation.rangeCheck(9.5, 10.0, 15.0, true));
    // writeln(FeliValidation.rangeCheck(10.0, 10.0, 15.0, true));
    // writeln(FeliValidation.rangeCheck(13.3, 10.0, 15.0, true));
    // writeln(FeliValidation.rangeCheck(15.0, 10.0, 15.0, true));
    // writeln(FeliValidation.rangeCheck(18.5, 10.0, 15.0, true));

    // Test for FeliValidation.rangeCheck float exclusively
    // writeln(FeliValidation.rangeCheck(9.5, 10.0, 15.0, false));
    // writeln(FeliValidation.rangeCheck(10.0, 10.0, 15.0, false));
    // writeln(FeliValidation.rangeCheck(13.3, 10.0, 15.0, false));
    // writeln(FeliValidation.rangeCheck(15.0, 10.0, 15.0, false));
    // writeln(FeliValidation.rangeCheck(18.5, 10.0, 15.0, false));

    // Test for FeliCrypto.hashMD5 consistency
    // FeliLogger.log(FeliCrypto.hashMD5('test'));

    // Test for FeliCrypto.generateSalt salt generation 
    // FeliLogger.log(FeliCrypto.generateSalt(64));
end;

begin
    try
        init();
        test();
        // debug();
    except
      on err: Exception do writeln(err.message);
    end;
end.

