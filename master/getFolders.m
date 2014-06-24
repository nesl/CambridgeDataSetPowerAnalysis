% Author:Salma Elmalaki


function folders = getFolders( path )

    folders = dir(path);

    for k = length(folders):-1:1
        % remove non-folders
        if ~folders(k).isdir
            folders(k) = [ ];
            continue
        end

        % remove folders starting with .
        fname = folders(k).name;
        if fname(1) == '.'
            folders(k) = [ ];
        end
    end
end



