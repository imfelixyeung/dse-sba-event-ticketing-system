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
    feli_middleware,
    feli_stack_tracer,
    feli_ascii_art,
    feli_access_level,
    feli_constants,
    feli_directions,
    sysutils,
    fphttpapp,
    httpdefs,
    httproute,
    dateutils,
    fpjson;

const
    port = 8081;
    testMode = false;


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
    FeliStackTrace.trace('begin', 'function parseRequestJsonBody(req: TRequest): TJsonObject;');
    bodyContent := req.content;
    result := TJsonObject(getJson(bodyContent));
    FeliStackTrace.trace('end', 'function parseRequestJsonBody(req: TRequest): TJsonObject;');
end;


procedure userAuthMiddleware(var middlewareContent: FeliMiddleware; req: TRequest);
var
    username, password: ansiString;
    requestJson: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'procedure userAuthMiddleware(var middlewareContent: FeliMiddleware; req: TRequest);');
    requestJson := parseRequestJsonBody(req);
    username := requestJson.getPath('auth.username').asString;
    password := requestJson.getPath('auth.password').asString;
    middlewareContent.user := FeliStorageAPI.getUser(username);
    if (middlewareContent.user <> nil) then
        begin
            middlewareContent.user.password := password;
            middlewareContent.authenticated := middlewareContent.user.verify();
        end
    else
        begin
            middlewareContent.authenticated := false;
        end;
    FeliStackTrace.trace('end', 'procedure userAuthMiddleware(var middlewareContent: FeliMiddleware; req: TRequest);');
end;


procedure responseWithJson(var res: TResponse; responseTemplate: FeliResponse);
begin
    FeliStackTrace.trace('begin', 'procedure responseWithJson(var res: TResponse; responseTemplate: FeliResponse);');
    res.content := responseTemplate.toJson();
    res.code := responseTemplate.resCode;
    res.contentType := 'application/json;charset=utf-8';
    res.SetCustomHeader('access-control-allow-origin', '*');
    res.ContentLength := length(res.Content);
    res.SendContent;
    FeliStackTrace.trace('end', 'procedure responseWithJson(var res: TResponse; responseTemplate: FeliResponse);');
end;


(*
    End points begin
*)


procedure error404(req: TRequest; res: TResponse);
var
    responseTemplate: FeliResponse;
begin
    FeliStackTrace.trace('begin', 'procedure error404(req: TRequest; res: TResponse);');
    FeliLogger.error(format('Error 404 "%s" not found', [req.URI]));
    try
        responseTemplate := FeliResponse.create();
        responseTemplate.resCode := 404;
        responseTemplate.error := '404 Not Found';
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure error404(req: TRequest; res: TResponse);');
end;


procedure pingEndpoint(req: TRequest; res: TResponse);
var
    responseTemplate: FeliResponse;
begin
    FeliStackTrace.trace('begin', 'procedure pingEndpoint(req: TRequest; res: TResponse);');
    try
        responseTemplate := FeliResponse.create();
        responseTemplate.resCode := 200;
        responseTemplate.msg := 'Pong!';
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure pingEndpoint(req: TRequest; res: TResponse);');
end;


procedure getUsersEndPoint(req: TRequest; res: TResponse);
var
    users: FeliUserCollection;
    responseTemplate: FeliResponseDataArray;
begin
    FeliStackTrace.trace('begin', 'procedure getUsersEndPoint(req: TRequest; res: TResponse);');
    try
        users := FeliStorageAPI.getUsers();
        users.orderBy(FeliUserKeys.username, FeliDirections.ascending);
        responseTemplate := FeliResponseDataArray.create();
        responseTemplate.data := users.toSecureTJsonArray();
        responseTemplate.resCode := 200;
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure getUsersEndPoint(req: TRequest; res: TResponse);');
end;

procedure getEventsEndPoint(req: TRequest; res: TResponse);
var
    events: FeliEventCollection;
    responseTemplate: FeliResponseDataArray;
