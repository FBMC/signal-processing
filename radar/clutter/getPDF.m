% �õ�data�ĸ����ܶȺ���
% N:��������ĸ���
% cdf:cumsum(y)
function [x,y]=getPDF(data,N)
maxv=max(data);
minv=min(data);
x=linspace(minv,maxv,N);
y=hist(data,x)/length(data);%�����������ĸ���
% figure
% bar(x,y)%���������ܶȷֲ�ͼ
end

