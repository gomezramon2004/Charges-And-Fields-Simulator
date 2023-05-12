clear; clc; close all;

%Input
while true
    length_var1 = input('Input the length of the positive plate: ');
    height_var1 = input('Input the height of the positive plate: ');
    x1 = input('Input the x-coord of the positive plate: ');
    y1 = input('Input the y-coord of the positive plate: ');
    Qp = input('Input the charge of the positive plate: ');
    length_var2 = input('Input the length of the negative plate: ');
    height_var2 = input('Input the height of the negative plate: ');
    x2 = input('Input the x-coord of the negative plate: ');
    y2 = input('Input the y-coord of the negative plate: ');
    Qn = input('Input the charge of the negative plate: ');
    maxLength = max(length_var1, length_var2); maxHeight = max(height_var1, height_var2);
    
    if any([length_var1, height_var1, length_var2, height_var2, x2, Qp] <= 0)
        error('Value must be positive. Try again...');
    elseif x1 >= 0 || Qn >= 0
        error('Value must be negative. Try again...');
    elseif sum(abs([x1 x2])) <= maxLength
        error('Distance between plates needs to be larger. Try again...');
    else
        break;
    end
end

% Grid
N = 40;
largestXPoint = abs(max(x1, x2)) + maxLength;
highestYPoint = abs(max(y1, y2)) + maxHeight;
theFamousBig = max(largestXPoint, highestYPoint);

x=linspace(-theFamousBig*2,theFamousBig*2,N);
y=linspace(-theFamousBig*2,theFamousBig*2,N);
[xG, yG]=meshgrid(x,y);

% Electric Field
prom = max((length_var1/0.1+length_var2/0.1)/2,(height_var1/0.1+height_var2/0.1)/2);
kPromLength1 = length_var1/prom;
kPromLength2 = length_var2/prom;
kPromHeight1 = height_var1/prom;
kPromHeight2 = height_var2/prom;
nLength1 = -(length_var1/2);
nLength2 = -(length_var2/2);
nHeight1 = -(height_var1/2);
nHeight2 = -(height_var2/2);
EX = 0; EY = 0; ET = 0;
eps0 = 8.854e-12;
kC = 1/(4*pi*eps0);

for i=1:prom

    % Looping
    % Negative Plate
    Rx = xG - x2 - nLength2;
    Ry = yG - y2 - nHeight2;
    R = sqrt(Rx.^2 + Ry.^2).^3;
    Ex = kC .* Qn .* Rx ./ R;
    Ey = kC .* Qn .* Ry ./ R;
    % Positive Plate
    Rx = xG - x1 - nLength1;
    Ry = yG - y1 - nHeight1;
    R = sqrt(Rx.^2 + Ry.^2).^3;
    Ex = Ex + kC .* Qp .* Rx ./ R;
    Ey = Ey + kC .* Qp .* Ry ./ R;
    % Total
    E = sqrt(Ex.^2 + Ey.^2); 

    % Summation
    EX = EX + Ex;
    EY = EY + Ey;
    ET = ET + E;
    
    % Loopers
    nLength1 = nLength1 + kPromLength1;
    nLength2 = nLength2 + kPromLength2;
    nHeight1 = nHeight1 + kPromHeight1;
    nHeight2 = nHeight2 + kPromHeight2;
end
    
u = EX./ET;
v = EY./ET;

% Graph
figure()
h=quiver(x,y,u,v);
box on

axis([-theFamousBig*1.5, theFamousBig*1.5, -theFamousBig*1.5, theFamousBig*1.5]); axis manual
rectangle('Position', [x1-length_var1/2 y1-height_var1/2 length_var1 height_var1], 'LineWidth',2, 'Facecolor',[1 0 0]);
rectangle('Position', [x2-length_var2/2 y2-height_var2/2 length_var2 height_var2], 'LineWidth',2, 'Facecolor',[0 0 1]);
text(x1, y1,'+','FontSize',20,'FontWeight','normal','Color','w','HorizontalAlignment','center','VerticalAlignment','middle')
text(x2, y2,'-','FontSize',20,'FontWeight','normal','Color','w','HorizontalAlignment','center','VerticalAlignment','middle')

% Plot Settings
grid on, xlabel('x'), ylabel('y'), title('Simulación')
legend('Campo eléctrico')
pbaspect([1 1 1]);