begin
    FeliStackTrace.trace('begin', 'procedure getEventsEndPoint(req: TRequest; res: TResponse);');
    try
        events := FeliStorageAPI.getEvents();
        events.orderBy(FeliEventKeys.startTime, FeliDirections.ascending);
        responseTemplate := FeliResponseDataArray.create();
        responseTemplate.data := events.toTJsonArray();
        responseTemplate.resCode := 200;
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure getEventsEndPoint(req: TRequest; res: TResponse);');
end;


procedure getEventEndPoint(req: TRequest; res: TResponse);
var
    eventId: ansiString;
    event: FeliEvent;
    responseTemplate: FeliResponseDataObject;
begin
    FeliStackTrace.trace('begin', 'procedure getEventEndPoint(req: TRequest; res: TResponse);');
    try
        eventId := req.routeParams['eventId'];
        event := FeliStorageAPI.getEvent(eventId);
        responseTemplate := FeliResponseDataObject.create();
        if (event <> nil) then
            begin
                responseTemplate.data := event.toTJsonObject();
                responseTemplate.resCode := 200;
            end
        else
            begin
                responseTemplate.resCode := 404;
            end;
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure getEventEndPoint(req: TRequest; res: TResponse);');
end;


procedure joinEventEndPoint(req: TRequest; res: TResponse);
var
    eventId, ticketId: ansiString;
    event: FeliEvent;
    responseTemplate: FeliResponseDataObject;
    middlewareContent: FeliMiddleware;
    requestJson: TJsonObject;
    tempCollection: FeliCollection;

begin
    FeliStackTrace.trace('begin', 'procedure joinEventEndPoint(req: TRequest; res: TResponse);');
    try
        eventId := req.routeParams['eventId'];
        event := FeliStorageAPI.getEvent(eventId);
        responseTemplate := FeliResponseDataObject.create();
        middlewareContent := FeliMiddleware.create();
        userAuthMiddleware(middlewareContent, req);
        requestJson := parseRequestJsonBody(req);
        try
            ticketId := requestJson.getPath('ticket_id').asString;    
        except
            ticketId := '';
        end;
        if (event <> nil) then
            begin
                if (middlewareContent.authenticated) then
                    begin
                        responseTemplate.authenticated := middlewareContent.authenticated;
                        if (FeliValidation.fixedValueCheck(middlewareContent.user.accessLevel, [FeliAccessLevel.admin, FeliAccessLevel.participator])) then
                            begin
                                tempCollection := event.tickets.where(FeliEventTicketKeys.id, FeliOperators.equalsTo, ticketId);
                                if (tempCollection.length >= 1) then
                                    begin
                                        middlewareContent.user.joinEvent(eventId, ticketId);
                                        responseTemplate.resCode := 200;
                                    end
                                else
                                    begin   
                                        responseTemplate.resCode := 404;
                                        responseTemplate.error := 'ticket_not_found';
                                    end;
                            end
                        else
                            begin
                                responseTemplate.resCode := 404;
                                responseTemplate.error := 'insufficient_permission';
                            end;
                    end
                else
                    begin
                        responseTemplate.resCode := 404;
                        responseTemplate.error := 'not_authenticated';
                    end;
            end
        else
            begin
                responseTemplate.resCode := 404;
                responseTemplate.error := 'event_not_found';
            end;
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure joinEventEndPoint(req: TRequest; res: TResponse);');
end;


procedure leaveEventEndPoint(req: TRequest; res: TResponse);
var
    eventId: ansiString;
    event: FeliEvent;
    responseTemplate: FeliResponseDataObject;
    middlewareContent: FeliMiddleware;
    tempCollection: FeliCollection;

