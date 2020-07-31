%% ������˫�����״�ľ�������գ������ź�Ϊ���Ե�Ƶ�����źţ���Ŀ��
%% Ƶ����
clc
clear all
close all
%%
j=sqrt(-1);
c=3e8;
R=152000; %Ŀ�����
v=50;%Ŀ���ٶ�
vmax=400;%������ٶ�
lambda=c/800e6;%�ź���Ƶ����
fd=2*v/lambda;%Ŀ�������
disp(['���۶�����Ƶ��',num2str(fd)])
% Fdmax=2*vmax/lambda;%���ɼ�������
fs=8e6;
delay=round(R/c*fs);%��Ӧʱ��
Rmin=-1e6;
Rmax=1e6;
len=1e6;%�ź��ܳ�
gamma=1+j;
beta0=0.1+0.1*j;
beta1=0.01+0.01*j;
% beta1=0.1;
t=(0:len-1)/fs;
copy=100;%�����ظ��ĸ���
copy10=10*copy;
s_ref=gamma*sum(exp(j*2*pi*t(1:len/copy10).*(0:fs/8/(len/copy10):fs/8-fs/8/(len/copy10))),1);

s_ref=[s_ref,zeros(1,9*size(s_ref,2))];%��0
s_ref=repmat(s_ref,1,copy);
% s_ref=[zeros(1,100),s_ref(1:end-100)];
s_ref=awgn(s_ref,10,'measured');
PRF=fs/(len/copy);
disp(['PRF��',num2str(PRF)]);
disp(['R_un��',num2str(c/PRF)]);%˫վ��Ӧ�ò��ó�2
figure
plot(abs(fftshift(fft(s_ref))))
figure
plot(real(s_ref))
% len=10*len;
% t=(0:len-1)/fs;

s_echo=beta0*s_ref+beta1*[zeros(1,delay),s_ref(1:end-delay)].*exp(-j*2*pi*fd*t);%�ز��ź�

% Lsur=floor(fs/(2*Fdmax));
Lsur=len/copy;%��ʱ��ά�ֿ鳤��,��ÿ��PRI�ֿ�,�������Գ�2���2
Dim=floor(len/Lsur);%
FastTimeDim=zeros(Dim,Lsur);

% [Range,doppler,RD]=RangeDoppler(s_ref,s_echo,Lsur,0,0,0,fs,0);
% [Range,doppler,RD]=RangeDoppler(s_ref,s_echo,Lsur,10000,0,0,fs,0);
[Range,doppler,RD]=RangeDoppler(s_ref,s_echo,Lsur,0,20480,512,fs,0);
for ii=1:Dim
    FastTimeDim(ii,:)=fft(s_ref((ii-1)*Lsur+1:ii*Lsur)).*conj(fft(s_echo((ii-1)*Lsur+1:ii*Lsur)));
    FastTimeDim(ii,:)=(ifft(FastTimeDim(ii,:)));%����fftshit�������0��ʼ
end
SlowTimeDim=fftshift(fft(FastTimeDim,[],1),1);%��fftshift���ٶȴӸ�����Сֵ���������ֵ
doppler=(-Dim/2:Dim/2-1)*(fs/Lsur/Dim);%���ɼ�������Ϊfs/(2*Lsur),LsurӦ��>=fs*(lambda/(4Vmax))
disp(['���ɼ������գ�',num2str(fs/(2*Lsur))])
Range=(0:Lsur-1)*(1/fs)*c;%�������1/fs,����Ϊ1/fs*c
disp(['���ɼ�����Ϊ��',num2str(Lsur*c/fs)])
Range=Range(end:-1:1);
figure
mesh(Range,doppler,10*log10(abs(SlowTimeDim)/max(max(abs(SlowTimeDim)))))
title('���������')
% mesh(abs(SlowTimeDim))
ylabel('Hz')
xlabel('m')


figure
plot((-len+1:len-1),(abs(xcorr(s_ref,s_echo)/(2*len))))
title('�����')
figure
correlation=fftshift(ifft(fft(s_ref).*conj(fft(s_echo))));
plot(abs(correlation))
title('Ƶ��ѹ��')