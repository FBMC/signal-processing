%% MUSIC �㷨
%% LCG UESTC 2020.11.23
% X��N*L;N:��Ԫ������L�����ĸ���
% d: ��Ԫ��࣬lambda������
% delta_theta: �׵ĺ���������λ���Ƕ�
function [theta_x,P_music]=DOAByMUSIC(X,K,d,lambda,delta_theta)
L=size(X,2);
N=size(X,1);
j=sqrt(-1);
R=X*X'/L;
[EV,D]=eig(R);%
EVA=diag(D).';
[~,I]=sort(EVA);%������ֵ����
EV=fliplr(EV(:,I));% ��Ӧ����ʸ������
En=EV(:,K+1:end); 
theta_x=-90:delta_theta:90;
P_music=zeros(1,length(theta_x));
for ii=1:length(theta_x)
    theta_i=theta_x(ii);
    a=exp(-j*(0:N-1)'*2*pi*d/lambda*sin(theta_i/180*pi));
    P_music(ii)=1/(a'*(En*En')*a);
end

end