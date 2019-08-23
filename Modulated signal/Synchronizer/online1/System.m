%% ***************����ͨ��ϵͳ****************************%
%��ͨ��ϵͳ�ܹ�ʵ�ּ򵥵�ͨ�Ź��̡�ϵͳ����ӳ�䡢�����˲�����Ƶ�������ƥ���˲���ģ�顣
%ϵͳ������   �ز�Ƶ�ʣ�2000 Hz
%                  �������ʣ�1000 B
%                  ���Ʒ�ʽ��QPSK
%                  �������ʣ�16000 Hz  
%                  �������ʹ�ø����������˲���������Ϊ8 ��16 
%                  �������ӣ�0.1,0.25,0.5

%���ߣ��ſ���     ʱ�䣺2011��11��8��

%% *****************************************************%

clear all;
close all;
clc
%% ��������
    fc = 2000;                                                        %��ƵΪ2000Hz
    R = 1000;                                                         %��Ϣ����1000B
    Rs = 16000;                                                      %��������16kHz
    nsamp=Rs/R;                                                    %����������
    n = 1000;                                                       %��������Ϣ���и���
    foff =10;                                                          %Ƶƫ
    poff =10;                                                           %��ƫ
    toff =10;                                                          %ʱƫ
    %���������������
    delay = 8;                                                         %��ʱ
    rolloff = 0.5;                                                     %����ϵ��
    snr = 20;                                                          %�����/dB   
%% �����
%%�����ź�
    %info = randint(n,1);                                           %�����������
    info = randi([0,1],n,1);                                           %�����������
    train=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ];              %����ѵ������
    info1=[train info'];
    info1 = reshape(info1,2,[]);                                %���д����任
    info_I = info1(1,:);                                             %I·��Ϣ����
    info_Q= info1(2,:);                                            %Q·��Ϣ����

%%ӳ��
    for i=1:length(info_I)
        if info_I(i)==0                                               %����Ϣ����Ϊ0����ӳ��Ϊ��1
            info_I(i)=-1;
        end
        if info_Q(i)==0 
           info_Q(i)=-1;
        end
    end

    symbol = info_I+j*info_Q;                                  %��Ϣ���еĽ�����ʽ

%%�������
    rrcfilter = rcosine(R,Rs,'fir/sqrt',rolloff,delay);      %����һ����������������
% ������ͼ
%figure
%impz(rrcfilter,1);
%title('��������')

%�ò����������ӳ������Ϣ�����������
    I = rcosflt(info_I,R,Rs,'filter',rrcfilter);                  %I·�����ź�
    Q = rcosflt(info_Q,R,Rs,'filter',rrcfilter);               %Q·�����ź�

%%����
%�����ز��ź�
    t = 0:1/Rs:10;
    carrier1 = sqrt(2)*cos(2*pi*fc*t);                        %������·�������ز��ź�
    carrier2 = -sqrt(2)*sin(2*pi*fc*t);
%��������һ·�ز��ź�
%figure
%plot(carrier2(1:100))
%��Ƶ
    I_passband = I'.*carrier1(1:length(I));                  %I·��ͨ�ź�
    Q_passband= Q'.*carrier2(1:length(Q));               %Q·��ͨ�ź�
    s = I_passband+Q_passband;  %���������ź�
%�������źŵĹ�����
%S = spectrum.periodogram;
%psd(S,s,'Fs',Rs)

%% ���ྶ�ŵ�
chan=[1 0.5 0.3];                                                  %����ISI�ŵ�
chanup=upsample(chan,Rs/R);
r_inter=filter(chanup,1,s);
    
%% ��AWGN�ŵ�
    r = awgn(s,snr,'measured');                               %������
    %r = awgn(r_inter,snr,'measured'); 
    %r=s;

%% ���ն�
%��������ز�
    t = 0:1/Rs:10;
    rcarrier1 = sqrt(2)*cos(2*pi*(fc+foff)*t+poff);     %������·�������ز��ź�
    rcarrier2 = -sqrt(2)*sin(2*pi*(fc+foff)*t+poff);
%%���
    rI=r.*rcarrier1(1:length(r));                                  
    rQ=r.*rcarrier2(1:length(r));
%%ƥ���˲�
    rI_low = rcosflt(rI,Rs,Rs,'filter',rrcfilter);               %I·ƥ���˲��ź�
    rQ_low = rcosflt(rQ,Rs,Rs,'filter',rrcfilter);            %Qƥ���˲�·�ź�
%����I·ƥ���˲�����ź�
%figure
%plot(rI_low)
r_low = rI_low+j*rQ_low;
%�۲���ͼ
%eyediagram(r_low(257:length(r_low)-255-16),2*Rs/R);
%title('���ն���ͼ')

    rI_bit = [];                                                         %����I·�о���Ϣ����
    rQ_bit = [];                                                        %����Q·�о���Ϣ����
    y1 = [];
    y2 = [];
for i=toff+1:nsamp:(length(rI_low)-4*delay*nsamp+toff-nsamp+1)
     rI_bit((i-1-toff)/nsamp+1)=rI_low(i);
     rQ_bit((i-1-toff)/nsamp+1)=rQ_low(i);
end
    ysymbol =  rI_bit+j*rQ_bit;                                %δͬ���Ľ����ź�
%�۲���ն˵�����ͼ
constell_uti=scatterplot(ysymbol,1,0,'b.');               %����δ��ʱ�ָ�������ͼ
hold on;
scatterplot(symbol,1,0,'r*',constell_uti)                   %������������ͼ
title('���ն�����ͼ')
%rI_lowsamp = Gardner(rI_low,nsamp,toff);
%rQ_lowsamp = Gardner(rQ_low,nsamp,toff);
%r_lowsamp=rI_lowsamp+j*rQ_lowsamp;
r_low=phase_frequence_recover(r_low,length(r_low));%��Ƶƫ��ƫ����У��
r_lowsamp = Gardner_timing(r_low,nsamp,toff);     %��Gardner�㷨���ж�ʱ�ָ�
constell_ti=scatterplot(r_lowsamp,1,0,'b.');             %������ʱ�ָ��������ͼ
hold on;
scatterplot(symbol,1,0,'r*',constell_ti)                     %������������ͼ
title('ͬ���������ͼ')
%�����о�
    for i=1:length(r_lowsamp)                                 %ȷ���о�ʱ�̽����о����о�����Ϊ0���źŷ��ȴ���0����Ϊ1��������Ϊ0
        if  real(r_lowsamp(i))>0
            y1(i)=1;
        else
            y1(i)=0;
        end
        if  imag(r_lowsamp(i))>0
            y2(i)=1;
        else
            y2(i)=0;
        end
    end 
    
%���д����仯
     y = [y1;y2];                                                     %�����任
    recover_info = reshape(y,[],1);                           %���ն��������     
%% ����������
    location=conv(recover_info,train);
   % figure
    %plot(location)
    [largest,head]=max(location(1:end-n-length(train)));
    recover_info=recover_info(head+1:head+n);
    count=0;
    error = info-recover_info;
    for i=1:n
        if error(i)~=0
            count=count+1;
        end
    end
    snr                                                                   %�����
    BER=count/n                                                    %���������    
    


