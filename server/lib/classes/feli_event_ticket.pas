unit feli_event_ticket;

{$mode objfpc}

interface
uses 
    feli_document,
    feli_collection,
    fpjson;

type
    FeliEventTicketKeys = class
        public
            const
                id = 'id';
                tType = 'type';
                fee = 'fee';
        end;

    FeliEventTicket = class(FeliDocument)
        public
            id, tType: ansiString;
            fee: real;
            function toTJsonObject(secure: boolean = false): TJsonObject; override;
        end;

    FeliEventTicketCollection = class(FeliCollection)
        public
            procedure add(eventTicket: FeliEventTicket);
            class function fromFeliCollection(collection: FeliCollection): FeliEventTicketCollection; static;
        end;

    FeliUserEventJoinedCollection = class(FeliEventTicketCollection)
        end;

    FeliUserEventCreatedCollection = class(FeliEventTicketCollection)
        end;

    FeliUserEventPendingCollection = class(FeliEventTicketCollection)
        end;

implementation

function FeliEventTicket.toTJsonObject(secure: boolean = false): TJsonObject;
var
    userEvent: TJsonObject;
begin
    userEvent := TJsonObject.create();
    userEvent.add(FeliEventTicketKeys.id, id);
    userEvent.add(FeliEventTicketKeys.tType, tType);
    userEvent.add(FeliEventTicketKeys.fee, fee);
    result := userEvent;
end;


procedure FeliEventTicketCollection.add(eventTicket: FeliEventTicket);
begin
    data.add(eventTicket.toTJsonObject());
end;

class function FeliEventTicketCollection.fromFeliCollection(collection: FeliCollection): FeliEventTicketCollection; static;
var
    feliEventTicketCollectionInstance: FeliEventTicketCollection;
begin
    feliEventTicketCollectionInstance := FeliEventTicketCollection.create();
    feliEventTicketCollectionInstance.data := collection.data;
    result := feliEventTicketCollectionInstance;
end;

end.