unit feli_document;

{$mode objfpc}

interface
uses fpjson;

type
    FeliDocument = class(TObject)
        public
            function toTJsonObject(secure: boolean = false): TJsonObject; virtual;
            function toJson(): ansiString;
        end;

implementation
uses feli_stack_tracer;

function FeliDocument.toTJsonObject(secure: boolean = false): TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliDocument.toTJsonObject(secure: boolean = false): TJsonObject;');
    result := TJsonObject.create();    
    FeliStackTrace.trace('end', 'function FeliDocument.toTJsonObject(secure: boolean = false): TJsonObject;');
end;

function FeliDocument.toJson(): ansiString;
begin
    FeliStackTrace.trace('begin', 'function FeliDocument.toJson(): ansiString;');
    result := self.toTJsonObject().formatJson;
    FeliStackTrace.trace('end', 'function FeliDocument.toJson(): ansiString;');
end;

end.