%Author: Salma Elmalaki



function files = getFiles( path )  
    files = dir(path);

    for k = length(files):-1:1
        % remove folders starting with .
        fname = files(k).name;
        if fname(1) == '.'
            files(k) = [ ];
        end
    end
end

