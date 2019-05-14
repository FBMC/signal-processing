function [ yk,e,weight] = CMA( signal, Lf,delt, p)
% Lf=10;
% delt=0.001;                        %��������Ϊ0.001s
% p = 2;
S_ref_n=signal/max(signal)*2;
yk=zeros(1,length(S_ref_n));
e=zeros(1,length(S_ref_n));

R_1=sum(abs(S_ref_n).^(2*p))/sum(abs(S_ref_n).^p);
weight=zeros(length(S_ref_n),Lf+1);                 % Ȩ�����ӣ�����Ϊһ���źŽ���ͨ��������101��ʱ���ӳٴ��� ��Ȩ�����Ӽ�Ϊ1*101�ľ���
weight(:,Lf/2-1)=1;                         %���51��Ȩ��Ϊ1������Ϊ0����Ϊ�����ֵ
for j=Lf/2+1:length(S_ref_n)-Lf/2
   yk(j)=S_ref_n(j+Lf/2:-1:j-Lf/2)*conj(weight(j,:)');
   e(j)=(abs(yk(j)).^2-R_1)*yk(j);
   weight(j+1,:)=weight(j,:)-delt*e(j)*conj(S_ref_n(j+Lf/2:-1:j-Lf/2));
end


end

