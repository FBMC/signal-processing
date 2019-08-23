% ����4����ԭʼ����������ͼ�ı���ӳ����̣�
% ���16QAM�źŵĵ��ƽ����
% �����źŷ������� ps ��1Mbps��
% �����˲����Ĺ������� a=0.8��
% �ز��ź�Ƶ��fc=2MHz ��
% ����Ƶ�� Fs=8MHz ��
% ����16QAM�źŵ�Ƶ�׼�ʱ���Σ�
% ������ɽ���������������̣�
% ���ƽ��ǰ��Ļ����ź�ʱ���Σ�
% ��ԭʼ�������ݡ�QAM�ѵ����ݡ��˲���ϵ��д����Ӧ���ı��ļ��С�
clc;
clear
close all;
 
ps=1*10^6;   %������Ϊ1MHz
a=0.8;       %�����˲���ϵ��
Fs=8*10^6;   %��������
fc=2*10^6;   %�ز�Ƶ��
N=4000;      %�������ݵĳ���
 
t=0:1/Fs:(N*Fs/ps-1)/Fs;%��������ΪN,Ƶ��Ϊfs��ʱ������
s=randi([0,16],1,N);       %�������16����������Ϊԭʼ����
Bs=dec2bin(s,4);         %��ʮ��������ת����4���صĶ���������
 
%��Bs�ĸ�2���ؽ��в�ֱ���
%ȡ��2���طֱ�����A��B������
A=s>7;
B=(s-A*8)>3;
%��ֱ��������ݴ����C��D��
C=zeros(N,1);D=zeros(N,1);
for i=2:N
    C(i)=mod(((~mod(A(i)+B(i),2))&mod(A(i)+C(i-1),2)) + (mod(A(i)+B(i),2)&mod(A(i)+D(i-1),2)),2);
    D(i)=mod(((~mod(A(i)+B(i),2))&mod(B(i)+D(i-1),2)) + (mod(A(i)+B(i),2)&mod(B(i)+C(i-1),2)),2);
end
%��ֱ����ĸ�2����������ԭ���ݵ�2���غϳ�ӳ��ǰ������DBs
DBs=C*8+D*4+s-A*8-B*4;
 
 
%��ɵ���ǰ������ͬ��֧·����ӳ��
I=zeros(1,N);Q=zeros(1,N);
for i=1:N
    switch DBs(i)
        case 0, I(i)=3; Q(i)=3;
        case 1, I(i)=1; Q(i)=3;
        case 2, I(i)=3; Q(i)=1;
        case 3, I(i)=1; Q(i)=1;
        case 4, I(i)=-3;Q(i)=3;
        case 5, I(i)=-3;Q(i)=1;
        case 6, I(i)=-1;Q(i)=3;
        case 7, I(i)=-1;Q(i)=1;
        case 8, I(i)=3; Q(i)=-3;
        case 9, I(i)=3; Q(i)=-1;
        case 10,I(i)=1; Q(i)=-3;
        case 11,I(i)=1; Q(i)=-1;
        case 12,I(i)=-3;Q(i)=-3;
        case 13,I(i)=-1;Q(i)=-3;
        case 14,I(i)=-3;Q(i)=-1;
        otherwise,I(i)=-1;Q(i)=-1;
    end
end
 
%�Ա���������FsƵ�ʲ���
Ads_i=upsample(I,Fs/ps);
Ads_q=upsample(Q,Fs/ps);
 
%������
% SNR=30;
% Ads_i=awgn(Ads_i,SNR);
% Ads_q=awgn(Ads_q,SNR);
  
%���ƽ�����������˲���
n_T=[-2 2];
rate=Fs/ps;
T=1;
Shape_b = rcosfir(a,n_T,rate,T,'sqrt');
%�Բ���������ݽ����������˲�;
rcos_Ads_i=filter(Shape_b,1,Ads_i);
rcos_Ads_q=filter(Shape_b,1,Ads_q);
figure;plot(rcos_Ads_i+rcos_Ads_q*j,'x') 
%����ͬ��������·��Ƶ�ź�
f0_i=cos(2*pi*fc*t);
f0_q=sin(2*pi*fc*t);      
  
%����16QAM�ѵ��ź�
qam16=rcos_Ads_i.*f0_i+rcos_Ads_q.*f0_q;      
figure;
plot(qam16);
srdata = rcos_Ads_i + rcos_Ads_q * 1i;
scatterplot(srdata(length(srdata)*0.9:2:length(srdata)));
 
 
 
%%%%%������������Ե�PSK�������ݡ�%%%
bitstream=randi([0,1],1,N);             
psk2=pskmod(bitstream,2);
Ns=8*N;
xI=zeros(1,Ns);
xQ=zeros(1,Ns);
xI(1:8:8*N)=real(psk2);%8����ֵ
xQ(1:8:8*N)=imag(psk2);
%�ض̺�ĸ�������ƥ���˲���
h1=rcosfir(0.8,[-8,8],4,1,'sqrt');
hw=kaiser(65,3.97);
%hh=h1.*hw.';
hh=h1;
aI1=conv(xI,hh);
bQ1=conv(xQ,hh);
L=length(aI1);
%������������
% aI=[aI1(22:2:L),0,0];%2����ȡ
% bQ=[bQ1(22:2:L),0,0];
%
% scatterplot(psk2(length(psk2)*0.5:length(psk2)));
 
