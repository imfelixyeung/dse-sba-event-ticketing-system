unit feli_collection;

{$mode objfpc}

interface
uses fpjson, feli_document;

type
    FeliCollection = class(TObject)
        public
            data: TJsonArray;
            constructor create();
            function where(key: ansiString; operation: ansiString; value: ansiString): FeliCollection;
            function toTJsonArray(): TJsonArray;
            function toJson(): ansiString;
            procedure add(document: FeliDocument);
            function length(): int64;
            function shift(): TJsonObject;
            class function fromTJsonArray(dataArray: TJsonArray): FeliCollection; static;
        end;

implementation
uses
    feli_operators,
    feli_stack_tracer;

constructor FeliCollection.create();
begin
    FeliStackTrace.trace('begin', 'constructor FeliCollection.create();');
    data := TJsonArray.create();
    FeliStackTrace.trace('end', 'constructor FeliCollection.create();');
end;

function FeliCollection.where(key: ansiString; operation: ansiString; value: ansiString): FeliCollection;
var
    dataTemp: TJsonArray;
    dataEnum: TJsonEnum;
    dataSingle: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliCollection.where(key: ansiString; operation: ansiString; value: ansiString): FeliCollection;');
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
    result := FeliCollection.fromTJsonArray(dataTemp);
    FeliStackTrace.trace('end', 'function FeliCollection.where(key: ansiString; operation: ansiString; value: ansiString): FeliCollection;');
end;

function FeliCollection.toTJsonArray(): TJsonArray;
begin
    FeliStackTrace.trace('begin', 'function FeliCollection.toTJsonArray(): TJsonArray;');
    result := self.data;
    FeliStackTrace.trace('end', 'function FeliCollection.toTJsonArray(): TJsonArray;');
end;

function FeliCollection.toJson(): ansiString;
var
    testArray: TJsonArray;
begin
    FeliStackTrace.trace('begin', 'function FeliCollection.toJson(): ansiString;');
    result := self.toTJsonArray().formatJson();
    FeliStackTrace.trace('end', 'function FeliCollection.toJson(): ansiString;');
end;

procedure FeliCollection.add(document: FeliDocument);
begin
    FeliStackTrace.trace('begin', 'procedure FeliCollection.add(document: FeliDocument);');
    data.add(document.toTJsonObject());
    FeliStackTrace.trace('end', 'procedure FeliCollection.add(document: FeliDocument);');
end;

function FeliCollection.shift(): TJsonObject;
var
    removed: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliCollection.shift(): TJsonObject;');
    if (self.length() > 0) then
        begin
            result := TJsonObject(data.extract(0));
        end
    else
        begin
            result := nil;
        end;
    FeliStackTrace.trace('end', 'function FeliCollection.shift(): TJsonObject;');
end;


function FeliCollection.length(): int64;
begin
    FeliStackTrace.trace('begin', 'function FeliCollection.length(): int64;');
    result := data.count;
    FeliStackTrace.trace('end', 'function FeliCollection.length(): int64;');
end;

class function FeliCollection.fromTJsonArray(dataArray: TJsonArray): FeliCollection; static;
var
    feliCollectionInstance: FeliCollection;
begin
    FeliStackTrace.trace('begin', 'class function FeliCollection.fromTJsonArray(dataArray: TJsonArray): FeliCollection; static;');
    feliCollectionInstance := FeliCollection.create();
    feliCollectionInstance.data := dataArray;
    result := feliCollectionInstance;
    FeliStackTrace.trace('end', 'class function FeliCollection.fromTJsonArray(dataArray: TJsonArray): FeliCollection; static;');
end;


end.