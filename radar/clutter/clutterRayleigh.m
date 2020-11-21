%% �Ӳ�
% Author��LCG  UESTC 2020.11.21
% ref :�״�غ��Ӳ������뽨ģ��p256
% ע�⣺���ۺ�ʵ��ֵ���в��ģ�����������ֵ��ʵ�ʵ�����ɢ�ģ�����pdf���Ⱥ͹�ʽʵ����Ĳ�ͬ

clc;
clear all
close all
%% Gauss
L=100000;
mu=0;
sigma=2;
data=mu+sigma*randn(1,L);
[x,y]=getPDF(data,200);
pdf_v = normpdf(x,mu,sigma);
cdf_v=1-cumsum(pdf_v);
figure
subplot(221);bar(x,y);title('pdf by data')
subplot(222);plot(x,pdf_v);title('pdf by formula')
subplot(223);semilogy(x,cdf_v);title('cdf');ylabel('1-CDF')
subplot(224);plot(data);title('data')
suptitle(['Gauss distribution: ','\mu=',num2str(mu),' \sigma=',num2str(sigma)])
%% Rayleigh
% f(x)=2x/a^2 * exp(-(x/a)^2) x>=0
L=10000;
sigma=2; % �����ֲ�����sigma
u=rand(1,L); % ������0-1����λ�����ź�
data=sqrt(2*log2(1./u))*sigma; % ������ȷֲ��뵥λ���ȷֲ�֮��Ĺ�ϵ
[x,y]=getPDF(data,200);
pdf_v = pdf('Rayleigh',x,sigma);
cdf_v=1-cdf('Rayleigh',x,sigma);
figure
subplot(221);bar(x,y);title('pdf by data')
subplot(222);plot(x,pdf_v);title('pdf by formula')
subplot(223);semilogy(x,cdf_v);title('cdf');ylabel('1-CDF')
subplot(224);plot(data);title('data')
suptitle(['Gauss distribution: ','\mu=',num2str(mu),' \sigma=',num2str(sigma)])
