%% ���������
% s_ref:������ź�,������
% s_echo:�ز�,������
% X���ο��źŷֿ鳤��
% L:�ز��źŷֿ�ΪX+L
% R_fftn,D_fftn������ά��������άfft�ĵ���������Ϊ0ʱ���źų�����
% fs��������
% type�������������ں�����չ 0-Ĭ��
function [Range,doppler,RD]=RangeDoppler(s_ref,s_echo,X,L,R_fftn,D_fftn,fs,type)
tic
c=3e8;
if size(s_ref,2)==1
    s_ref=s_ref.';
end
if size(s_echo,2)==1
    s_echo=s_echo.';
end

Dim1=floor(length(s_ref)/X);
Dim2=floor((length(s_echo)-L)/X);
Dim=min([Dim1,Dim2]);

if R_fftn<=0
    R_fftn=X+L;
end
if D_fftn<=0
    D_fftn=Dim;
end

FastTimeDim=zeros(Dim,R_fftn);
for ii=1:Dim
    refBlock=s_ref((ii-1)*X+1:ii*X);
    echoBlock=s_echo((ii-1)*X+1:ii*X+L);
    FastTimeDim(ii,:)=fft(refBlock,R_fftn).*conj(fft(echoBlock,R_fftn));
    FastTimeDim(ii,:)=(ifft(FastTimeDim(ii,:)));%����fftshit�������0��ʼ
end
SlowTimeDim=fftshift(fft(FastTimeDim,D_fftn,1),1);%��fftshift���ٶȴӸ�����Сֵ���������ֵ
RD=SlowTimeDim;
time=toc;
%% �����Ϣ
disp('********************')
disp(['����ά����',num2str(size(RD))])
disp(['�����ʱ��',num2str(time)])
doppler=(-D_fftn/2:D_fftn/2-1)*(fs/X/D_fftn);%���ɼ�������Ϊfs/(2*X),XӦ��>=fs*(lambda/(4Vmax))
disp(['���ɼ������գ�',num2str(fs/(2*X))])
Range=(0:R_fftn-1)*(1/fs)*c;%�������1/fs,����Ϊ1/fs*c
disp(['���ɼ�����Ϊ��',num2str(R_fftn*c/fs)])
Range=Range(end:-1:1);
% figure
% mesh(Range,doppler,10*(abs(SlowTimeDim)))%/max(max(abs(SlowTimeDim)))
% title('���������')

end