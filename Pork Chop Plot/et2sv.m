
function [state, ic, frname] = et2sv(body,et0)
addpath('D:\NIKKY\Software\mice\lib')
addpath('D:\NIKKY\Software\mice\src\mice')
cspice_furnsh('./kernel.txt')

ND     =  2;
NI     =  6;
TIMFMT =  'YYYY MON DD HR:MN:SC.######::TDB TDB';

%
% Convert starting time to seconds past J2000 TDB.
%

[handle, descr, segid, found] = cspice_spksfs( body, et0);

if ~found
    cspice_kclear
    txt = sprintf( 'No SPK segment found for body %d at time %s', ...
        body, timstr );
    error( txt )
end
[dc, ic] = cspice_dafus( descr, ND, NI );
frname = cspice_frmnam( ic(3) );
% fprintf( 'Body        = %d\n', ic(1) )
% fprintf( 'Center      = %d\n', ic(2) )
% fprintf( 'Frame       = %s\n', frname)
% fprintf( 'Data type   = %d\n', ic(4) )
% fprintf( 'Start ET    = %f\n', dc(1) )
% fprintf( 'Stop ET     = %f\n', dc(2) )
% fprintf( 'Segment ID  = %s\n\n', segid )

for i=1:3

    et = et0 + ( 10. * (i-1) );

    %
    % Convert `et' to a string for display.
    %
    outstr = cspice_timout( et, TIMFMT );

    %
    % Attempt to compute a state only if the segment's
    % coverage interval contains `et'.
    %
    if ( et <= dc(2) )

        %
        % This segment has data at `et'. Evaluate the
        % state of the target relative to its center
        % of motion.
        %
        [ref_id, state, center] = cspice_spkpvn( handle, descr, et );

        %
        %  Display the time and state.
        %
%         fprintf( '\n%s\n', outstr )
%         fprintf( 'Position X (km):   %24.17f\n', state(1) )
%         fprintf( 'Position Y (km):   %24.17f\n', state(2) )
%         fprintf( 'Position Z (km):   %24.17f\n', state(3) )
%         fprintf( 'Velocity X (km):   %24.17f\n', state(4) )
%         fprintf( 'Velocity X (km):   %24.17f\n', state(5) )
%         fprintf( 'Velocity X (km):   %24.17f\n', state(6) )

    else

        cspice_kclear
        txt = sprintf( 'No data found for body %d at time %s', ...
            body, outstr );
        error( txt )

    end

end

%
% It's always good form to unload kernels after use,
% particularly in Matlab due to data persistence.
%
cspice_kclear
end