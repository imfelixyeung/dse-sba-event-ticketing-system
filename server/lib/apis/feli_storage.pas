unit feli_storage;

{$mode objfpc}

interface

uses
    feli_user,
    fpjson;

type
    listOfFeliUser = array of FeliUser;
    FeliStorageAPI = class(TObject)
    private
    public
        class function getUsers(): TJsonArray;
        class procedure debug(); static;
    end;



implementation
uses 
    feli_logger,
    feli_file,
    feli_constants,
    jsonparser,
    sysutils;

class function FeliStorageAPI.getUsers(): TJsonArray;
begin
    result := FeliFileAPI.getJsonArray(users_file_path);
end;


class procedure FeliStorageAPI.debug(); static;
begin
    FeliLogger.info(format('[FeliStorageAPI.debug] Events file using %s', [events_file_path]));
    FeliLogger.info(format('[FeliStorageAPI.debug] Users file using %s', [users_file_path]));
end;

end.
