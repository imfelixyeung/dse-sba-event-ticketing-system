unit feli_document;

{$mode objfpc}

interface
uses fpjson;

type
    FeliDocument = class(TObject)
        public
            function toTJsonObject(): TJsonObject; virtual;
            function toJson(): ansiString;
        end;

implementation
function FeliDocument.toTJsonObject(): TJsonObject;
begin
    result := TJsonObject.create();    
end;

function FeliDocument.toJson(): ansiString;
begin
    result := self.toTJsonObject().formatJson;
end;

end.