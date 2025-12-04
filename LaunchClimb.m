%% Variables 
Mass = 0.0916; 
wingArea = 0.1066667; 
aspectRatio = 6; 
oswaldEff = 0.95; 
launchSpeed = 5; 
launchHeight = 0.2; 
launchTime = 1.5; 
launchDist = 3; 
StartingWinchLength = 20; 
AirDensity = 1.225; 
InitialChordAngle = 6; 
lGrad = 0.08; 
CL0 = 0.293; 
CD0 = 0.04651; 
CoeffI = 1/(oswaldEff*pi*aspectRatio);
% calculate tension (h and v components) 
Tension = (Mass*launchSpeed^2)/StartingWinchLength
CL = CL0+(lGrad/(1+(lGrad/(pi*aspectRatio*oswaldEff))))*InitialChordAngle; 
Lift = 0.5*AirDensity*launchSpeed^2*wingArea*CL;
CD = CD0 + CoeffI*CL^2; 
Drag = 0.5*AirDensity*launchSpeed^2*wingArea*CD
Weight = Mass*9.81;
StartAngle = 0;
ClimbAngle = asind(Tension/Weight-CD/CL);
%% resolve forces
Fx = Tension-Drag;      % horizontal force (N)
Fy = Lift-Weight;      % vertical force (N)

%% Calculate acceleration
accelerationX = Fx / Mass  % horizontal acceleration (m/s^2)
accelerationY = Fy / Mass % vertical acceleration (m/s^2)
%% intergrate conponents of axceleraton with respect to time to get velocity
%starting velocity x=0 y=0
VelocityX = accelerationX * time + 0; % horixzontal velocity
VelocityY = accelerationY * time + 0; % vertical velocity (m/s)
%% intergrate conponents of velocity with respect to time to get displacement
%starting position x=0 y=0.2
displacementX = 0.5 * accelerationX * time^2 + 0; % horizontal displacement
displacementY = 0.5 * accelerationY * time^2 + 0.2; % vertical displacement

