unit feli_errors;

{$mode objfpc}


interface

type
    FeliErrors = class(TObject)
        public
            const
                invalidEmail = 'Invalid Email';
                invalidUsernameLength = 'Invalid username length';
                invalidPasswordLength = 'Invalid password length';
                emptyFirstName = 'Invalid first name length';
                emptyLastName = 'Invalid last name length';
                emptyDisplayName = 'Invalid display name length';
                accessLevelNotAllowed = 'Access level not allowed';
        end;

implementation

end.