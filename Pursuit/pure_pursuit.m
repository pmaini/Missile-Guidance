close all
clear all

Vt = 300;
alphaT = 170;
alphaT_rad = (alphaT/180)*pi;

R0 = 3000;
theta0 = 30;
theta0_rad = (theta0/180)*pi;

xt0 = R0*cos(theta0_rad);
yt0 = R0*sin(theta0_rad);
Vt_hor = Vt*cos(alphaT_rad);
Vt_ver = Vt*sin(alphaT_rad);

Mu = 2.5;
Vm = Mu*Vt;

xm0 = 0;
ym0 = 0;

xt = xt0;
yt = yt0;
xm = xm0;
ym = ym0;

delta = 30;
alphaM_rad = atan2((yt-ym),(xt-xm)) + (delta/180)*pi;
Vm_hor = Vm*cos(alphaM_rad);
Vm_ver = Vm*sin(alphaM_rad);
delTime = 1;

imgframe = 0;
figHandle = figure;
set(figHandle,'WindowStyle','docked');
hold on;
f1 = subplot(2,3,1);
l1 = plot(0,0,'*');

for t = 0:delTime:50

    xt = xt + Vt_hor*delTime;
    yt = yt + Vt_ver*delTime;
    
    R = sqrt((yt-ym)^2 + (xt-xm)^2);
    
    theta_rad = atan2((yt-ym),(xt-xm));
    alphaM_rad = theta_rad + (delta*(pi/180));
    
    Vm_hor2 = Vm*cos(alphaM_rad);
    Vm_ver2 = Vm*sin(alphaM_rad);
    
    am_hor = (Vm_hor2 - Vm_hor)/delTime;
    am_ver = (Vm_ver2 - Vm_ver)/delTime;
    
    Vm_hor = Vm_hor2;
    Vm_ver = Vm_ver2;
    
    am = norm([am_hor am_ver],2);
    
    xm = xm + Vm_hor*delTime;
    ym = ym + Vm_ver*delTime;

%     if t == 1
    pause(0.1);
%     end

%     f1 = figure(1);
%     set(f1,'WindowStyle','docked');
    f1 = subplot(2,3,1);
    box on;
    hold on;
    delete(l1);
    plot(xt,yt,'r*');    
    plot(xm,ym,'g*');
    l1 = plot([xm xt], [ym yt], 'b');
    xlabel('X-coordinate (meters)');
    ylabel('Y-coordinate (meters)');
        
%     f2 = figure(2);
%     set(f2,'WindowStyle','docked');
    f2 = subplot(2,3,2);
    box on;
    hold on;
    plot(t,R,'*b');
    xlabel('Time');
    ylabel('LOS Distance (meters)');
   
%     f3 = figure(3);
%     set(f3,'WindowStyle','docked');
    f3 = subplot(2,3,3);
    box on;
    hold on;
    plot(t,theta_rad*(180/pi),'+b');%alphaM_rad,
    xlabel('Time');
    ylabel('theta (degrees)');
     
%     f4 = figure(4);
%     set(f4,'WindowStyle','docked');   
    f4 = subplot(2,3,4);
    box on;
    hold on;
    plot(t,am,'*r');
    xlabel('Time');
    ylabel('Lateral Acceleration (m/s^{2})');

%     f5 = figure(5);
%     set(f5,'WindowStyle','docked');  
    f5 = subplot(2,3,5);
    box on;
    hold on;
    plot(t,Vt*sin(alphaT_rad - theta_rad) - Vm*sin((delta/180)*pi),'*r');%
    plot(t,Vt*cos(alphaT_rad - theta_rad) - Vm*cos((delta/180)*pi),'*b');% 
    xlabel('Time');
    ylabel(' V_{R}(blue) (m/s), V_{theta}(red) (m/s)');
    
%     f6 = figure(6);
%     set(f6,'WindowStyle','docked');  
    f6 = subplot(2,3,6);
    box on;
    hold on;
    plot(Vt*sin(alphaT_rad - theta_rad) - Vm*sin((delta/180)*pi),Vt*cos(alphaT_rad - theta_rad) - Vm*cos((delta/180)*pi),'k*'); % 
    xlabel('V_{theta} (m/s)');
    ylabel('V_R (m/s)');
    
    imgframe = imgframe+1;
    images1(imgframe) = getframe(figHandle);

end

for i = 1:imgframe-1
[im, map] = frame2im(images1(i));
name = ['dp30IA2_5_plot',num2str(i),'.jpg'];
imwrite(im,name,'jpg');
end

filename = 'dp30IA1_1';
save(filename);
movie2avi(images1,[filename '.avi'],'fps',4);
movie2avi(images1,[filename '_medium.avi'],'fps',5);
movie2avi(images1,[filename '_small.avi'],'fps',6);
% movie2avi(images1,[filename '_ffds.avi'],'Compression','FFDS','fps',4);

%{
% K = R0*(((1+cos(alphaT_rad - theta0_rad))^Mu)/((sin(alphaT_rad - theta0_rad))^(Mu-1)));
% 
% syms theta_sim R t;
% theta_sim = solve(theta_sim - alphaT_rad - acos((R0*(Vt*cos(alphaT_rad-theta0_rad)+Vm) - ((Vm^2)-(Vt^2))*t)/(R*Vt) - (Vm/Vt)),theta_sim);
% R = solve(R - K*(((sin(alphaT_rad - theta_sim))^(Mu-1))/((1+cos(alphaT_rad - theta_sim)))^Mu),R);
% double(theta_sim);
% % thet
%}