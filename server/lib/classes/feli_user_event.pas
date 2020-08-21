unit feli_user_event;

{$mode objfpc}

interface
uses 
    feli_document,
    feli_collection,
    fpjson;

type
    FeliUserEventKeys = class
        public
            const
                eventId = 'event_id';
                createdAt = 'created_at';
        end;

    FeliUserEvent = class(FeliDocument)
        public
            eventId: ansiString;
            createdAt: int64;
            function toTJsonObject(secure: boolean = false): TJsonObject; override;
            class function fromTJsonObject(dataObject: TJsonObject): FeliUserEvent; static;
        end;

    FeliUserEventCollection = class(FeliCollection)
        public
            procedure add(userEvent: FeliUserEvent);
            class function fromFeliCollection(collection: FeliCollection): FeliUserEventCollection; static;
        end;

    FeliUserEventJoinedCollection = class(FeliUserEventCollection)
        end;

    FeliUserEventCreatedCollection = class(FeliUserEventCollection)
        end;

    FeliUserEventPendingCollection = class(FeliUserEventCollection)
        end;

implementation
uses
    feli_stack_tracer,
    sysutils;

function FeliUserEvent.toTJsonObject(secure: boolean = false): TJsonObject;
var
    userEvent: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliUserEvent.toTJsonObject(secure: boolean = false): TJsonObject;');
    userEvent := TJsonObject.create();
    userEvent.add(FeliUserEventKeys.eventId, eventId);
    userEvent.add(FeliUserEventKeys.createdAt, createdAt);
    result := userEvent;
    FeliStackTrace.trace('end', 'function FeliUserEvent.toTJsonObject(secure: boolean = false): TJsonObject;');
end;

class function FeliUserEvent.fromTJsonObject(dataObject: TJsonObject): FeliUserEvent; static;
var
    userEventInstance: FeliUserEvent;
    tempString: ansiString;

begin
    FeliStackTrace.trace('begin', 'class function FeliUserEvent.fromTJsonObject(dataObject: TJsonObject): FeliUserEvent; static;');
    userEventInstance := FeliUserEvent.create();
    with userEventInstance do
        begin
            tempString := '0';
            try tempString := dataObject.getPath(FeliUserEventKeys.createdAt).asString; except on e: exception do begin end; end;
            createdAt := strToInt64(tempString);
            try eventId := dataObject.getPath(FeliUserEventKeys.eventId).asString; except on e: exception do begin end; end;
        end;
    result := userEventInstance;
    
    FeliStackTrace.trace('end', 'class function FeliUserEvent.fromTJsonObject(dataObject: TJsonObject): FeliUserEvent; static;');
end;


procedure FeliUserEventCollection.add(userEvent: FeliUserEvent);
begin
    FeliStackTrace.trace('begin', 'procedure FeliUserEventCollection.add(userEvent: FeliUserEvent);');
    data.add(userEvent.toTJsonObject());
    FeliStackTrace.trace('end', 'procedure FeliUserEventCollection.add(userEvent: FeliUserEvent);');
end;

class function FeliUserEventCollection.fromFeliCollection(collection: FeliCollection): FeliUserEventCollection; static;
var
    feliUserEventCollectionInstance: FeliUserEventCollection;
begin
    FeliStackTrace.trace('begin', 'procedure FeliUserEventCollection.add(userEvent: FeliUserEvent);');
    feliUserEventCollectionInstance := FeliUserEventCollection.create();
    feliUserEventCollectionInstance.data := collection.data;
    result := feliUserEventCollectionInstance;
    FeliStackTrace.trace('end', 'procedure FeliUserEventCollection.add(userEvent: FeliUserEvent);');
end;

end.