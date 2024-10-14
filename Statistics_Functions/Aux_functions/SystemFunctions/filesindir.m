function listfiles = filesindir( directory, pattern, hiddenfiles )
% FILESINDIR( directory, pattern, hiddenfiles ) saves all of the names of 
% the files in a given directory in an array.
%--------------------------------------------------------------------------
% ARGUMENTS
% directory     the location that you'd like to get the file names from!
% pattern       if included only files including the pattern are returned
% hiddenfiles   0/1, if 1 it includes hidden files otherwise it doesn't
%--------------------------------------------------------------------------
% OUTPUT
% listfiles     a cell array giving the file in the specfied directory that
%               contain the specified pattern
%--------------------------------------------------------------------------
% EXAMPLES
% filesindir('./')
% filesindir('./', 'Al')
% filesindir('./', 'lab')
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------
if ~exist( 'directory', 'var')
    directory = './';
end
if nargin < 2
    pattern = NaN;
end
if nargin < 3
    hiddenfiles = 0;
end

if iscell(pattern)
    listfiles = {};
    for I = 1:length(pattern)
        listfiles = [listfiles, filesindir( directory, pattern{I}, hiddenfiles)];
    end
    return
end

getfiles = dir(directory);

C = struct2cell(getfiles);

allfiles = cell(1, length(getfiles) - 2);
for I = 3:length(getfiles) %Note the first 2 are '..' and '.' so we skip those!
     allfiles{(I-2)} = C{1, I};
end

if hiddenfiles
    listfiles = allfiles;
else
    listfiles = cell(1);
    iter = 1;
    for J = 1:length(allfiles)
        file = allfiles{J};
        if ~strcmp(file(1), '.')
            if ~isnan(pattern)
%                 if ~isempty(strfind(file, pattern)) %#ok<STREMP>(jalapeno doesn't have contains)
                if contains(file, pattern)
                    listfiles{iter} = file;
                    iter = iter + 1;
                end
            else
                listfiles{iter} = file;
                iter = iter + 1;
            end
        end
    end
end

end

