clc
clear 
close all

filname=["DDC200_20200821145914_ch1.dat"
,"DDC200_20200821145914_ch2.dat"
,"DDC200_20200821145914_ch3.dat"
,"DDC200_20200821145914_ch4.dat"
,"DDC200_20200821145914_ch5.dat"]
path="G:\�����Դ��Ŀ\����20200826\UAV\����\";

j=sqrt(-1);
fs=10e6;
N=5;

%% ��ȡ
datalen=5000000;
IQ=zeros(N,datalen/2);
for ii=1:N
    fid=fopen([char(path),char(filname(ii))],'r');
    dataread=fread(fid,[1,datalen],'short');

    fclose(fid);
    IQ(ii,:)=dataread(1:2:end)+dataread(2:2:end)*j;

end


%% �˲�

%% Ƶ�׷���
% len=length(IQ);
% ff=(-len/2:len/2-1)*(fs/len);
% Spec=abs(fftshift(fft(IQ)))/len;
% figure
% plot(ff,10*log10(Spec))
% title('�ź�Ƶ��')


X=IQ(:,100000:200000)/max(max(abs(IQ)));
K=2;
d=1;
lambda=4;
[theta_x,P_music]=DOAByMUSIC(X,K,d,lambda,0.1);
figure
plot(theta_x,10*log10(abs(P_music)))
xlabel('�Ƕ� / (^o)')
title('��������MUSIC')

tmp=linspace(-1,1,1024);
doaFFT=abs(fftshift(fft(sum(conj(X),2),length(tmp))));
doaFFT=doaFFT/max(doaFFT);
figure
plot(asin(tmp)*180/pi,10*log10(doaFFT))
xlabel('�Ƕ� / (^o)')
title('�źŵĿռ书����')