begin
    FeliStackTrace.trace('begin', 'procedure leaveEventEndPoint(req: TRequest; res: TResponse);');
    try
        eventId := req.routeParams['eventId'];
        event := FeliStorageAPI.getEvent(eventId);
        responseTemplate := FeliResponseDataObject.create();
        middlewareContent := FeliMiddleware.create();
        userAuthMiddleware(middlewareContent, req);
        if (event <> nil) then
            begin
                if (middlewareContent.authenticated) then
                    begin
                        responseTemplate.authenticated := middlewareContent.authenticated;
                        if (FeliValidation.fixedValueCheck(middlewareContent.user.accessLevel, [FeliAccessLevel.admin, FeliAccessLevel.participator])) then
                            begin
                                middlewareContent.user.leaveEvent(eventId);
                                responseTemplate.resCode := 200;

                            end
                        else
                            begin
                                responseTemplate.resCode := 401;
                                responseTemplate.error := 'insufficient_permission';
                            end;
                    end
                else
                    begin
                        responseTemplate.resCode := 403;
                        responseTemplate.error := 'not_authenticated';
                    end;
            end
        else
            begin
                responseTemplate.resCode := 404;
                responseTemplate.error := 'event_not_found';
            end;
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure leaveEventEndPoint(req: TRequest; res: TResponse);');
end;

procedure removeEventEndPoint(req: TRequest; res: TResponse);
var
    eventId: ansiString;
    event: FeliEvent;
    responseTemplate: FeliResponseDataObject;
    middlewareContent: FeliMiddleware;
    tempCollection: FeliCollection;

begin
    FeliStackTrace.trace('begin', 'procedure removeEventEndPoint(req: TRequest; res: TResponse);');
    try
        eventId := req.routeParams['eventId'];
        event := FeliStorageAPI.getEvent(eventId);
        responseTemplate := FeliResponseDataObject.create();
        middlewareContent := FeliMiddleware.create();
        userAuthMiddleware(middlewareContent, req);
        if (event <> nil) then
            begin
                if (middlewareContent.authenticated) then
                    begin
                        responseTemplate.authenticated := middlewareContent.authenticated;
                        if (FeliValidation.fixedValueCheck(middlewareContent.user.accessLevel, [FeliAccessLevel.admin, FeliAccessLevel.organiser])) then
                            begin
                                tempCollection := middlewareContent.user.createdEvents.where(FeliUserEventKeys.eventId, FeliOperators.equalsTo, eventId);
                                if (tempCollection.length > 0) then
                                    begin
                                        middlewareContent.user.removeCreatedEvent(eventId);
                                        responseTemplate.resCode := 200;
                                    end
                                else 
                                    begin
                                        responseTemplate.resCode := 401;
                                        responseTemplate.error := 'insufficient_permission';
                                    end;
                            end
                        else
                            begin
                                responseTemplate.resCode := 401;
                                responseTemplate.error := 'insufficient_permission';
                            end;
                    end
                else
                    begin
                        responseTemplate.resCode := 403;
                        responseTemplate.error := 'not_authenticated';
                    end;
            end
        else
            begin
                responseTemplate.resCode := 404;
                responseTemplate.error := 'event_not_found';
            end;
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure removeEventEndPoint(req: TRequest; res: TResponse);');
end;


