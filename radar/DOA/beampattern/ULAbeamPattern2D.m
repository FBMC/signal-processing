%% ���з���ͼ
% ref���״��ʱ����Ӧ����JR�����İ� p48
% author��lcg UESTC 20201119
% 2ά����ͼ���Ƕ�-�����յ���ʸ������ͼ
clc;clear all;close all
%% parameter
j=sqrt(-1);
theta0=20/180*pi;%ָ��
N=16;% ��Ԫ����
M=12;
lambda=3e8/600e6;
d=lambda/2;%��Ԫ���
v=100;%�ٶ�
T=1e-8;%PRI
beta=2*v*T/d;
% beta=1;
%% ���ھ�������ķ���ͼ���Լ򻯳�FFT����ʽ��Ҳ������fft�� 
thetai=d/lambda*sin(theta0);
fdi=beta*thetai;
fdi=0.25;
ai=exp(j*2*pi*(0:N-1)'*thetai);
bi=exp(j*2*pi*(0:M-1)'*fdi);
vi = kron(bi,ai);
vi2=reshape(vi ,N,M);% ע��N��M��Ҫ�㷴��
F=abs(fftshift(fft2(vi2,1024,1024)));
F=abs(F)/max(max(abs(F)));
F=20*log10(F);

%% plot
theta=asin(linspace(-1,1,1024));
fd=linspace(-0.5,0.5,1024);
figure
mesh(fd,theta/pi*180,F)
xlabel('��һ��Ƶ��')
ylabel('�Ƕ�')
colormap(colorcube)
axis([-0.5 0.5 -100 100 -50 0])
figure
imagesc(fd,theta/pi*180,F)%�������������theta��׼
colormap(colorcube)