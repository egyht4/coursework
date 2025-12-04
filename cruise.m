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
CL0     = 0.29;       % 
a_deg   = 0.085;      % gradient of cl vs alpha (degrees)
a_rad   = a_deg * (180/pi);   % alpha in radians

CD0_wing = 0.023;     % wing profile drag cl0
CD0      = 2 * CD0_wing;  % whole-glider zero-lift drag

k = 1 / (pi * oswaldEff * aspectRatio);  % induced drag factor (k)

%% Glide modelling
a_glide_deg = 2.5;
a_glide_rad = a_glide_deg * (180/pi);
