unit feli_event_participant;

{$mode objfpc}

interface
uses 
    feli_document,
    feli_collection,
    fpjson;

type
    FeliEventParticipantKey = class
        public
            const
                username = 'username';
                createdAt = 'created_at';
                ticketId = 'ticket_id';
        end;

    FeliEventParticipant = class(FeliDocument)
        public
            username, ticketId: ansiString;
            createdAt: int64;
            function toTJsonObject(secure: boolean = false): TJsonObject; override;
            // Factory Methods
            class function fromTJsonObject(participantObject: TJsonObject): FeliEventParticipant; static;
        end;

    FeliEventParticipantCollection = class(FeliCollection)
        public
            procedure add(eventParticipant: FeliEventParticipant);
            class function fromFeliCollection(collection: FeliCollection): FeliEventParticipantCollection; static;
        end;

    FeliEventWaitingCollection = class(FeliEventParticipantCollection)
        end;

implementation
uses feli_stack_tracer, sysutils;

function FeliEventParticipant.toTJsonObject(secure: boolean = false): TJsonObject;
var
    eventParticipant: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliEventParticipant.toTJsonObject(secure: boolean = false): TJsonObject;');
    eventParticipant := TJsonObject.create();
    eventParticipant.add(FeliEventParticipantKey.username, username);
    eventParticipant.add(FeliEventParticipantKey.ticketId, ticketId);
    eventParticipant.add(FeliEventParticipantKey.createdAt, createdAt);
    result := eventParticipant;
    FeliStackTrace.trace('end', 'function FeliEventParticipant.toTJsonObject(secure: boolean = false): TJsonObject;');
end;


class function FeliEventParticipant.fromTJsonObject(participantObject: TJsonObject): FeliEventParticipant; static;
var
    feliEventParticipantInstance: FeliEventParticipant;
    tempString: ansiString;
begin
    feliEventParticipantInstance := FeliEventParticipant.create();
    with feliEventParticipantInstance do
    begin
        try username := participantObject.getPath(FeliEventParticipantKey.username).asString; except on e: exception do begin end; end;
        try 
        begin
          tempString := participantObject.getPath(FeliEventParticipantKey.createdAt).asString;
          createdAt := StrToInt64(tempString);
        end;
        except on e: exception do begin end; end;
        try ticketId := participantObject.getPath(FeliEventParticipantKey.ticketId).asString; except on e: exception do begin end; end;
 
    end;
    result := feliEventParticipantInstance;
end;


procedure FeliEventParticipantCollection.add(eventParticipant: FeliEventParticipant);
begin
    FeliStackTrace.trace('begin', 'procedure FeliEventParticipantCollection.add(eventParticipant: FeliEventParticipant);');
    data.add(eventParticipant.toTJsonObject());
    FeliStackTrace.trace('end', 'procedure FeliEventParticipantCollection.add(eventParticipant: FeliEventParticipant);');
end;

class function FeliEventParticipantCollection.fromFeliCollection(collection: FeliCollection): FeliEventParticipantCollection; static;
var
    feliEventParticipantCollectionInstance: FeliEventParticipantCollection;
begin
    FeliStackTrace.trace('begin', 'class function FeliEventParticipantCollection.fromFeliCollection(collection: FeliCollection): FeliEventParticipantCollection; static;');
    feliEventParticipantCollectionInstance := FeliEventParticipantCollection.create();
    feliEventParticipantCollectionInstance.data := collection.data;
    result := feliEventParticipantCollectionInstance;
    FeliStackTrace.trace('end', 'class function FeliEventParticipantCollection.fromFeliCollection(collection: FeliCollection): FeliEventParticipantCollection; static;');
end;

end.