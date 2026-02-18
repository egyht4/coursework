%% Variables 
Mass = 0.107; 
wingArea = 0.081; 
aspectRatio = 10; 
oswaldEff = 0.95; 
launchSpeed = 5; 
launchHeight = 0.2; 
launchTime = 1.5; 
launchDist = 3; 
time = 0;
StartingWinchLength = 20; 
WinchLength = StartingWinchLength-launchSpeed*time;
AirDensity = 1.225; 
InitialChordAngle = 7; 
lGrad = 0.08; 
CL0 = 0.293; 
CD0 = 0.02556; 
CoeffI = 1/(oswaldEff*pi*aspectRatio);
% calculate tension (h and v components) 
Tension = (Mass*launchSpeed^2)/WinchLength;
CL = 0.88 ; % CL0+(lGrad/(1+(lGrad/(pi*aspectRatio*oswaldEff))))*InitialChordAngle 
Lift = 0.5*AirDensity*launchSpeed^2*wingArea*CL;
CD = CD0 + CoeffI*CL^2; 
Drag = -1*0.5*AirDensity*launchSpeed^2*wingArea*CD;
Weight = Mass*9.81;
StartAngle = 0;
ClimbAngle = asind(Tension/Weight-CD/CL);

%% resolve forces
Fx = Tension+Drag;      % horizontal force (N)
Fy = Lift-Weight; % vertical force (N)

%% make graph
figure; hold on; grid on; axis equal;
xlim([0 7]); ylim([0 2]);

%% Calculate acceleration
accelerationX = Fx / Mass;  % horizontal acceleration (m/s^2)
accelerationY = Fy / Mass; % vertical acceleration (m/s^2)

%% intergrate conponents of axceleraton with respect to time to get velocity
%starting velocity x=5 y=0
time = 0;
VelocityX = accelerationX * 0.1 + launchSpeed; % horixzontal velocity
VelocityY = accelerationY * 0.1 + 0; % vertical velocity (m/s)

%% intergrate conponents of velocity with respect to time to get displacement
%starting position x=0 y=0.2
displacementX = VelocityX * 0.1 + 0; % horizontal displacement
displacementY = VelocityY * 0.1 + launchHeight; % vertical displacement
plot(displacementX, displacementY, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
    drawnow;

%% repeat
for k = 1:15

    % update forces based new position
    time = time + 0.1;
WinchLength = StartingWinchLength-launchSpeed*time;
Tension = (Mass*launchSpeed^2)/WinchLength;
winchangle = asind(displacementX/WinchLength);
TensionX = Tension*(sind(winchangle+InitialChordAngle));
TensionY = Tension*(cosd(winchangle+InitialChordAngle));
% update L/D based on new climb angle
CL = CL0+(lGrad/(1+(lGrad/(pi*aspectRatio*oswaldEff))))*(InitialChordAngle+ClimbAngle);
CD = CD0 + CoeffI*CL^2;
ClimbAngle = asind(Tension/Weight-CD/CL);
% Update forces based on new climb angle
Drag = -1*0.5*AirDensity*VelocityX^2*wingArea*CD;
Lift = 0.5*AirDensity*VelocityX^2*wingArea*CL;
LiftX = -1*Lift*sind(ClimbAngle);
LiftY = Lift*cosd(ClimbAngle);
Fx = TensionX+Drag+LiftX  ;    % horizontal force (N)
Fy = LiftY-Weight-TensionY ;     % vertical force (N)

%% Calculate acceleration
accelerationX = Fx / Mass;  % horizontal acceleration (m/s^2)
accelerationY = Fy / Mass; % vertical acceleration (m/s^2)

%% intergrate conponents of axceleraton with respect to time to get velocity
VelocityX = accelerationX * 0.1 + VelocityX; % horixzontal velocity
VelocityY = accelerationY * 0.1 + VelocityY; % vertical velocity (m/s)

%% intergrate conponents of velocity with respect to time to get displacement
%starting position x=0 y=0.2
displacementX = VelocityX * 0.1 + displacementX; % horizontal displacement
displacementY = VelocityY * 0.1 + displacementY; % vertical displacement
    plot(displacementX, displacementY, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
    drawnow;
    
end