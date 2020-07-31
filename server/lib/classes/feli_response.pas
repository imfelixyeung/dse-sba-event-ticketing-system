unit feli_response;

{$mode objfpc}

interface
uses fpjson;

type
    FeliResponse = class(TObject)
        public
            error, msg: ansiString;
            resCode: integer;
            function toTJsonObject(): TJsonObject; virtual;
            function toJson(): ansiString;
        end;
    
    FeliResponseDataObject = class(FeliResponse)
        public
            data: TJsonObject;
            function toTJsonObject(): TJsonObject; override;
        end;

    FeliResponseDataArray = class(FeliResponse)
        public
            data: TJsonArray;
            function toTJsonObject(): TJsonObject; override;
        end;

implementation
function FeliResponse.toTJsonObject(): TJsonObject;
var
    resObject: TJsonObject;
begin
    resObject := TJsonObject.create();
    resObject.add('status', resCode);
    if (error <> '') then resObject.add('error', error);
    if (msg <> '') then resObject.add('message', msg);
    result := resObject;
end;

function FeliResponse.toJson(): ansiString;
begin
    result := self.toTJsonObject().formatJson;
end;

function FeliResponseDataArray.toTJsonObject(): TJsonObject;
var
    resObject: TJsonObject;
begin
    resObject := TJsonObject.create();
    resObject.add('status', resCode);
    if (error <> '') then resObject.add('error', error);
    resObject.add('data', data);
    result := resObject;
end;

function FeliResponseDataObject.toTJsonObject(): TJsonObject;
var
    resObject: TJsonObject;
begin
    resObject := TJsonObject.create();
    resObject.add('status', resCode);
    if (error <> '') then resObject.add('error', error);
    resObject.add('data', data);
    result := resObject;
end;

end.