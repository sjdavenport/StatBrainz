function data = giftiread(filename)
    try
        t = xmltree(filename);
    catch
        error('[GIFTI] Loading of XML file %s failed.', filename);
    end
    
    uid = children(t, root(t));
    
    
end
