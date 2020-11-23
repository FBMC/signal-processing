%% MUSIC ����
% LCG UESTC 2020.11.23
%% parameter
clc;clear ;close all
j=sqrt(-1);
L=1000; % snapshot
N=16; %��Ԫ����
K=3;% Ŀ�����
theta=[-30,30,40]/180*pi;
lambda=1;
d=lambda/2;

%% X=AS+No,A:N*k,S:K*L
Amp=[1,2,4]';
A=exp(-j*(0:N-1)'.*2*pi*d/lambda*sin(theta));
S=rand(K,L)+rand(K,L)*j;
S=Amp.*S;

No=rand(N,L);
X=A*S+No;
% X=X.*exp(-j*2*pi*(0:N-1)'*d/lambda*sin(-30/180*pi));

[theta_x,P_music]=DOAByMUSIC(X,K,d,lambda,0.1);
figure
plot(theta_x,abs(P_music))
xlabel('�Ƕ� / (^o)')
title('��������MUSIC')