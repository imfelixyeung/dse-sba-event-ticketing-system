unit feli_access_level;

{$mode objfpc}


interface

type
    FeliAccessLevel = class(TObject)
        public
            const
                anonymous = 'anonymous';
                participator = 'participator';
                organiser = 'organiser';
                admin = 'admin';
        end;

implementation

end.