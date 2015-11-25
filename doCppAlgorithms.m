function [ ] = doCppAlgorithms( P, C, options)
%DOCPPALGORITHMS Solves the CPP problem.
% Plots solutions from various CPP algorithms: boustrophedon (only one
% currently) using the Dubins Path Planning Library (DPPL).
%
%   Parameters:
%       P       An n-by-2 matrix of polygon vertices.
%       C       Starting configuration, 3-by-1 vector
%       options Options for the scenario.
%
% David Goodman
% 2015.10.15

%% ================ Dependencies ===============

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

%% ================== Solve =================

startPosition = C(1:2);
startHeading = C(3); % [rad]

subplotDim = options.SubPlotDim;

[n, ~] = size(P);

if strcmp(options.Debug, 'on')
    fprintf('## Testing coverage scenario with %d vertex polygon...\n\n', n);
end

% Graph title
fig = gcf;
uicontrol('Style', 'text',...
   'String', sprintf('CPP Solutions'),...
   'Units','normalized',...
   'FontSize',15,...
   'BackgroundColor', 'white',...
   'Position', [0.345 0.965 0.29 0.037]);

% ============== Nearest Neighbor (greedy PTP) ======================
fprintf('Running Nearest Neighbor (C++) solver on CPP problem...\n');
tic;
[V, E, X, Cost] = solveCpp(P,C,options,'boustrophedon')

elapsedTime = toc;
c = Cost;
vertexOrder = getVertexOrder(E)

if strcmp(options.Debug,'on')
    fprintf(['Found Boustrophedon C++ solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Boustrophedon C++ (cost = %.2f)',c);
hAx = plotWaypointScenario(V, E, subplotDim, 2, titleStr, options);
plotWaypointDubins(hAx, V, E, X, options); 
pause(0.5)

% 
% % ============== Alternating Algorithm (DTSP) ======================
% 
% fprintf('Running Alternating Algorithm (C++) solver on CPP problem...\n');
% tic;
% [V, E, X, Cost] = solveCppAsDtsp(P,C,options,'alternating');
% 
% elapsedTime = toc;
% c = Cost;
% vertexOrder = getVertexOrder(E);
% 
% if strcmp(options.Debug,'on')
%     fprintf(['Found Alternating Algorithm C++ solution with a total cost of %.2f in %.2f seconds.\n\n'],...
%         c, elapsedTime);
% end
% titleStr = sprintf('Alternating C++ (cost = %.2f)',c);
% hAx = plotWaypointScenario(V, E, subplotDim, 3, titleStr, options);
% plotWaypointDubins(hAx, V, E, X, options); 
% 
% % ============== Randomized Algorithm (DTSP) ======================
% 
% fprintf('Running Randomized Algorithm (C++) solver on CPP problem...\n');
% tic;
% [V, E, X, Cost] = solveCppAsDtsp(P,C,options,'randomized');
% 
% elapsedTime = toc;
% c = Cost;
% vertexOrder = getVertexOrder(E);
% findDubinsTourCost(V,X,E,options);
% 
% if strcmp(options.Debug,'on')
%     fprintf(['Found Randomized Algorithm C++ solution with a total cost of %.2f in %.2f seconds.\n\n'],...
%         c, elapsedTime);
% end
% titleStr = sprintf('Randomized C++ (cost = %.2f)',c);
% hAx = plotWaypointScenario(V, E, subplotDim, 4, titleStr, options);
% plotWaypointDubins(hAx, V, E, X, options); 

% fix annotations
print;
