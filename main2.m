clc;
%clear;
%load('matlab2.mat');
global Train_data  Validate_data  Test_data
Train_data=T_data;
Validate_data=V_data;
Test_data=TT_data;
clear T_data
clear V_data
clear TT_data
global Y VY TY
[Y,VY,TY]=ELM_Kernel();
Alf=0.03717;
Bta=0.13264;
 lmd=2;
 eta=500;
 mu=0.7;
train_data=Train_data;
T=train_data(:,1)';
clear train_data;                                   %   Release raw training data array
%%%%%%%%%%% Load vallidating dataset
validate_data=Validate_data;
V.T=validate_data(:,1)';
clear validate_data;                                    %   Release raw validate data array
%%%%%%%%%%% Load testing dataset
test_data=Test_data;
TV.T=test_data(:,1)';
clear test_data;       
[~, NumberofTrainingData]=size(Y);
[~, NumberofValidatingData]=size(VY);
[~, NumberofTestingData]=size(TY);
U=Y*(1+Alf);
L=Y*(1-Bta);
K=zeros(NumberofTrainingData,1);
SMWP=zeros(NumberofTrainingData,1);
Apcl=zeros(NumberofTrainingData,1);
for i=1:NumberofTrainingData
    if T(i)>=L(i) && T(i)<=U(i)
        K(i)=1;
    end
    if T(i)>U(i)
        Apcl(i)=(T(i)-U(i))/(U(i)-L(i));
    end
    if T(i)<L(i)
        Apcl(i)=(L(i)-T(i))/(U(i)-L(i));
    end
    SMWP(i)=(U(i)-L(i))/(max(T)-min(T));
end
KP=sum(K)/NumberofTrainingData
MWP=sum(SMWP)/NumberofTrainingData
AD=sum(Apcl)/NumberofTrainingData
PISI=(1-(1+lmd*AD)*MWP*(KP-mu)*(1+exp(-eta*(KP-mu))))
if PISI<0
    PISI=0;
end
Result=1-PISI

%使用验证集事后评估Alf和Bta
VU=VY*(1+Alf);
VL=VY*(1-Bta);
VK=zeros(NumberofValidatingData,1);
VSMWP=zeros(NumberofValidatingData,1);
VApcl=zeros(NumberofValidatingData,1);
for i=1:NumberofValidatingData
    if V.T(i)>=VL(i) && V.T(i)<=VU(i)
        VK(i)=1;
    end
    if V.T(i)>VU(i)
        VApcl(i)=(V.T(i)-VU(i))/(VU(i)-VL(i));
    end
    if V.T(i)<VL(i)
        VApcl(i)=(VL(i)-V.T(i))/(VU(i)-VL(i));
    end
    VSMWP(i)=(VU(i)-VL(i))/(max(V.T)-min(V.T));
end
VKP=sum(VK)/NumberofValidatingData
VMWP=sum(VSMWP)/NumberofValidatingData
VAD=sum(VApcl)/(NumberofValidatingData)
VPISI=(1-(1+lmd*VAD)*VMWP*(VKP-mu)*(1+exp(-eta*(VKP-mu))))
%VPISI=lmd*VAD+lmd*VMWP+lmd*VKP;
if VPISI<0
    VPISI=0;
end
VResult=1-VPISI
%使用测试集评估Alf和Bta
TU=TY*(1+Alf);
TL=TY*(1-Bta);
TK=zeros(NumberofTestingData,1);
TSMWP=zeros(NumberofTestingData,1);
TApcl=zeros(NumberofTestingData,1);
for i=1:NumberofTestingData
    if TV.T(i)>=TL(i) && TV.T(i)<=TU(i)
        TK(i)=1;
    end
    if TV.T(i)>TU(i)
        TApcl(i)=(TV.T(i)-TU(i))/(TU(i)-TL(i));
    end
    if TV.T(i)<TL(i)
        TApcl(i)=(TL(i)-TV.T(i))/(TU(i)-TL(i));
    end
    TSMWP(i)=(TU(i)-TL(i))/(max(TV.T)-min(TV.T));
end
TKP=sum(TK)/NumberofTestingData
TMWP=sum(TSMWP)/NumberofTestingData
TAD=sum(TApcl)/(NumberofTestingData)
TPISI=(1-(1+lmd*TAD)*TMWP*(TKP-mu)*(1+exp(-eta*(TKP-mu))))
%VPISI=lmd*VAD+lmd*VMWP+lmd*VKP;
if TPISI<0
    TPISI=0;
end
TResult=1-TPISI

subplot(3,1,1)
plot(T,'r-','linewidth',4);
hold on
plot(Y,'-','linewidth',4);
plot(U,'g--','linewidth',4);
plot(L,'y:','linewidth',4);
subplot(3,1,2)
plot(V.T,'r-','linewidth',4);
hold on
plot(VY,'-','linewidth',4);
plot(VU,'g--','linewidth',4);
plot(VL,'y:','linewidth',4);
subplot(3,1,3)
plot(TV.T,'r-','linewidth',4);
hold on
plot(TY,'-','linewidth',4);
plot(TU,'g--','linewidth',4);
plot(TL,'y:','linewidth',4);

