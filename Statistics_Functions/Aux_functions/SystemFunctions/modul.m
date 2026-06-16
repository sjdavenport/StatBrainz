function modul( I, modval )
% MODUL displays I when I is divisible by modval.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  I         the current integer value to test
%  modval    the modulus; I is displayed when mod(I, modval) == 0
%--------------------------------------------------------------------------
% OUTPUT
% None
%--------------------------------------------------------------------------
% EXAMPLES
%
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
if mod(I,modval) == 0
    disp(I);
end

end

