unit feli_collection;

{$mode objfpc}

interface
uses
    feli_document,
    fpjson,

    classes;

type
    FeliCollection = class(TObject)
        public
            data: TJsonArray;
            constructor create();
            function where(key: ansiString; operation: ansiString; value: ansiString): FeliCollection;
            procedure orderBy(key: ansiString; direction: ansiString);
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
    feli_stack_tracer,
    feli_directions,
    feli_validation,
    sysutils;

// https://www.w3resource.com/csharp-exercises/searching-and-sorting-algorithm/searching-and-sorting-algorithm-exercise-9.php


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

procedure FeliCollection.orderBy(key: ansiString; direction: ansiString);
var left, right: integer;
    function partition(var arr: TJsonArray; left, right: integer; key: ansiString; direction: ansiString): integer;
    var
        pivot: ansiString;
        i, j, dir: integer;
    begin
        FeliStackTrace.trace('begin', 'function partition(var arr: TJsonArray; left, right: integer; pivot: ansiString): integer;');

        pivot := arr[right].getPath(key).asString;
        i := left - 1;
        for j := left to (right - 1) do
        begin
            if (direction = FeliDirections.ascending) then dir := 1 else
            if (direction = FeliDirections.descending) then dir := -1 else
            dir := 0;

            if (CompareStr(arr[j].getPath(key).asString, pivot) * dir ) < 0 then
                begin
                    i := i + 1;
                    arr.exchange(i, j);
                end;
        end;

        arr.exchange((i + 1), right);

        result := i + 1;

        FeliStackTrace.trace('end', 'function partition(var arr: TJsonArray; left, right: integer; pivot: ansiString): integer;');
    end;

    procedure quicksort(var arr: TJsonArray; left, right: integer; key: ansiString; direction: ansiString);
    var
        pivot: integer;
        i: integer;
        tempObject: TJsonObject;
    begin
        FeliStackTrace.trace('begin', 'procedure quicksort(var arr: TJsonArray; left, right: integer);');

        if (left < right) then
            begin
                pivot := partition(arr, left, right, key, direction);
                quicksort(arr, left, pivot - 1, key, direction);
                quicksort(arr, pivot + 1, right, key, direction);
            end;

        FeliStackTrace.trace('end', 'procedure quicksort(var arr: TJsonArray; left, right: integer);');
    end;

begin
    FeliStackTrace.trace('begin', 'procedure FeliCollection.orderBy(key: ansiString; direction: ansiString);');

    if (FeliValidation.fixedValueCheck(direction, [FeliDirections.ascending, FeliDirections.descending])) then
        begin
            left := 0;
            right := data.count - 1;
            quicksort(data, left, right, key, direction);
        end;

    FeliStackTrace.trace('end', 'procedure FeliCollection.orderBy(key: ansiString; direction: ansiString);');
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