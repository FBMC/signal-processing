%% ��ʱͬ����Gardner�㷨��
%*****���㷨��Gardner�����н��ܵ��㷨Ҫ��һЩ��������ƻ�·�˲���������
%*****ֻ�����һ�����ڲ��������ҵ���ֵλ�ã�����Ҫ�����ֵλ�õ��������֡�
%*****����˵����r_low�ǽ������У�nsamp��ϵͳ�Ĺ������ʣ�start��ʱƫ
function r_lowsamp=Gardner_timing(r_low,nsamp,start)
% ����������ֵ�˲���ϵ��
C_2 = inline('(1/6)*u^3-(1/6)*u');
C_1 = inline('(-1/2)*u^3+(1/2)*u^2+u');
C0  = inline('(1/2)*u^3-u^2-(1/2)*u+1');
C1  = inline('(-1/6)*u^3+(1/2)*u^2-(1/3)*u');
Gain=0.25;

num=1;
time_error=0;                                                       %��ʱ���
inter_pos=start+nsamp;                                        %��ֵλ��
ted_data1=r_low(start+1);                                     %��ʱ���������
ted_data2=r_low(start+nsamp/2);
while(inter_pos<length(r_low)-3*nsamp-start)
%ǰ�벿�ֲ�ֵ 
    mk=round(inter_pos);                                       % ��������
    uk=inter_pos-mk;                                            % С������
    fraction(num)=uk;
    inter_data=C_2(uk)*r_low(mk+3)+C_1(uk)*r_low(mk+2)+C0(uk)*r_low(mk+1)+C1(uk)*r_low(mk);%ǰ���ֵ
    r_lowsamp(num)=inter_data;
    ted_data3=inter_data;
    inter_pos=inter_pos+nsamp/2+time_error;
    TED=sign(real(ted_data1-ted_data3))*sign(real(ted_data2));%һ���������ֵ����
    time_error=TED*Gain;                                       %��ʱ���
    ted_out(num)=time_error;
%��벿�ֲ�ֵ
    mk=round(inter_pos);
    uk=inter_pos-mk;
    inter_data=C_2(uk)*r_low(mk+3)+C_1(uk)*r_low(mk+2)+C0(uk)*r_low(mk+1)+C1(uk)*r_low(mk);%�����ֵ
    inter_pos=inter_pos+nsamp/2+time_error;
    ted_data1=ted_data3;
    ted_data2=inter_data;  
    num=num+1;
end 
%figure
%plot(fraction(1:100))
 %ylim([-0.5 0.5]);