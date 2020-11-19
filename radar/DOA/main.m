%% ���з���ͼ
% ref���ִ������źŴ�����������p204
% author��lcg UESTC 20201113
% �����˲��ķ���ͼ(Ҳ�Ʋ���ͼ)Ϊ����ź��������źŷ���֮��
clc;clear all;close all
%% parameter
j=sqrt(-1);
theta=-90:0.01:90;
theta=theta/180*pi;
theta0=10/180*pi;
N=16;% ��Ԫ����
lambda=3e8/600e6;
d=lambda/2;%��Ԫ���

%% beampattern
F=sin(N*pi*d/lambda*(sin(theta)-sin(theta0)))./sin(pi*d/lambda*(sin(theta)-sin(theta0)));
F=abs(F)/max(abs(F));
figure
plot(theta*180/pi,20*log10(F))%�����ǳ�20
xlabel('�ռ�Ƕ�/ ( {\circ} )')
ylabel('��һ������ͼ/dB')
title('��Ԫ���\lambda /2��16��Ԫ����������ͼ')
axis([-100 100 -50 0])


% �������������
BW0=2*asin(lambda/(N*d)+sin(theta0));
disp(['�������������',num2str(BW0*180/pi)])


% 3dB
theta3dB=50.8*lambda/(N*d);
disp(['3dB������',num2str(theta3dB)])



%% ��ʽδ����汾��F=|w����{H}a(theta)|,�ɸ���wʵ�ּӴ�
phi=2*pi*d*sin(theta)/lambda;
phi0=2*pi*d*sin(theta0)/lambda;
a=exp(-j*(0:N-1)'*phi);
w=exp(-j*(0:N-1)'*phi0);
% w = fir1(15,0.01,'low')';
% figure;plot(abs(w))
F=abs(w'*a);
F=abs(F)/max(abs(F));
figure
plot(theta*180/pi,20*log10(F))%�����ǳ�20
xlabel('�ռ�Ƕ�/ ( {\circ} )')
ylabel('��һ������ͼ/dB')
title('��Ԫ���\lambda /2��16��Ԫ����������ͼ')
axis([-100 100 -50 0])


%% ���ھ�������ķ���ͼ���Լ򻯳�FFT����ʽ��Ҳ������fft�� fft(w),������õ�ͼ�е㲻һ������֪��ô����
phi=2*pi*d*sin(theta)/lambda;
phi0=2*pi*d*sin(theta0)/lambda;
w=exp(-j*(0:N-1)'*phi0);
F=abs(fftshift(fft(conj(w),length(theta))));%Ӧ����w�Ĺ��
F=abs(F)/max(abs(F));
figure
plot(theta*180/pi,20*log10(F))%�����ǳ�20
xlabel('�ռ�Ƕ�/ ( {\circ} )')
ylabel('��һ������ͼ/dB')
title('��Ԫ���\lambda /2��16��Ԫ����������ͼ')
axis([-100 100 -50 0])


