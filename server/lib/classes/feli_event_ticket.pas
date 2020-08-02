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
uses
    feli_stack_tracer;
function FeliEventTicket.toTJsonObject(secure: boolean = false): TJsonObject;
var
    userEvent: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliEventTicket.toTJsonObject(secure: boolean = false): TJsonObject;');
    userEvent := TJsonObject.create();
    userEvent.add(FeliEventTicketKeys.id, id);
    userEvent.add(FeliEventTicketKeys.tType, tType);
    userEvent.add(FeliEventTicketKeys.fee, fee);
    result := userEvent;
    FeliStackTrace.trace('end', 'function FeliEventTicket.toTJsonObject(secure: boolean = false): TJsonObject;');
end;


procedure FeliEventTicketCollection.add(eventTicket: FeliEventTicket);
begin
    FeliStackTrace.trace('begin', 'procedure FeliEventTicketCollection.add(eventTicket: FeliEventTicket);');
    data.add(eventTicket.toTJsonObject());
    FeliStackTrace.trace('end', 'procedure FeliEventTicketCollection.add(eventTicket: FeliEventTicket);');
end;

class function FeliEventTicketCollection.fromFeliCollection(collection: FeliCollection): FeliEventTicketCollection; static;
var
    feliEventTicketCollectionInstance: FeliEventTicketCollection;
begin
    FeliStackTrace.trace('begin', 'class function FeliEventTicketCollection.fromFeliCollection(collection: FeliCollection): FeliEventTicketCollection; static;');
    feliEventTicketCollectionInstance := FeliEventTicketCollection.create();
    feliEventTicketCollectionInstance.data := collection.data;
    result := feliEventTicketCollectionInstance;
    FeliStackTrace.trace('end', 'class function FeliEventTicketCollection.fromFeliCollection(collection: FeliCollection): FeliEventTicketCollection; static;');
end;

end.