aI=real(srdata(202:2:length(srdata)));%2����ȡ��Ϊ����8����ֵ����2����ȡ��
bQ=imag(srdata(202:2:length(srdata)));
ma=max(abs(aI));mb=max(abs(bQ));
m=max(ma,mb);
aI=aI/m;bQ=bQ/m;
%
N=floor(length(aI)/4);
Ns=4*N;  %�ܵĲ�������
 
bt=0.001;
c2=2^(-14);
c1=2^(-6);
% c1=8/3*bt;
% c2=32/9*bt*bt;
i=3;    %������ʾTs��ʱ�����,ָʾn,n_temp,nco,
 
w=[0.5,zeros(1,N-1)];  %��·�˲�������Ĵ�������ֵ��Ϊ0.5
n=[0.7 zeros(1,Ns-1)]; %NCO�Ĵ�������ֵ��Ϊ0.9
n_temp=[n(1),zeros(1,Ns-1)];
u=[0.6,zeros(1,2*N-1)];%NCO����Ķ�ʱ��������Ĵ�������ֵ��Ϊ0.6
yI=zeros(1,2*N);       %I·�ڲ����������
yQ=zeros(1,2*N);       %Q·�ڲ����������
time_error=zeros(1,N); %Gardner��ȡ��ʱ�����Ĵ���
 
ik=time_error;
qk=time_error;
 
k=1;    %������ʾTiʱ�����,ָʾu,yI,yQ
ms=1;   %����ָʾT��ʱ�����,����ָʾa,b�Լ�w
strobe=zeros(1,Ns);
 
ns=length(aI)-2;
while(i<ns)
    n_temp(i+1)=n(i)-w(ms);
%      n_temp(i+1)=n(i)-0.5;
    if(n_temp(i+1)>0)
        n(i+1)=n_temp(i+1);
    else
        n(i+1)=mod(n_temp(i+1),1);
        %�ڲ��˲���ģ��
        FI1=0.5*aI(i+2)-0.5*aI(i+1)-0.5*aI(i)+0.5*aI(i-1);
        FI2=1.5*aI(i+1)-0.5*aI(i+2)-0.5*aI(i)-0.5*aI(i-1);
        FI3=aI(i);
        yI(k)=(FI1*u(k)+FI2)*u(k)+FI3;
        FQ1=0.5*bQ(i+2)-0.5*bQ(i+1)-0.5*bQ(i)+0.5*bQ(i-1);
        FQ2=1.5*bQ(i+1)-0.5*bQ(i+2)-0.5*bQ(i)-0.5*bQ(i-1);
        FQ3=bQ(i);
        yQ(k)=(FQ1*u(k)+FQ2)*u(k)+FQ3;
        strobe(k)=mod(k,2);
        %ʱ�������ȡģ�飬���õ���Gardner�㷨
        if(strobe(k)==0)
            %ȡ����ֵ����
            ik(ms)=yI(k);
            qk(ms)=yQ(k);
             
            %ÿ�����ݷ��ż���һ��ʱ�����
            if(k>2)
               Ia=(yI(k)+yI(k-2))/2;
               Qa=(yQ(k)+yQ(k-2))/2;
               time_error(ms)=[yI(k-1)-Ia ]  *(yI(k)-yI(k-2))+[yQ(k-1)-Qa]  *(yQ(k)-yQ(k-2));
            else
                time_error(ms)=(yI(k-1)*yI(k)+yQ(k-1)*yQ(k));
            end
            %��·�˲���,ÿ�����ݷ��ż���һ�λ�·�˲������
            if(ms>1)
                w(ms+1)=w(ms)+c1*(time_error(ms)-time_error(ms-1))+c2*time_error(ms-1);
                %w(ms+1)=w(ms)+c1*(time_error(ms)-time_error(ms-1));
            else
                w(ms+1)=w(ms)+c1*time_error(ms)+c2*time_error(ms);
            end
            ms=ms+1;
        end
          k=k+1;
%         u(k)=n(i)/w(ms);
          u(k) = 0.5* n(i);%%��������
    end
    i=i+1;
end
%
figure;
subplot(311);plot(u);xlabel('�������');ylabel('�������');
subplot(312);plot(time_error);xlabel('�������');ylabel('��ʱ���');
subplot(313);plot(w);xlabel('�������');ylabel('��·�˲������');
%
%
%
iq=ik+qk*sqrt(-1);
L=length(iq)
% off=6;
scatterplot(iq(1:end));
scatterplot(iq(L*0.5:end));
scatterplot(iq(L*0.9:end));