procedure createEventEndPoint(req: TRequest; res: TResponse);
var
    eventId, ticketId: ansiString;
    event: FeliEvent;
    responseTemplate: FeliResponseDataObject;
    middlewareContent: FeliMiddleware;
    requestJson, eventObject: TJsonObject;
    tempString, error: ansiString;
    tempReal: real;
    ticket: FeliEventTicket;
    ticketsArray: TJsonArray;
    ticketI: integer;
    ticketObject: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'procedure createEventEndPoint(req: TRequest; res: TResponse);');
    try
        responseTemplate := FeliResponseDataObject.create();
        middlewareContent := FeliMiddleware.create();
        requestJson := parseRequestJsonBody(req);
        try
            begin
                userAuthMiddleware(middlewareContent, req);
                responseTemplate.authenticated := middlewareContent.authenticated;
                if middlewareContent.authenticated then
                    begin
                        try
                            eventObject := requestJson.getPath('event') as TJsonObject;
                            event := FeliEvent.create();

                            with event do
                            begin
                                organiser := middlewareContent.user.username;
                                name := eventObject.getPath(FeliEventKeys.name).asString;
                                description := eventObject.getPath(FeliEventKeys.description).asString;
                                venue := eventObject.getPath(FeliEventKeys.venue).asString;
                                theme := eventObject.getPath(FeliEventKeys.theme).asString;

                                begin
                                    ticketsArray := eventObject.getPath(FeliEventKeys.tickets) as TJsonArray;

                                    for ticketI := 0 to (ticketsArray.count - 1) do
                                        begin
                                            ticketObject := ticketsArray[ticketI] as TJsonObject;
                                            ticket := FeliEventTicket.create();
                                            ticket.generateId();
                                            ticket.tType := ticketObject.getPath(FeliEventTicketKeys.tType).asString;
                                            tempString := ticketObject.getPath(FeliEventTicketKeys.fee).asString;
                                            ticket.fee := StrToInt64(tempString);
                                            if (ticket.validate(error)) then
                                                begin
                                                    tickets.add(ticket);
                                                end;
                                        end;

                                end;
                                tempString := eventObject.getPath(FeliEventKeys.startTime).asString;
                                startTime := StrToInt64(tempString);
                                tempString := eventObject.getPath(FeliEventKeys.endTime).asString;
                                endTime := StrToInt64(tempString);
                                tempString := eventObject.getPath(FeliEventKeys.participantLimit).asString;
                                participantLimit := StrToInt64(tempString);

                                
                                if (event.validate(error)) then
                                    begin
                                        middlewareContent.user.createEvent(event);
                                        responseTemplate.data := event.toTJsonObject();
                                        responseTemplate.resCode := 200;
                                    end
                                else
                                    begin
                                        responseTemplate.error := error;
                                        responseTemplate.resCode := 400;
                                    end;


                            end;

                        except
                            on E: Exception do
                            begin
                                responseTemplate.error := e.message;
                                responseTemplate.resCode := 400;
                            end;
                        end;
                      
                    end
                else
                    begin
                        responseTemplate.resCode := 403;
                        responseTemplate.error := 'not_authenticated';
                    end;
            end;
        except
            on E: Exception do
            begin
                responseTemplate.error := e.message;
                responseTemplate.resCode := 500;
                FeliLogger.error(e.message);
            end;
        end;
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure createEventEndPoint(req: TRequest; res: TResponse);');
end;


procedure loginEndPoint(req: TRequest; res: TResponse);
var
    responseTemplate: FeliResponseDataObject;
    middlewareContent: FeliMiddleware;

begin
    FeliStackTrace.trace('begin', 'procedure loginEndPoint(req: TRequest; res: TResponse);');
    responseTemplate := FeliResponseDataObject.create();
    middlewareContent := FeliMiddleware.create();
    try
        begin
            userAuthMiddleware(middlewareContent, req);

            responseTemplate.authenticated := middlewareContent.authenticated;
            if middlewareContent.authenticated then
                begin
                    responseTemplate.data := middlewareContent.user.toTJsonObject(true);
                    responseTemplate.resCode := 200;
                end
            else
                begin
                    responseTemplate.resCode := 401;
                end;
            responseWithJson(res, responseTemplate);
        end;
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure loginEndPoint(req: TRequest; res: TResponse);');
end;


procedure registerEndPoint(req: TRequest; res: TResponse);
var
    registerUser: FeliUser;
    responseTemplate: FeliResponseDataObject;
    requestJson, registerUserObject: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'procedure registerEndPoint(req: TRequest; res: TResponse);');
    try
        begin
            requestJson := parseRequestJsonBody(req);
            responseTemplate := FeliResponseDataObject.create();

            registerUserObject := TJsonObject(requestJson.getPath('register'));

            registerUser := FeliUser.fromTJsonObject(registerUserObject);

            try
                registerUser.validate();
                registerUser.generateSaltedPassword();
                FeliStorageAPI.addUser(registerUser); // Error
                responseTemplate.data := registerUser.toTJsonObject(true);
                responseTemplate.resCode := 200;
            except
                on E: Exception do
                begin
                    responseTemplate.resCode := 405;
                    responseTemplate.error := e.message;
                end;
            end;
            responseWithJson(res, responseTemplate);
        end;
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure registerEndPoint(req: TRequest; res: TResponse);');
end;


