%% �����γ� ��ǿĳ�����ź����� 
% LCG UESTC 2020.11.24
% fft ��ռ�Ƶ���ף��Ƕ�Ҳ��Ƶ��
%% parameter
clc;clear ;close all
j=sqrt(-1);
L=10000; % snapshot
N=16; %��Ԫ����
K=3;% Ŀ�����
theta=[-10,20,40]/180*pi;
lambda=1;
d=lambda/2;

%% X=AS+No,A:N*k,S:K*L
Amp=[5,5,5]';
f0=[-0.25,0.15,0.25]';
A=exp(-j*(0:N-1)'.*2*pi*d/lambda*sin(theta));
% S=rand(K,L)+rand(K,L)*j;
S=exp(j*2*pi*f0.*(0:L-1));% �̶�Ƶ������
S=Amp.*S;

No=rand(N,L);
X=A*S+No;
X=X.*exp(-j*2*pi*(0:N-1)'*d/lambda*sin(0/180*pi));%ָ��0��
figure
ff=linspace(-0.5,0.5,L);
Sp=abs(fftshift(fft(sum(X,1))));
plot(ff,Sp)
%% FFT �ռ书����
tmp=linspace(-1,1,1024);
doaFFT=abs(fftshift(fft(sum(conj(X),2),length(tmp))));% �������,����,fft
doaFFT=doaFFT/max(doaFFT);
figure
plot(asin(tmp)*180/pi,10*log10(doaFFT))
xlabel('�Ƕ� / (^o)')
title('�źŵĿռ书����')

%% ָ��40�����
j=sqrt(-1);
L=10000; % snapshot
N=16; %��Ԫ����
K=3;% Ŀ�����
theta=[-10,20,40]/180*pi;
lambda=1;
d=lambda/2;

%% X=AS+No,A:N*k,S:K*L
Amp=[5,5,5]';
f0=[-0.25,0.15,0.25]';
A=exp(-j*(0:N-1)'.*2*pi*d/lambda*sin(theta));
% S=rand(K,L)+rand(K,L)*j;
S=exp(j*2*pi*f0.*(0:L-1));% �̶�Ƶ������
S=Amp.*S;

No=rand(N,L);
X=A*S+No;
X=X.*exp(-j*2*pi*(0:N-1)'*d/lambda*sin(40/180*pi));%ָ��4��
figure
ff=linspace(-0.5,0.5,L);
Sp=abs(fftshift(fft(sum(X,1))));
plot(ff,Sp)
%% FFT �ռ书����
tmp=linspace(-1,1,1024);
doaFFT=abs(fftshift(fft(sum(conj(X),2),length(tmp))));% �������,����,fft
doaFFT=doaFFT/max(doaFFT);
figure
plot(asin(tmp)*180/pi,10*log10(doaFFT))
xlabel('�Ƕ� / (^o)')
title('�źŵĿռ书����')
