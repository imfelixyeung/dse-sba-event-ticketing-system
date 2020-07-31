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
                id = 'id';
                createdAt = 'created_at';
        end;

    FeliUserEvent = class(FeliDocument)
        public
            id: ansiString;
            createdAt: int64;
            function toTJsonObject(secure: boolean = false): TJsonObject; override;
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

function FeliUserEvent.toTJsonObject(secure: boolean = false): TJsonObject;
var
    userEvent: TJsonObject;
begin
    userEvent := TJsonObject.create();
    userEvent.add(FeliUserEventKeys.id, id);
    userEvent.add(FeliUserEventKeys.createdAt, createdAt);
    result := userEvent;
end;


procedure FeliUserEventCollection.add(userEvent: FeliUserEvent);
begin
    data.add(userEvent.toTJsonObject());
end;

class function FeliUserEventCollection.fromFeliCollection(collection: FeliCollection): FeliUserEventCollection; static;
var
    feliUserEventCollectionInstance: FeliUserEventCollection;
begin
    feliUserEventCollectionInstance := FeliUserEventCollection.create();
    feliUserEventCollectionInstance.data := collection.data;
    result := feliUserEventCollectionInstance;
end;

end.