procedure asciiEndpoint(req: TRequest; res: TResponse);
var
    responseTemplate: FeliResponse;
    uploadedFile: TUploadedFile;
    tempString: ansiString;
    height, width: int64;
begin
    FeliStackTrace.trace('begin', 'procedure asciiEndpoint(req: TRequest; res: TResponse);');
    try
        responseTemplate := FeliResponse.create();
        responseTemplate.resCode := 202;
        tempString := req.QueryFields.ValueFromIndex[0];
        if (tempString <> '') then height := StrToInt64(tempString);
        tempString := req.QueryFields.ValueFromIndex[1];
        if (tempString <> '') then width := StrToInt64(tempString);
        // if (height <> nil and width <> nil) then
            FeliLogger.debug(format('Request Ascii Art %dx%d', [height, width]));
        // req.Query;
        // req.QueryString;
        // req.QueryFields;
        try
            uploadedFile := req.Files.First;
            FeliLogger.debug(format('File Name %s', [uploadedFile.FileName]));
            FeliLogger.debug(format('File size %d', [uploadedFile.Size]));
            FeliLogger.debug(format('Content Type %s', [uploadedFile.ContentType]));
            FeliLogger.debug(format('Local File Path %s', [uploadedFile.LocalFileName]));
            try
                responseTemplate.msg := FeliAsciiArt.generate(uploadedFile.LocalFileName, height, width);
            except
                on E: Exception do
                begin
                    FeliLogger.error(e.message);
                end;
            end;
        except
          on E: Exception do
          begin
            FeliLogger.error(e.message);
            responseTemplate.msg := 'error_file_not_found';
          end;
        end;
        responseWithJson(res, responseTemplate);
    finally
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure asciiEndpoint(req: TRequest; res: TResponse);');
end;


procedure serverShutdownEndpoint(req: TRequest; res: TResponse);
var
    responseTemplate: FeliResponse;
    middlewareContent: FeliMiddleware;
begin
    FeliStackTrace.trace('begin', 'procedure serverShutdownEndpoint(req: TRequest; res: TResponse);');
    middlewareContent := FeliMiddleware.create();
    try
        userAuthMiddleware(middlewareContent, req);
        responseTemplate := FeliResponse.create();
        if ((middlewareContent.user <> nil) and (middlewareContent.authenticated) and (FeliValidation.fixedValueCheck(middlewareContent.user.accessLevel, [FeliAccessLevel.admin]))) then
            begin
                responseTemplate.authenticated := middlewareContent.authenticated;
                responseTemplate.resCode := 202;
                responseTemplate.msg := 'server_shutting_down';
                FeliLogger.info('Shutting down server');
                application.terminate();
            end
        else
            begin
                responseTemplate.resCode := 401;
                responseTemplate.msg := 'insufficient_permission';
            end;
        responseWithJson(res, responseTemplate);
    finally
        middlewareContent.free();
        responseTemplate.free();  
    end;
    FeliStackTrace.trace('end', 'procedure serverShutdownEndpoint(req: TRequest; res: TResponse);');
end;


(*
    End points End
*)


procedure init();
begin
    FeliStackTrace.trace('begin', 'procedure init();');
    application.port := port;
    HTTPRouter.RegisterRoute('/api/users/get/', @getUsersEndPoint);
    HTTPRouter.RegisterRoute('/api/events/get/', @getEventsEndPoint);
    HTTPRouter.RegisterRoute('/api/event/:eventId/get/', @getEventEndPoint);
    HTTPRouter.RegisterRoute('/api/event/:eventId/join/', @joinEventEndPoint);
    HTTPRouter.RegisterRoute('/api/event/:eventId/leave/', @leaveEventEndPoint);
    HTTPRouter.RegisterRoute('/api/event/:eventId/remove/', @removeEventEndPoint);
    HTTPRouter.RegisterRoute('/api/event/post/', @createEventEndPoint);
    HTTPRouter.RegisterRoute('/api/login/', @loginEndPoint);
    HTTPRouter.RegisterRoute('/api/register/', @registerEndPoint);
    httpRouter.registerRoute('/api/shutdown/', @serverShutdownEndpoint);
    httpRouter.registerRoute('/api/ascii/', @asciiEndpoint);
    httpRouter.registerRoute('/api/ping/', @pingEndpoint);
    httpRouter.registerRoute('/*', @error404, true);

    // application.threaded := true;
    if (not testMode) then begin
        application.initialize();
        FeliLogger.info(format('HTTP Server listening on port %d', [port]));
        application.run();
    end;
    FeliStackTrace.trace('end', 'procedure init();');
