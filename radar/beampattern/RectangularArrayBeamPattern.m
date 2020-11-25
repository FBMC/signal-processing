%% 
% �������� ����ͼ
% LCG USETC 2020.11.25
% ref����ʱ����Ӧ���� ������ p27
%%
clc;clear;close all
%% parameter
j=sqrt(-1);
M=16;%M��N��
N=16;

lambda=1;
d=lambda/2;

% ��ʽ��
Im=ones(M,1);
In=ones(N,1);
psi=(-90:1:90)/180*pi;% ׶��
phi=(-90:1:90)/180*pi;% ������
psi0=90/180*pi;
phi0=30/180*pi;

F_tx=zeros(length(psi),length(phi));
for ii=1:length(psi)
    for jj=1:length(phi)
        Ftmp=(In.*exp(j*2*pi*d/lambda*(0:N-1)'*(cos(psi(ii))-cos(psi0))))*(Im.'.*exp(j*2*pi*d/lambda*(0:M-1)*(sin(phi(jj))-sin(phi0))));
        F_tx(ii,jj)=sum(sum(Ftmp));
    end
end
F_tx=abs(F_tx)/max(max(abs(F_tx)));
figure
mesh(phi/pi*180,psi/pi*180,F_tx)
ylabel('׶��\psi')
xlabel('������\phi')
zlabel('P/dB')
title('���䷽��ͼ')