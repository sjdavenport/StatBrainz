function data = load_gifti(gifti_file_path)
% LOAD_GIFTI Load GIFTI surface file via Python conversion
%
%   data = load_gifti(gifti_file_path)
%
%   Inputs:
%       gifti_file_path - String path to the GIFTI file to load
%
%   Outputs:
%       data - Structure containing 'vertices' and 'faces' fields
%
%   Example:
%       data = load_gifti('/path/to/surface.gii');
%       vertices = data.vertices;
%       faces = data.faces;

    % Get the directory where this MATLAB function is located
    func_dir = fileparts(mfilename('fullpath'));
    
    % Path to the original Python script
    original_py = fullfile(func_dir, 'gifti.py');
    
    % Create a temporary Python script with unique name
    temp_py = fullfile(func_dir, sprintf('gifti_temp_%s.py', ...
        char(datetime('now', 'Format', 'yyyyMMdd_HHmmss_SSS'))));

    try
        system('python3 -c "import nibabel; import scipy"')
    catch
        system('pip3 install nibabel')
        system('pip3 install scipy')
    end
    
    try
        % Read the original Python script
        fid = fopen(original_py, 'r');
        if fid == -1
            error('Could not open gifti.py. Make sure it exists in: %s', func_dir);
        end
        py_content = fread(fid, '*char')';
        fclose(fid);
        
        % Replace XXX with the actual path (using repr for proper Python string)
        % This handles special characters and escaping properly
        escaped_path = strrep(gifti_file_path, '\', '\\');
        escaped_path = strrep(escaped_path, '''', '\''');
        py_content = strrep(py_content, 'XXX', ['r''' escaped_path '''']);
        
        % Write the modified script to temporary file
        fid = fopen(temp_py, 'w');
        if fid == -1
            error('Could not create temporary Python script');
        end
        fwrite(fid, py_content);
        fclose(fid);
        
        % Run the Python script
        [status, output] = system(sprintf('python3 "%s"', temp_py));
        
        if status ~= 0
            error('Python script failed with message:\n%s', output);
        end
        
        % Display Python output
        if ~isempty(output)
            fprintf('%s\n', output);
        end
        
        % Determine the expected .mat file path
        [fpath, fname, ~] = fileparts(gifti_file_path);
        mat_file = fullfile(fpath, [fname '.mat']);

        % Load the resulting .mat file
        if ~isfile(mat_file)
            error('Expected output file not found: %s', mat_file);
        end
        
        data = load(mat_file);

        system(['rm ', mat_file])
        
    catch ME
        % Clean up and rethrow error
        if exist(temp_py, 'file')
            delete(temp_py);
        end
        rethrow(ME);
    end
    
    % Clean up temporary Python script
    if exist(temp_py, 'file')
        delete(temp_py);
    end
end