unit feli_event;

interface


type

    FeliEvent = class(TObject)
        private
        public
            id, organiser, name, description: ansiString;
            createdAt: int64;

        end;

    FeliEventsCollection = class(TObject)
        private
        public
            data: array of FeliEvent;
        end;

implementation

end.