close all;
clear all;
Vt = 200;
alphaT = 170;
xt0 = 10000;
yt0 = 800;
a_t = 0;%3*9.8;%
a_t_hor = a_t*cos(pi/2);
a_t_ver = a_t*sin(pi/2);

xm0 = 0;
ym0 = 0;

maxTime = 25;
delT = 0.1;

alphaT_rad = alphaT*(pi/180);
Vt_hor = Vt * cos(alphaT_rad);
Vt_ver = Vt * sin(alphaT_rad);
xt = xt0;
yt = yt0;
thetaT_rad = atan3(yt,xt);
thetaT = thetaT_rad * (180/pi);
del_thetaT = 0;
Rt = norm([xt yt],2);

Vm = Vt/0.6;
xm = xm0;
ym = ym0;
thetaM_rad = atan3(ym,xm);
thetaM = thetaM_rad * (180/pi);
alphaM_rad = atan3(yt-ym,xt-xm);
alphaM = alphaM_rad * (180/pi);
Vm_hor = Vm*cos(alphaM_rad);
Vm_ver = Vm*sin(alphaM_rad);
Rm = norm([xm ym],2);
del_Rm = 0;

K_p = 10;

figHandle = figure(1);
set(figHandle,'WindowStyle','docked');
f1 = subplot(1,3,1);
l1 = plot([0,xm,xt],[0,ym,yt],'b');
imgframe =0;

for t = 1:delT:maxTime
    xt = xt + (Vt_hor * delT);% + (1/2)*a_t_hor*(delT^2);
    yt = yt + (Vt_ver * delT);% + (1/2)*a_t_ver*(delT^2);
    
%     alphaT_rad = atan3((yt2-yt),(xt2-xt));
%     alphaT = alphaT_rad*(180/pi);
%     yt = yt2;
%     xt = xt2;
%     Vt_hor = Vt_hor+ (a_t_hor*delT);
%     Vt_ver = Vt_ver + (a_t_ver*delT);
    
    Rt = norm([xt yt],2);
    del_thetaT_rad = (Vt*sin(alphaT - thetaT_rad))/Rt;
    del_del_thetaT_rad = -(Vt*cos(alphaT - thetaT_rad) * del_thetaT)/Rt;
    thetaT_rad = thetaT_rad + del_thetaT_rad * delT;
%     thetaT2_rad = atan3(yt,xt);
%     del_thetaT2 = (thetaT2_rad - thetaT_rad)/delT;
%     del_del_thetaT = (del_thetaT2 - del_thetaT)/delT;
    
%     del_thetaT = del_thetaT2;
%     thetaT_rad = thetaT2_rad;
    thetaT = thetaT_rad * (180/pi);
        
    a_m = (K_p * Rm * (thetaT_rad - thetaM_rad)) + (Rm*del_del_thetaT_rad) + (2*del_Rm*del_thetaT_rad);
%     a_m_hor = a_m*cos(pi/2 +alphaM_rad);%+ve x-axis
%     a_m_ver = a_m*sin(pi/2 +alphaM_rad);%+ve y-axis    
    alphaM_rad = a_m/Vm;    
%     alphaM_rad = atan3(ym2-ym,xm2-xm);
    alphaM = alphaM_rad * (180/pi);
    
    xm = xm + Vm_hor*delT;% + (1/2)*a_m_hor*(delT^2);
    ym = ym + Vm_ver*delT;% + (1/2)*a_m_ver*(delT^2);
% 
%     xm = xm2;
%     ym = ym2;

    del_Rm = Vm*cos(alphaM_rad - thetaM_rad); % (Rm2 - Rm)/delT;    
    Rm = Rm + del_Rm*delT; % norm([xm ym],2);
%     Rm = Rm2;
    del_thetaM_rad = (Vm*sin(alphaM_rad - thetaM_rad))/Rm;
    thetaM_rad = del_thetaM_rad*delT;%atan3(ym,xm);
    thetaM = thetaM_rad * (180/pi);
    Vm_hor = Vm*cos(alphaM_rad);
    Vm_ver = Vm*sin(alphaM_rad);
    R = norm([(xt-xm) (yt-ym)],2);
    
%     if t == 1
    pause(0.1);
%     end

%     f1 = figure(1);
%     set(f1,'WindowStyle','docked');
    f1 = subplot(1,3,1);
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
    f2 = subplot(1,3,2);
    box on;
    hold on;
    plot(t,R,'*b');
    xlabel('Time');
    ylabel('LOS Distance (meters)');

%     f3 = figure(4);
%     set(f3,'WindowStyle','docked');   
    f3 = subplot(1,3,3);
    box on;
    hold on;
    plot(t,a_m,'*r');
    xlabel('Time');
    ylabel('Lateral Acceleration (m/s^{2})');
    
    imgframe = imgframe+1;
    images1(imgframe) = getframe(figHandle);

end

for i = 1:imgframe-1
[im, map] = frame2im(images1(i));
name = ['clos_k10_mT_plot',num2str(i),'.jpg'];
imwrite(im,name,'jpg');
end

filename = 'clos_k10_mT';
save(filename);
movie2avi(images1,[filename '.avi'],'fps',4);
movie2avi(images1,[filename '_medium.avi'],'fps',5);
movie2avi(images1,[filename '_small.avi'],'fps',6);
% movie2avi(images1,[filename '_ffds.avi'],'Compression','FFDS','fps',4);