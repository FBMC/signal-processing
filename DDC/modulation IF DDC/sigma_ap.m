%�����źŶ������ķ�����˲ʱ��λ��������ֵ�ķ��page 261,(5-286)
%This code is unfinished, and more precise carrier frequency needs to be estimated later.
% a_t is threshold
function y=sigma_ap(a,a_t,fs,fc,mode)
if mode==1 % IF
    a_h=hilbert(a);
end
if mode==2
    a_h=a;
end
angle_a=angle(a_h);
%fc=carrier_estimate(a,fs);                              %Only when the carrier frequency 
                                                        %estimation is very accurate can 
                                                        %the following algorithm be implemented
%fc=1e4;
angle_a=unwrap(angle_a);
for ii=1:length(angle_a)
  angle_a(ii)=mod(angle_a(ii)-2*pi*fc*ii/fs,2*pi);          %(5-295)
end
angle_a=angle_a-mean(angle_a);

Ns=length(a);
amp_a=sqrt(real(a_h).*real(a_h)+imag(a_h).*imag(a_h));   %Envelope calculation from the Hilbert transform
m_a=mean(amp_a);
a_n=amp_a/m_a;
k=1;
for i=1:Ns
    if(a_n(i)>a_t)
        phi(k)=angle_a(i);
        k=k+1;
    end
end
if(k==1)                                                  % aviod a_t so large that phi without element
    phi=0;
end
sigma_ap=sqrt(mean(phi.*phi)-mean(abs(phi))*mean(abs(phi)));
y=sigma_ap;
end