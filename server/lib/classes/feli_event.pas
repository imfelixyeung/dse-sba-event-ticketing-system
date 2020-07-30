unit feli_event;

{$mode objfpc}

interface
uses fpjson;

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
                participant_limit = 'participant_limit';
                tickets = 'tickets';
                participants = 'participants';
                waiting_list = 'waiting_list';

        end;

    FeliEvent = class(TObject)
        public
            id, organiser, name, description, venue, theme: ansiString;
            startTime, endTime, createdAt, participant_limit: int64;
            constructor create();
            function toTJsonObject(): TJsonObject;
            function toJson(): ansiString;
            // Factory Methods
            class function fromTJsonObject(eventObject: TJsonObject): FeliEvent; static;
        end;

    FeliEventCollection = class(TObject)
        private
        public
            data: TJsonArray;
            function toJson(): ansiString;
            constructor create();
            function where(key: ansiString; operation: ansiString; value: ansiString): FeliEventCollection;
            function toTJsonArray(): TJsonArray;
            procedure add(event: FeliEvent);
            function length(): int64;
            class function fromTJsonArray(eventsArray: TJsonArray): FeliEventCollection; static;
        end;

implementation

constructor FeliEvent.create();
begin
  
end;

function FeliEvent.toTJsonObject(): TJsonObject;
begin

end;


function FeliEvent.toJson(): ansiString;
begin

end;


class function FeliEvent.fromTJsonObject(eventObject: TJsonObject): FeliEvent; static;
begin

end;

function FeliEventCollection.toJson(): ansiString;
begin
    
end;


constructor FeliEventCollection.create();
begin
    
end;


function FeliEventCollection.where(key: ansiString; operation: ansiString; value: ansiString): FeliEventCollection;
begin
    
end;


function FeliEventCollection.toTJsonArray(): TJsonArray;
begin
    
end;


procedure FeliEventCollection.add(event: FeliEvent);
begin
    
end;


function FeliEventCollection.length(): int64;
begin
    
end;


class function FeliEventCollection.fromTJsonArray(eventsArray: TJsonArray): FeliEventCollection; static;
begin
    
end;




end.