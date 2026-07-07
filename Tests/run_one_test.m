function run_one_test(scriptpath)
% Runs a single test script headless with figures off, prints a status line.
sbroot = fileparts(fileparts(mfilename('fullpath')));
cd(sbroot);
addSB2path;
set(0, 'DefaultFigureVisible', 'off');
[~, scriptname] = fileparts(scriptpath);
rel = strrep(scriptpath, [sbroot filesep], '');
try
    evalc(scriptname);
    close all force;
    fprintf('###RESULT### OK | %s |\n', rel);
catch ME
    close all force;
    msg = regexprep(ME.message, '\s+', ' ');
    fprintf('###RESULT### FAIL | %s | %s\n', rel, msg);
end
end
