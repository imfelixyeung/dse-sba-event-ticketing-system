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
        end;

    FeliEventParticipantCollection = class(FeliCollection)
        public
            procedure add(eventParticipant: FeliEventParticipant);
            class function fromFeliCollection(collection: FeliCollection): FeliEventParticipantCollection; static;
        end;

    FeliEventWaitingCollection = class(FeliEventParticipantCollection)
        end;

implementation
uses feli_stack_tracer;

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