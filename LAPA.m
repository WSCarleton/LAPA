clear
clc

% Variables
nx = 20; %number of rows
ny = 20; %number of columns
V = zeros(nx, ny); %Voltage array of size nx rows by ny columns
V2 = zeros(nx, ny); %Voltage array of size nx rows by ny columns

iterations = 10000; %number of specified iterations

% Calculations
% boundary conditions for V
for z = 1:ny
    V(1, z) = 1; %left BC
    V(nx, z) = 0; %right BC
end
% boundary conditions for V2
for z = 1:ny
    V2(1, z) = 1; %left BC
    V2(nx, z) = 1; %right BC
end
for z = 1:nx
    V2(z, 1) = 0; %up BC
    V2(z, ny) = 0; %down BC
end

figure(1)
clf

for k = 1:iterations
    V(2:nx-1, 2:ny-1) = (V(1:nx-2, 2:ny-1) + V(3:nx, 2:ny-1) + V(2:nx-1, 1:ny-2) + V(2:nx-1, 3:ny))/4;
    V(1:nx, ny) = V(1:nx, ny-1);
    V(1:nx, 1) = V(1:nx, 2);
    slope1 = (V(1, 1) - V(2, 1));
    slope2 = (V(nx-1,1) - V(nx,1));
    if (abs(slope1-slope2)) < 5e-3
         break;
    end 
        
    % center matrix   =   shifted left    +  shifted right  +   shifted up      + shifted down 
    subplot(2, 3, 1);
    surf(V);
    xlabel('x'); ylabel('y');
    frame_h = get(handle(gcf),'JavaFrame');
    set(frame_h, 'Maximize',1);
    title('Voltage Spreading in a Nodal Matrix (L&R BCs)');
    view(135, 45);
    pause(0.1);
    
    V2(2:nx-1, 2:ny-1) = (V2(1:nx-2, 2:ny-1) + V2(3:nx, 2:ny-1) + V2(2:nx-1, 1:ny-2) + V2(2:nx-1, 3:ny))/4;
    % center matrix   =   shifted left    +  shifted right  +   shifted up      + shifted down 
    subplot(2, 3, 4);
    surf(V2);
    title('Voltage Spreading in a Nodal Matrix (L&R, U&D BCs)');
    view(90, 67.5);
    
    [Ex, Ey] = gradient(V);
    Ex = -Ex; Ey = -Ey;
    subplot(2, 3, 2);
    quiver(Ex, Ey);
    
    [Ex2, Ey2] = gradient(V2);
    Ex2 = -Ex2; Ey2 = -Ey2;
    subplot(2, 3, 5);
    quiver(Ex2, Ey2);
    
    subplot(2, 3, 3);
    F = imboxfilt(V, 3);
    surf(F);
    subplot(2, 3, 6);
    F2 = imboxfilt(V2, 3);
    surf(F2);
end

