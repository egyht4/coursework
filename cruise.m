%% Variables
Mass = 0.092;
wingArea = 0.1066667;
aspectRatio = 6;
oswaldEff = 0.95;
rho = 1.225;
g = 9.81;

% variables from climb
releaseHeight = 8;          
releaseSpeed  = 5;          
releaseDist   = 7.5;

%% Glide parameters
CL_0     = 0.29;       % 
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

fprintf('Best AoA           = %.2f deg\n', alpha_best);
fprintf('Max total range    = %.2f m\n', totalRange_best);

% Glide performance at best AOA
CL_glide = CL_0 + a_deg * alphaBest;
CD_glide = CD_0 + k * (CL_glide).^2;
LD_glide = CL_glide / CD_glide;

glideRange  = LD_glide * releaseHeight;
