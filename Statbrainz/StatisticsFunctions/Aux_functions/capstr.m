function mod_str = capstr( str )
% CAPSTR( str ) capitalises the first letter of each word in the string str
% and sets all of the other letters to be lowercase.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  str       a string of words, or a cell array of strings
% Optional
% None
%--------------------------------------------------------------------------
% OUTPUT
%  mod_str   the modified string (or cell array of modified strings)
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Azzi Abdelmalek and Samuel Davenport, see
% https://tinyurl.com/yb2v523t.
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
if iscell(str)
    mod_str = cell(1, length(str));
    for I = 1:length(str)
        mod_str{I} = capstr(str{I});
    end
else
    mod_str = lower(str);
    idx = regexp([' ' mod_str],'(?<=\s+)\S','start')-1;
    mod_str(idx) = upper(mod_str(idx));
end

end
