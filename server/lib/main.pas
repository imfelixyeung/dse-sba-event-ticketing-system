Program event_ticketing_system_server;

{$mode objfpc}

uses 
    feli_storage,
    feli_file,
    feli_logger,
    feli_crypto,
    feli_validation,
    feli_config,
    feli_user,
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
    usersArray: TJsonArray;
    testUser, testUser2: FeliUser;
    testUserObject: TJsonObject;

begin
    // Test for FeliUser
    testUser := FeliUser.create();
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
    
    testUserObject := testUser.ToTJsonObject();
    usersArray := FeliStorageAPI.getUsers();
    // writeln(usersArray[0].formatJson());
    // writeln(testUser.verify());
    testUser2 := FeliUser.fromTJsonObject(TJsonObject(usersArray[0]));
    testUserObject := testUser2.ToTJsonObject();
    writeln(testUserObject.formatJson());

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
    init();
    // debug();
    test();
end.

