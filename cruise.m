% Harry Toms - egyht4 
% % This script uses variables from the project spreadsheet to predict the 
% glide performance of the glider.
%
% The script does the following: 
%   1) Uses AoA between 1 and 8 degrees to find the AoA that maximises
%      horizontal distance from the launcher ("best case").
%   2) Evaluates glide range, speed and trajectory at a more realistic
%      design AoA 
%   3) Computes stall speed V_stall and V_min_drag 
%   4) Plots the predicted glide path (height vs horizontal distance)

%% Variables
Mass = 0.11;
wingArea = 0.1066667;
aspectRatio = 6;
oswaldEff = 0.95;
rho = 1.225;
g = 9.81;


% variables from climb
releaseHeight = 2.5;          
releaseSpeed  = 5;          
releaseDist   = 7.5;

%% Glide parameters
CL_0     = 0.29;       
CL_max = 0.927;      % from JavaFoil 
a_deg   = 0.085;      % gradient of cl vs alpha (degrees)
a_rad   = a_deg * (180/pi);   % alpha in radians

CD0_wing = 0.023;     % wing profile drag cl0
CD0      = 2 * CD0_wing;  % whole-glider zero-lift drag

k = 1 / (pi * oswaldEff * aspectRatio);  % induced drag factor (k)

%% Glide modelling
a_range = 1:0.5:8; % range of AOA values for iteration loop
n = numel(a_range); 
bestRange = 0;
bestAlpha = 0;
for i = 1:n
    alpha_i = a_range(i);
    
    % calculating lift and drag at given AOA
    % debug line: fprintf('alpha = %.2f deg\n', alpha_i)
    CL_i = CL_0 + a_deg * alpha_i;
    CD_i = CD0 + k * (CL_i).^2;
    LD_i = CL_i / CD_i;
    
    % calculate glide range
    glideRange_i = LD_i * releaseHeight;
    totalRange_i = glideRange_i + releaseDist;

    if totalRange_i > bestRange
        bestRange = totalRange_i;
        bestAlpha = alpha_i;
    end
end

fprintf('Best AoA           = %.2f deg\n', bestAlpha);
fprintf('Max total range    = %.2f m\n', bestRange);

% Glide performance at best AOA
CL_glide = CL_0 + a_deg * bestAlpha;
CD_glide = CD0 + k * (CL_glide).^2;
LD_glide = CL_glide / CD_glide;

glideRange  = LD_glide * releaseHeight;


%% Glide performance for expected AOA
alpha_design_deg = 5;
CL_design = CL_0 + a_deg * alpha_design_deg;
CD_design = CD0 + k * (CL_design).^2;
LD_design = CL_design / CD_design;

glideRange_design = LD_design * releaseHeight;
totalRange_design = releaseDist + glideRange_design;

% Speed for this CL
W = Mass * g;
V_design = sqrt((2 * W) / (rho * wingArea * CL_design));
glideTime_design = glideRange_design / V_design;

% Calculate v min drag and v stall
V_stall = sqrt( (2 * W) / (rho * wingArea * CL_max) );
CL_VMD = sqrt(CD0 / k);
V_min_drag = sqrt( (2 * W) / (rho * wingArea * CL_VMD) );

fprintf('\nActual design AoA case:\n');
fprintf('  alpha_design       = %.2f deg\n', alpha_design_deg);
fprintf('  CL_design          = %.3f\n', CL_design);
fprintf('  CD_design          = %.3f\n', CD_design);
fprintf('  L/D_design         = %.2f\n', LD_design);
fprintf('  V_stall      = %.2f m/s\n', V_stall);
fprintf('  V_min_drag   = %.2f m/s (at CL_VMD = %.3f)\n', V_min_drag, CL_VMD);
fprintf('  V_glide (design)   = %.2f m/s\n', V_design);
fprintf('  Glide range        = %.2f m\n', glideRange_design);
fprintf('  Total range        = %.2f m\n', totalRange_design);
fprintf('  Glide time         = %.2f s\n', glideTime_design);

%% Graphing 

x_points = [releaseDist, releaseDist + glideRange];
h_points = [releaseHeight, 0];

figure;
plot(x_points, h_points, '-o');   % straight line + markers
xlabel('Horizontal distance x [m]');
ylabel('Height h [m]');
title('Glide trajectory (from winch release to landing)');
grid on;
