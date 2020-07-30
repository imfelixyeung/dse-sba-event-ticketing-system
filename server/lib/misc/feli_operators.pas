unit feli_operators;

{$mode objfpc}


interface

type
    FeliOperators = class(TObject)
        public
            const
                largerThanOrEqualTo = '>=';
                largerThan = '>';
                smallerThanOrEqualTo = '<=';
                smallerThan = '<';
                equalsTo = '==';
                notEqualsTo = '!=';
        end;

implementation

end.