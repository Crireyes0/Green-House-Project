function data = readSerialPacket(sp)
% readSerialPacket  Read one comma-separated numeric line as a row vector.
%   data = readSerialPacket(sp)   % sp is a serialport from openSerial()

    % if ~isa(sp, "serialport")
    %     error('readSerialPacket:InvalidHandle', 'First argument must be a serialport object.');
    % end

    % Read up to the configured terminator (not included in result)
    line = string(readline(sp));
    line = strtrim(line);

    if strlength(line) == 0
        data = double.empty(1,0);
        return
    end

    parts = split(line, ",");
    parts = strtrim(parts);
    parts(parts == "") = [];               % tolerate trailing commas / extra spaces

    vals = str2double(parts);
    if any(isnan(vals))
        error('readSerialPacket:NonNumeric', 'Non-numeric content in packet: "%s"', line);
    end

    data = vals(:).';                      % ensure row vector
end