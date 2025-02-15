function [res,msg] = c_inputTrajDT(val,sys,params)
% c_inputTrajDT - costum validation function to check whether params.u
%    and obj.dt match
%
% Syntax:
%    [res,msg] = c_inputTraj(val,sys,params,options)
%
% Inputs:
%    val - value for params.u
%    sys - some contDynamics object
%    params - model parameters
%
% Outputs:
%    res - logical whether validation was successful
%    msg - error message if validation failed
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% References: 
%   -

% Author:       Mark Wetzlinger
% Written:      25-May-2021
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% assume check ok
res = true;
msg = '';

% check if size of params.u matches sys.dt
if (size(val,2) == 1 && ~any(val))
    % params.u is default value (zero-vector)
    return;
elseif size(val,2) ~= round((params.tFinal-params.tStart) / sys.dt)
    res = false;
    msg = ['does not comply with obj.dt: \n'...
        'The number of steps in the reachability analysis given by \n'...
        '   (params.tFinal-params.tStart)/obj.dt\n'...
        'has to match the number of columns in params.u'];
    return;
end

end

%------------- END OF CODE --------------
