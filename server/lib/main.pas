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
    feli_document,
    feli_user_event,
    feli_event_ticket,
    feli_event_participant,
    feli_response,
    sysutils,
    fphttpapp,
    httpdefs,
    httproute,
    fpjson;

const
    port = 8081;

procedure debug();
begin
    FeliStorageAPI.debug;
    FeliFileAPI.debug;
    FeliValidation.debug;
end;

function parseRequestJsonBody(req: TRequest): TJsonObject;
var
    bodyContent: ansiString;
begin
    bodyContent := req.content;
    result := TJsonObject(getJson(bodyContent));
end;

procedure responseWithJsonObject(var res: TResponse; responseTemplate: FeliResponse);
begin
    res.content := responseTemplate.toJson();
    res.code := responseTemplate.resCode;
    res.contentType := 'application/json;charset=utf-8';
    res.SetCustomHeader('access-control-allow-origin', '*');
    res.ContentLength := length(res.Content);
    res.SendContent;
end;

(*
    End points begin
*)


procedure error404(req: TRequest; res: TResponse);
var
    responseTemplate: FeliResponse;
begin
    try
        responseTemplate := FeliResponse.create();
        responseTemplate.resCode := 404;
        responseTemplate.error := '404 Not Found';
        responseWithJsonObject(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;

end;

procedure getEventsEndPoint(req: TRequest; res: TResponse);
var
    events: FeliEventCollection;
    responseTemplate: FeliResponseDataArray;
begin
    try
        events := FeliStorageAPI.getEvents();
        responseTemplate := FeliResponseDataArray.create();
        responseTemplate.data := events.toTJsonArray();
        responseTemplate.resCode := 200;
        responseWithJsonObject(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
end;

procedure getEventEndPoint(req: TRequest; res: TResponse);
var
    eventId: ansiString;
    event: FeliEvent;
    responseTemplate: FeliResponseDataObject;
begin
    try
        eventId := req.routeParams['eventId'];
        event := FeliStorageAPI.getEvent(eventId);
        responseTemplate := FeliResponseDataObject.create();
        responseTemplate.data := event.toTJsonObject();
        writeln(eventId);
        if (event <> nil) then
            responseTemplate.resCode := 200
        else
            responseTemplate.resCode := 404;
        responseWithJsonObject(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
end;

procedure loginEndPoint(req: TRequest; res: TResponse);
var
    username, password: ansiString;
    user: FeliUser;
    responseTemplate: FeliResponseDataObject;
    requestJson: TJsonObject;

begin
    try
        begin
            requestJson := parseRequestJsonBody(req);
            username := requestJson.getPath('auth.username').asString;
            password := requestJson.getPath('auth.password').asString;
            responseTemplate := FeliResponseDataObject.create();

            user := FeliStorageAPI.getUser(username);

            if (user <> nil) then
                begin
                    user.password := password;
                    if user.verify() then
                        begin
                            responseTemplate.data := user.toTJsonObject(true);
                            responseTemplate.resCode := 200;
                        end
                    else
                        begin
                            responseTemplate.resCode := 401;
                        end;
                    responseWithJsonObject(res, responseTemplate);
                end
            else
                begin
                    responseTemplate.resCode := 401;
                    responseWithJsonObject(res, responseTemplate);
                end;
        end;
    finally
        responseTemplate.free();  
    end;
end;

procedure registerEndPoint(req: TRequest; res: TResponse);
var
    registerUser: FeliUser;
    responseTemplate: FeliResponseDataObject;
    requestJson, registerUserObject: TJsonObject;
begin
    try
        begin
            requestJson := parseRequestJsonBody(req);
            responseTemplate := FeliResponseDataObject.create();

            registerUserObject := TJsonObject(requestJson.getPath('register'));

            registerUser := FeliUser.fromTJsonObject(registerUserObject);

            try
                registerUser.validate();
                registerUser.generateSaltedPassword();
                FeliStorageAPI.addUser(registerUser);
                responseTemplate.data := registerUser.toTJsonObject(true);
                responseTemplate.resCode := 200;
            except
                on E: Exception do
                begin
                    responseTemplate.resCode := 405;
                    responseTemplate.error := e.message;
                end;
            end;
            responseWithJsonObject(res, responseTemplate);
        end;
    finally
        responseTemplate.free();  
    end;
end;



procedure serverShutdownEndpoint(req: TRequest; res: TResponse);
var
    responseTemplate: FeliResponse;
begin
    try
        responseTemplate := FeliResponse.create();
        responseTemplate.resCode := 202;
        responseTemplate.error := 'Shutting down server';
        responseWithJsonObject(res, responseTemplate);
    finally
        responseTemplate.free();  
        application.terminate();
    end;

end;

(*
    End points End
*)

procedure init();
begin
    randomize;
    application.port := port;
    FeliLogger.info(format('HTTP Server listening on port %d', [port]));
    HTTPRouter.RegisterRoute('/api/events/get/', @getEventsEndPoint);
    HTTPRouter.RegisterRoute('/api/event/:eventId/get/', @getEventEndPoint);
    HTTPRouter.RegisterRoute('/api/login/', @loginEndPoint);
    HTTPRouter.RegisterRoute('/api/register/', @registerEndPoint);
    httpRouter.registerRoute('/api/shutdown', @serverShutdownEndpoint);
    httpRouter.registerRoute('/*', @error404, true);

    // application.threaded := true;
    application.initialize();
    Application.run();
end;

procedure test();
var 
    // userEvent: FeliUserEvent;
    // collection: FeliCollection;
    eventCollection: FeliEventCollection;
    eventArray: TJsonArray;
    eventEnum: TJsonEnum;
    eventObject: TJsonObject;
    eventDocument: FeliEvent;
    ticketDocument: FeliEventTicket;
    // document: FeliDocument;
    // user: FeliUser;
    // usersArray: TJsonArray;
    // userEnum: TJsonEnum;
    // testUsernameString: ansiString;
    // testUser: FeliUser;
    // users: FeliUserCollection;
    // testUser2: FeliUser;
    // testUserObject: TJsonObject;
    tempVar: boolean;


begin
    // eventCollection := FeliStorageAPI.getEvents();
    // writeln(eventCollection.length());
    // eventArray := eventCollection.toTJsonArray();
    // for eventEnum in eventArray do
    // begin
    //     ticketDocument := FeliEventTicket.create();
    //     with ticketDocument do
    //     begin
    //         id := '25136';
    //         tType := 'MVP++++++';
    //         fee := 250;
    //     end;
    //     eventObject := eventEnum.value as TJsonObject;
    //     eventDocument := FeliEvent.fromTJsonObject(eventObject);
    //     eventDocument.tickets.add(ticketDocument);
    //     FeliLogger.debug(format('Event name: %s', [eventDocument.name]));
    //     FeliLogger.debug(format('No. tickets: %d', [eventDocument.tickets.length()]));
    //     writeln(eventDocument.toJson());
    // end;



    // eventCollection := FeliEventCollection.create();
    // eventCollection.add()
    // userEvent := FeliUserEvent.create();
    // with userEvent do
    //     begin
    //         id := 'event_id';
    //         createdAt := 1596157198112;
    //     end;
    // writeln(userEvent.toJson());

    // document := FeliDocument.create();
    // writeln(document.toJson());
    // user := FeliStorageAPI.getUser('FelixNPL');
    // if (user <> nil) then
    // writeln(user.toJson()) else
    // writeln('no this user wor');
    
    // Test if code still works (<o/)
    // FeliStorageAPI.removeUser('test');
    // FeliStorageAPI.removeEvent('0TnpfpamgFEqb5tRUOTeu_DiffHJJB7c');
    // FeliStorageAPI.removeEvent('JkV74xTNKUrI_Ser9lIx8qkS6pzLlqgi');
    // HaHa still works


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
      on err: Exception do FeliLogger.error(err.message);
    end;
end.

