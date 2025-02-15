function Z = reduceAdaptive(Z,diagpercent)
% reduceAdaptive - reduces the zonotope order until a maximum amount of
%    over-approximation defined by the Hausdorff distance between the
%    original zonotope and the reduced zonotope; based on [Thm 3.2,1]
%
% Syntax:  
%    Z = reduceAdaptive(Z,diagpercent)
%
% Inputs:
%    Z - zonotope object
%    diagpercent - percentage of diagonal of box over-approximation of
%               zonotope (used to compute dHmax)
%
% Outputs:
%    Z - reduced zonotope
%
% Example: 
%    Z = zonotope.generateRandom(2);
%    Z = reduce(Z,'adaptive',0.5);
%    
%
% References:
%    [1] Wetzlinger et al. "Adaptive Parameter Tuning for Reachability 
%        Analysis of Nonlinear Systems", HSCC 2021             
%
% Other m-files required: none
% Subfunctions: see below
% MAT-files required: none
%
% See also: reduce

% Author:       Mark Wetzlinger
% Written:      01-October-2020
% Last update:  16-June-2021 (restructure input/output args)
% Last revision: ---

%------------- BEGIN CODE --------------

G = generators(Z);
if isempty(G)
    return;
end
Gabs = abs(G);

% compute maximum admissible dH
Gbox = sum(Gabs,2);
dHmax = (diagpercent * 2) * sqrt(sum(Gbox.^2));


[n,nrG] = size(G);
% select generators using 'girard'
norminf = max(Gabs,[],1);               % faster than: vecnorm(G,Inf);
normsum = sum(Gabs,1);                  % faster than: vecnorm(G,1);
[h,idx] = mink(normsum - norminf,nrG);

if ~any(h)
    % no generators or all are h=0
    newG = diag(Gbox);
    Z.Z = [center(Z),newG(:,any(newG,1))];
    return
end

% box generators with h = 0
hzeroIdx = idx(h==0);
Gzeros = sum(Gabs(:,hzeroIdx),2);
last0Idx = numel(hzeroIdx);
gensred = Gabs(:,idx(last0Idx+1:end));

[maxval,maxidx] = max(gensred,[],1);
% use linear indexing
mugensred = zeros(n,nrG-last0Idx);
cols = n*(0:nrG-last0Idx-1);
mugensred(cols+maxidx) = maxval;
% compute new over-approximation of dH
gensdiag = cumsum(gensred-mugensred,2);
h = 2 * vecnorm(gensdiag,2); %sqrt(sum(gensdiag.^2,1))
% index until which gens are reduced
redIdx = find(h <= dHmax,1,'last');
if isempty(redIdx)
	redIdx = 0;
end
Gred = sum(gensred(:,1:redIdx),2);
Gunred = G(:,idx(last0Idx+redIdx+1:end));

Z.Z = [center(Z),[Gunred,diag(Gred+Gzeros)]];



% just for performance evaluation -----------------------------------------

% compute actual dH
% gred = G(:,idx(1:last0Idx+redIdx));
% Ztest = zonotope([zeros(n,1),gred]);
% shrinkFactors = 1 ./ sum(generators(box(Ztest)),2);
% Ztest = enlarge(Ztest,shrinkFactors);
% [realdH,hcomp] = hausdorffBox(Ztest);

end
