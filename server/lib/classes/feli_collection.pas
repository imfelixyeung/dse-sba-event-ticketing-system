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
            class function fromTJsonArray(dataArray: TJsonArray): FeliCollection; static;
        end;

implementation
uses
    feli_operators;

constructor FeliCollection.create();
begin
    data := TJsonArray.create();
end;

function FeliCollection.where(key: ansiString; operation: ansiString; value: ansiString): FeliCollection;
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

    result := FeliCollection.fromTJsonArray(dataTemp);
end;

function FeliCollection.toTJsonArray(): TJsonArray;
begin
    result := data;
end;

function FeliCollection.toJson(): ansiString;
begin
    result := self.toTJsonArray().formatJson;
end;

procedure FeliCollection.add(document: FeliDocument);
begin
    data.add(document.toTJsonObject());
end;


function FeliCollection.length(): int64;
begin
    result := data.count;
end;

class function FeliCollection.fromTJsonArray(dataArray: TJsonArray): FeliCollection; static;
var
    feliCollectionInstance: FeliCollection;
begin
    feliCollectionInstance := FeliCollection.create();
    feliCollectionInstance.data := dataArray;
    result := feliCollectionInstance;
end;


end.