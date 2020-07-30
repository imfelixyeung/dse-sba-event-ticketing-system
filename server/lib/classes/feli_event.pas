unit feli_event;

{$mode objfpc}

interface
uses
    feli_collection,
    fpjson;

type
    FeliEventKeys = class
        public
            const
                id = 'id';
                organiser = 'organiser';
                name = 'name';
                description = 'description';
                startTime = 'start_time';
                endTime = 'end_time';
                createdAt = 'created_at';
                venue = 'venue';
                theme = 'theme';
                participantLimit = 'participant_limit';
                tickets = 'tickets';
                participants = 'participants';
                waitingList = 'waiting_list';

        end;

    FeliEvent = class(TObject)
        public
            id, organiser, name, description, venue, theme: ansiString;
            startTime, endTime, createdAt, participantLimit: int64;
            tickets, participants, waitingList: TJsonArray;

            constructor create();
            function toTJsonObject(): TJsonObject;
            function toJson(): ansiString;
            procedure generateId();
            // Factory Methods
            class function fromTJsonObject(eventObject: TJsonObject): FeliEvent; static;
        end;

    FeliEventCollection = class(TObject)
        private
        public
            data: TJsonArray;
            constructor create(creationData: TJsonArray = nil);
            function where(key: ansiString; operation: ansiString; value: ansiString): FeliEventCollection;
            function toTJsonArray(): TJsonArray;
            function toJson(): ansiString;
            procedure add(event: FeliEvent);
            function length(): int64;
            class function fromTJsonArray(eventsArray: TJsonArray): FeliEventCollection; static;
            class function fromFeliCollection(collection: FeliCollection): FeliEventCollection; static;
        end;

implementation
uses
    feli_crypto,
    feli_operators;

constructor FeliEvent.create();
begin
    createdAt := 0;
    startTime := 0;
    endTime := 0;
    createdAt := 0;
    participantLimit := 0;
    tickets := TJsonArray.create();
    participants := TJsonArray.create();
    waitingList := TJsonArray.create();
end;

function FeliEvent.toTJsonObject(): TJsonObject;
var 
    event: TJsonObject;
begin
    event := TJsonObject.create();
    event.add(FeliEventKeys.id, id);
    event.add(FeliEventKeys.organiser, organiser);
    event.add(FeliEventKeys.name, name);
    event.add(FeliEventKeys.description, description);
    event.add(FeliEventKeys.startTime, startTime);
    event.add(FeliEventKeys.endTime, endTime);
    event.add(FeliEventKeys.createdAt, createdAt);
    event.add(FeliEventKeys.venue, venue);
    event.add(FeliEventKeys.theme, theme);
    event.add(FeliEventKeys.participantLimit, participantLimit);
    event.add(FeliEventKeys.tickets, tickets);
    event.add(FeliEventKeys.participants, participants);
    event.add(FeliEventKeys.waitingList, waitingList);
    result := event;
end;


function FeliEvent.toJson(): ansiString;
begin
    result := self.toTJsonObject().formatJson;
end;


procedure FeliEvent.generateId();
begin
    id := FeliCrypto.generateSalt(32);
end;


class function FeliEvent.fromTJsonObject(eventObject: TJsonObject): FeliEvent; static;
var
    feliEventInstance: FeliEvent;
begin
    feliEventInstance := FeliEvent.create();
    with feliEventInstance do
    begin
        id := eventObject.getPath('id').asString;
        organiser := eventObject.getPath('organiser').asString;
        name := eventObject.getPath('name').asString;
        description := eventObject.getPath('description').asString;
        venue := eventObject.getPath('venue').asString;
        theme := eventObject.getPath('theme').asString;
        startTime := eventObject.getPath('start_time').asInteger;
        endTime := eventObject.getPath('end_time').asInteger;
        createdAt := eventObject.getPath('created_at').asInteger;
        participantLimit := eventObject.getPath('participant_limit').asInteger;
        tickets := eventObject.getPath('tickets') as TJsonArray;
        participants := eventObject.getPath('participants') as TJsonArray;
        waitingList := eventObject.getPath('waiting_list') as TJsonArray;
    end;
    result := feliEventInstance;
end;


constructor FeliEventCollection.create(creationData: TJsonArray = nil);
begin
    if (creationData = nil) then
        self.data := TJsonArray.create()
    else
        self.data := creationData;
end;


function FeliEventCollection.where(key: ansiString; operation: ansiString; value: ansiString): FeliEventCollection;
var
    dataTemp: TJsonArray;
    dataEnum: TJsonEnum;
    dataSingle: TJsonObject;
begin
    dataTemp := TJsonArray.create();

    for dataEnum in data do
    begin
        dataSingle := dataEnum.value as TJsonObject;
        case operation of
            FeliOperators.equalsTo: begin
                if (dataSingle.getPath(key).asString = value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.notEqualsTo: begin
                if (dataSingle.getPath(key).asString <> value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.largerThanOrEqualTo: begin
                if (dataSingle.getPath(key).asString >= value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.largerThan: begin
                if (dataSingle.getPath(key).asString > value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.smallerThanOrEqualTo: begin
                if (dataSingle.getPath(key).asString <= value) then
                    dataTemp.add(dataSingle);
            end;
            FeliOperators.smallerThan: begin
                if (dataSingle.getPath(key).asString < value) then
                    dataTemp.add(dataSingle);
            end;

        end;

    end;

    result := FeliEventCollection.fromTJsonArray(dataTemp);
end;


function FeliEventCollection.toTJsonArray(): TJsonArray;
begin
    result := data;
end;

function FeliEventCollection.toJson(): ansiString;
begin
    result := self.toTJsonArray().formatJson;
end;

procedure FeliEventCollection.add(event: FeliEvent);
begin
    data.add(event.toTJsonObject());
end;


function FeliEventCollection.length(): int64;
begin
    result := data.count;
end;


class function FeliEventCollection.fromTJsonArray(eventsArray: TJsonArray): FeliEventCollection; static;
var
    feliEventCollectionInstance: FeliEventCollection;
begin
    feliEventCollectionInstance := FeliEventCollection.create();
    feliEventCollectionInstance.data := eventsArray;
    result := feliEventCollectionInstance;
end;


class function FeliEventCollection.fromFeliCollection(collection: FeliCollection): FeliEventCollection; static;
var
    feliEventCollectionInstance: FeliEventCollection;
begin
    feliEventCollectionInstance := FeliEventCollection.create();
    feliEventCollectionInstance.data := collection.data;
    result := feliEventCollectionInstance;
end;


end.