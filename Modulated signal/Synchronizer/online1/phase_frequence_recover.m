%% �ز�ͬ�������໷����
%*****���㷨�ܹ��Խ��ն��ز����ڵ���ƫ��Ƶƫ���лָ�
%*****ֻ�����һ�����ڲ��������ҵ���ֵλ�ã�����Ҫ�����ֵλ�õ��������֡�
%*****����˵����r�ǽ������У�len�ǽ������еĳ���
function Signal_Recover=phase_frequence_recover(r,len)
%��·�˲�������
C1=0.022013;                                                      %��λ�������� 
C2=0.00024722;                                                  %Ƶ�ʿ������� 
Signal_Recover=zeros(len,1);                                 %���໷�������ȶ��������
NCO_Phase=zeros(len,1);                                      %��������λ
Discriminator_Out=zeros(len,1);
Freq_Control=zeros(len,1);
Phase_Part=zeros(len,1);                                       %���໷��λ
Freq_Part=zeros(len,1);                                         %���໷Ƶ��
for i=2:len
    Signal_Recover(i)=r(i)*exp(-j*mod(NCO_Phase(i-1),2*pi));   %�õ�������������
    I_Recover(i)=real(Signal_Recover(i));                    %��������I·������Ϣ����
    Q_Recover(i)=imag(Signal_Recover(i));                 %��������Q·������Ϣ����
    Discriminator_Out(i)=(sign(I_Recover(i))*Q_Recover(i)-sign(Q_Recover(i))*I_Recover(i))...
                /(sqrt(2)*abs(Signal_Recover(i)));             %��������������о�
    Phase_Part(i)=Discriminator_Out(i)*C1;               %��·�˲�������
    Freq_Control(i)=Phase_Part(i)+Freq_Part(i-1);
    Freq_Part(i)=Discriminator_Out(i)*C2+Freq_Part(i-1);
    NCO_Phase(i)=NCO_Phase(i-1)+Freq_Control(i);  %������λ����
end

