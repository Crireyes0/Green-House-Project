function sp = openSerial(port, baudrate, terminator, timeout)
% openSerial  Open and configure a serialport for line-based CSV packets.
%   sp = openSerial("COM3")                  % 115200, CR/LF, 5 s timeout
%   sp = openSerial("/dev/ttyUSB0", 230400)  % custom baud
%   sp = openSerial("COM4", [], "LF")        % match LF-only senders
%
% Defaults are tuned for the Arduino sketch provided earlier.

    if nargin < 2 || isempty(baudrate),  baudrate  = 115200; end
    if nargin < 3 || isempty(terminator), terminator = "CR/LF"; end
    if nargin < 4 || isempty(timeout),   timeout   = 5; end

    validateattributes(port, {'char','string'}, {'nonempty'}, mfilename, 'port', 1);
    sp = serialport(string(port), baudrate, "Timeout", timeout);
    configureTerminator(sp, terminator);   % used by readline; also sets write terminator
    flush(sp);                             % drop any stale bytes
end

