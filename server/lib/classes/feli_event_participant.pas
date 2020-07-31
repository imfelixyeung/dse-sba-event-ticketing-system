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
        end;

    FeliEventParticipant = class(FeliDocument)
        public
            username: ansiString;
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

function FeliEventParticipant.toTJsonObject(secure: boolean = false): TJsonObject;
var
    eventParticipant: TJsonObject;
begin
    eventParticipant := TJsonObject.create();
    eventParticipant.add(FeliEventParticipantKey.username, username);
    eventParticipant.add(FeliEventParticipantKey.createdAt, createdAt);
    result := eventParticipant;
end;


procedure FeliEventParticipantCollection.add(eventParticipant: FeliEventParticipant);
begin
    data.add(eventParticipant.toTJsonObject());
end;

class function FeliEventParticipantCollection.fromFeliCollection(collection: FeliCollection): FeliEventParticipantCollection; static;
var
    feliEventParticipantCollectionInstance: FeliEventParticipantCollection;
begin
    feliEventParticipantCollectionInstance := FeliEventParticipantCollection.create();
    feliEventParticipantCollectionInstance.data := collection.data;
    result := feliEventParticipantCollectionInstance;
end;

end.