end;


procedure test();
var 
    // userEvent: FeliUserEvent;
    // collection: FeliCollection;
    // eventCollection: FeliEventCollection;
    // eventArray: TJsonArray;
    // eventEnum: TJsonEnum;
    // eventObject: TJsonObject;
    // eventDocument: FeliEvent;
    // ticketDocument: FeliEventTicket;
    // document: FeliDocument;
    user: FeliUser;
    users: FeliUserCollection;
    event: FeliEvent;
    events: FeliEventCollection;
    ticket: FeliEventTicket;
    usersTJsonArray: TJsonArray;
    eventsTJsonArray: TJsonArray;
    i: integer;
    debugString: ansiString;
    // usersArray: TJsonArray;
    // userEnum: TJsonEnum;
    // testUsernameString: ansiString;
    // testUser: FeliUser;
    // users: FeliUserCollection;
    // testUser2: FeliUser;
    // testUserObject: TJsonObject;
    tempVar: boolean;


begin
    FeliStackTrace.trace('begin', 'procedure test();');
    
    // users := FeliStorageAPI.getUsers();
    // users.orderBy(FeliUserKeys.username, FeliDirections.descending);
    // usersTJsonArray := users.toTJsonArray();
    // debugString := '';
    // for i := 0 to (usersTJsonArray.count - 1) do
    //     begin
    //         user := FeliUser.fromTJsonObject(usersTJsonArray[i] as TJsonObject);
    //         debugString := debugString + user.username + lineSeparator;
    //     end;

    // writeln(debugString);
    
    events := FeliStorageAPI.getEvents();
    events.orderBy(FeliEventKeys.startTime, FeliDirections.ascending);
    eventsTJsonArray := events.toTJsonArray();
    debugString := '';
    for i := 0 to (eventsTJsonArray.count - 1) do
        begin
            event := FeliEvent.fromTJsonObject(eventsTJsonArray[i] as TJsonObject);
            // debugString := debugString + event.id + lineSeparator;
            debugString := debugString + IntToStr(event.startTime) + lineSeparator;
        end;

    writeln(debugString);

    // writeln(users.toSecureJson);
    // user := FeliStorageAPI.getUser('admin');
    // user.removeCreatedEvent('t783fggzf4aRPzMZ0RxNd7JSdQG41rNZ');
    // event := FeliEvent.create();
    // with event do
    //     begin

    //         organiser := user.username;
    //         name := 'Pascal Generated';
    //         description := 'A test event from pascal';
    //         venue := 'Hong Kong';
    //         theme := 'Fun';

    //         ticket := FeliEventTicket.create();
    //         ticket.generateId();
    //         ticket.tType := 'MVP';
    //         ticket.fee := 256;

    //         tickets.add(ticket);
            
    //         startTime := DateTimeToUnix(Now()) * 1000 - 8 * 60 * 60 * 1000 + 10000;
    //         endTime := DateTimeToUnix(Now()) * 1000 - 8 * 60 * 60 * 1000 + 20000;
    //         participantLimit := 5;

    //     end;

    // user.createEvent(event);        

    // FeliStorageAPI.removeUser('FelixNPL_NotExist');
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
    
    if (testMode) then begin
        FeliLogger.debug('Press <Enter> to continue');
        readln;
    end;
    FeliStackTrace.trace('end', 'procedure test();');
end;


begin
    FeliStackTrace.reset();
    FeliStackTrace.trace('begin', 'main');
    randomize();
    try
        if (testMode) then test();
        init();
        // debug();
    except
      on err: Exception do FeliLogger.error(err.message);
    end;
    FeliStackTrace.trace('end', 'main');
end.

