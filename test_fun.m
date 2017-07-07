function [z]= test_fun( in)
%TEST_FUN Summary of this function goes here
%   Detailed explanation goes here
nn=size(in);
x=in(:,1);
nx=nn(1); 
x_avg=mean(x);
flag=0;
sigma=std(x,flag);         %Çó±ê×¼²î
for i=1:nx
    temp=exp(-sqrt(x(i)-x_avg)/2*sigma^2);
    z(i,:)=temp;
end
end

