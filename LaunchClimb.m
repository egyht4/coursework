%% Variables 
Mass = 0.100; 
wingArea = 0.081; 
aspectRatio = 10; 
oswaldEff = 0.95; 
launchSpeed = 5; 
launchHeight = 0.2; 
launchTime = 1.5; 
launchDist = 3; 
time = 0;
StartingWinchLength = 20; 
winchX = StartingWinchLength;   % winch is ahead of glider by StartingWinchLength
winchY = launchHeight;          % same height as launch interface
AirDensity = 1.225; 
InitialChordAngle = 7; 
lGrad = 0.08; 
CL0 = 0.293; 
CD0 = 0.02556*2; 
CoeffI = 1/(oswaldEff*pi*aspectRatio);
lGradEff = lGrad/(1+(lGrad/(pi*aspectRatio*oswaldEff)));
Weight = Mass*9.81;
dt = 0.1;
steps = round(launchTime/dt);

%% make graph
figure; hold on; grid on; axis equal;
xlim([0 7]); ylim([0 2]);

%% simulate two bounding cases without trim data
params = struct('Mass',Mass,'wingArea',wingArea,'aspectRatio',aspectRatio, ...
    'oswaldEff',oswaldEff,'launchSpeed',launchSpeed,'launchHeight',launchHeight, ...
    'launchTime',launchTime,'StartingWinchLength',StartingWinchLength, ...
    'winchX',winchX,'winchY',winchY,'AirDensity',AirDensity, ...
    'InitialChordAngle',InitialChordAngle,'CL0',CL0,'CD0',CD0, ...
    'CoeffI',CoeffI,'lGradEff',lGradEff,'Weight',Weight,'dt',dt,'steps',steps);

traj_pitch = simulateTow(params, 'pitch');  % AoA = pitch - flight path angle
traj_aoa   = simulateTow(params, 'aoa');    % AoA fixed to InitialChordAngle

plot(traj_pitch.x, traj_pitch.y, 'o-', 'MarkerSize', 4, 'MarkerFaceColor', 'b', 'Color', 'b');
plot(traj_aoa.x,   traj_aoa.y,   'o-', 'MarkerSize', 4, 'MarkerFaceColor', 'r', 'Color', 'r');
legend('Pitch-based AoA (more conservative)', 'Constant AoA (optimistic)', 'Location', 'best');

function traj = simulateTow(p, aoaMode)
    x = 0;
    y = p.launchHeight;
    Vx = p.launchSpeed;
    Vy = 0;
    time = 0;
    traj.x = zeros(p.steps+1,1);
    traj.y = zeros(p.steps+1,1);
    traj.x(1) = x;
    traj.y(1) = y;

    for k = 1:p.steps
        time = time + p.dt;
        WinchLength = p.StartingWinchLength - p.launchSpeed*time;
        if WinchLength <= 0
            Tension = 0;
        else
            Tension = (p.Mass*p.launchSpeed^2)/WinchLength;
        end

        cableDx = p.winchX - x;
        cableDy = p.winchY - y;
        cableDist = sqrt(cableDx^2 + cableDy^2);
        if cableDist > 0
            cableUx = cableDx / cableDist;
            cableUy = cableDy / cableDist;
        else
            cableUx = 0;
            cableUy = 0;
        end
        TensionX = Tension * cableUx;
        TensionY = Tension * cableUy;

        speed = sqrt(Vx^2 + Vy^2);
        if speed <= 0
            speed = 1e-6;
        end
        if strcmp(aoaMode,'aoa')
            AoA = p.InitialChordAngle;
        else
            ClimbAngle = atan2d(Vy, Vx);
            AoA = p.InitialChordAngle - ClimbAngle;
        end
        CL = p.CL0 + p.lGradEff * AoA;
        CD = p.CD0 + p.CoeffI * CL^2;

        Drag = -0.5*p.AirDensity*speed^2*p.wingArea*CD;
        Lift = 0.5*p.AirDensity*speed^2*p.wingArea*CL;
        velUx = Vx / speed;
        velUy = Vy / speed;
        DragX = Drag * velUx;
        DragY = Drag * velUy;
        LiftX = -Lift * velUy;
        LiftY = Lift * velUx;

        Fx = TensionX + DragX + LiftX;
        Fy = LiftY - p.Weight + TensionY + DragY;

        ax = Fx / p.Mass;
        ay = Fy / p.Mass;

        Vx = Vx + ax * p.dt;
        Vy = Vy + ay * p.dt;
        x = x + Vx * p.dt;
        y = y + Vy * p.dt;

        traj.x(k+1) = x;
        traj.y(k+1) = y;
    end
end
