close all;
clear all;
Vt = 200;
alphaT = 60;
alphaT_rad = (alphaT/180)*pi;

R0 = 7000;
theta0 = 30;
theta0_rad = (theta0/180)*pi;

xt0 = R0*cos(theta0_rad);
yt0 = R0*sin(theta0_rad);

Vt_hor = Vt*cos(alphaT_rad);
Vt_ver = Vt*sin(alphaT_rad);

a_t = 0;%3*9.8;%
a_t_hor = a_t*cos(pi/2);
a_t_ver = a_t*sin(pi/2);

xm0 = 0;
ym0 = 0;

maxTime = 100;
delTime = 1;

xt = xt0;
yt = yt0;
theta_rad = theta0_rad;
theta = theta_rad * (180/pi);
del_theta = 0;

Vm = Vt/0.6;
xm = xm0;
ym = ym0;

alphaM = 30;
alphaM_rad = alphaM * (pi/180);
Vm_hor = Vm*cos(alphaM_rad);
Vm_ver = Vm*sin(alphaM_rad);
Rm = norm([xm ym],2);
del_Rm = 0;

V_R = Vt*cos(alphaT_rad - theta_rad) - Vm*cos(alphaM_rad - theta_rad);
N = 3;

figHandle = figure(1);
set(figHandle,'WindowStyle','docked');
f1 = subplot(2,3,1);
l1 = plot([0,xm,xt],[0,ym,yt],'b');
imgframe =0;

for t = 1:delTime:maxTime
    
    xt2 = xt + (Vt_hor * delTime) + (1/2)*a_t_hor*(delTime^2);
    yt2 = yt + (Vt_ver * delTime) + (1/2)*a_t_ver*(delTime^2);
    
    alphaT_rad = atan2((yt2-yt),(xt2-xt));
    alphaT = alphaT_rad*(180/pi);
    yt = yt2;
    xt = xt2;
    Vt_hor = Vt_hor + (a_t_hor*delTime);
    Vt_ver = Vt_ver + (a_t_ver*delTime);
    
    theta2_rad = atan2(yt-ym,xt-xm);
    del_theta = (theta2_rad - theta_rad)/delTime;
    theta_rad = theta2_rad;
    theta = theta_rad * (180/pi);
        
    a_m = -N*V_R*del_theta;
    a_m_hor = a_m*cos(pi/2 + theta_rad);%+ve x-axis
    a_m_ver = a_m*sin(pi/2 + theta_rad);%+ve y-axis    
    
    xm2 = xm + (Vm_hor*delTime) + (1/2)*a_m_hor*(delTime^2);
    ym2 = ym + (Vm_ver*delTime) + (1/2)*a_m_ver*(delTime^2);
    
    alphaM_rad = atan2(ym2-ym,xm2-xm);
    alphaM = alphaM_rad * (180/pi);
    
    xm = xm2;
    ym = ym2;
    
    Vm_hor = Vm*cos(alphaM_rad) + (a_m_hor*delTime);
    Vm_ver = Vm*sin(alphaM_rad) + (a_t_ver*delTime);
    Vm = norm([Vm_hor Vm_ver],2);
    V_R = Vt*cos(alphaT_rad - theta_rad) - Vm*cos(alphaM_rad - theta_rad);
    R = norm([(xt-xm) (yt-ym)],2);
    
%       if t == 1
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
    l1 = plot([0 xt], [0 yt], 'b');
    xlabel('X-coordinate (meters)');
    ylabel('Z-coordinate (meters)');
        
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
    plot(t,a_m,'*r');
    xlabel('Time');
    ylabel('Acceleration (m/s^{2})');

%     f5 = figure(5);
%     set(f5,'WindowStyle','docked');  
    f5 = subplot(2,3,5);
    box on;
    hold on;
    plot(t,Vt*sin(alphaT_rad - theta_rad) - Vm*sin(alphaM_rad - theta_rad),'*r');%
    plot(t,Vt*cos(alphaT_rad - theta_rad) - Vm*cos(alphaM_rad - theta_rad),'*b');% 
    xlabel('Time');
    ylabel(' V_{R}(blue) (m/s), V_{theta}(red) (m/s)');
    
%     f6 = figure(6);
%     set(f6,'WindowStyle','docked');  
    f6 = subplot(2,3,6);
    box on;
    hold on;
    plot(Vt*sin(alphaT_rad - theta_rad) - Vm*sin(alphaM_rad - theta_rad),Vt*cos(alphaT_rad - theta_rad) - Vm*cos(alphaM_rad - theta_rad),'k*'); % 
    xlabel('V_{theta} (m/s)');
    ylabel('V_R (m/s)');
    
    imgframe = imgframe+1;
    images1(imgframe) = getframe(figHandle);

end

for i = 1:imgframe-1
[im, map] = frame2im(images1(i));
name = ['rtpn_plot',num2str(i),'.jpg'];
imwrite(im,name,'jpg');
end

filename = 'rtpn';
save(filename);
movie2avi(images1,[filename '.avi'],'fps',4);
movie2avi(images1,[filename '_medium.avi'],'fps',5);
movie2avi(images1,[filename '_small.avi'],'fps',6);
% movie2avi(images1,[filename '_ffds.avi'],'Compression','FFDS','fps',4);
