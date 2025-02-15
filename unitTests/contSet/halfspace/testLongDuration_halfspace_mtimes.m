function res = testLongDuration_halfspace_mtimes
% testLongDuration_halfspace_mtimes - unit test function of mtimes
%
% Syntax:  
%    res = testLongDuration_halfspace_mtimes
%
% Inputs:
%    -
%
% Outputs:
%    res - boolean 
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: -

% Author:       Mark Wetzlinger
% Written:      16-March-2021
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% Random tests
res_rand = true;
nrTests = 1000;
% turn warnings off due to singular matrices
warning('off','all');

for i=1:nrTests
    % random dimension
    n = randi(50);
    
    % random normal vector (unit length)
    c = randn(n,1);
    c = c / vecnorm(c,2);
    
    % random distance
    d = randn(1);
    
    % init halfspace
    h = halfspace(c,d);
    
    % random mapping matrix (either invertible or not)
    if rand(1) < 0.05
        A = [eye(n-1), zeros(n-1,1); zeros(1,n)];
    else
        A = randn(n);
    end
    
    % compute result
    if abs(det(A)) > eps
        h_mapped = A*h;
        
        % check with true result
        A_inv = inv(A);
        h_true = halfspace(A_inv'*c,d);

        % compare results
        if ~isequal(h_mapped,h_true)
            res_rand = false; break;
        end
        
    else
        try
            h_mapped = A*h;
            res_rand = false; break; % should not reach here
        catch ME
            % should throw error
        end
    end            
    
end

% turn warnings back on
warning('on','all');


% combine tests
res = res_rand;

if res_rand
    disp('test_mtimes successful');
else
    disp('test_mtimes failed');
end

%------------- END OF CODE --------------