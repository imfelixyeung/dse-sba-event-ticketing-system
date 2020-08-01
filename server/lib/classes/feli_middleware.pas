unit feli_middleware;

{$mode objfpc}

interface
uses
    feli_user,
    fpjson;

type
    FeliMiddleware = class(TObject)
        public
            user: FeliUser;
            authenticated: boolean;
        end;

implementation


end.