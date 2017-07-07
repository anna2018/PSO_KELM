function [TestingAccuracy] = elm_kernel_t(Kernel_para)

% Usage: elm(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
% OR:    [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
%
% Input:
% TrainingData_File           - Filename of training data set
% TestingData_File            - Filename of testing data set
% Elm_Type                    - 0 for regression; 1 for (both binary and multi-classes) classification
% Regularization_coefficient  - Regularization coefficient C
% Kernel_type                 - Type of Kernels:
%                                   'RBF_kernel' for RBF Kernel
%                                   'lin_kernel' for Linear Kernel
%                                   'poly_kernel' for Polynomial Kernel
%                                   'wav_kernel' for Wavelet Kernel
%Kernel_para                  - A number or vector of Kernel Parameters. eg. 1, [0.1,10]...
% Output: 
% TrainingTime                - Time (seconds) spent on training ELM
% TestingTime                 - Time (seconds) spent on predicting ALL testing data
% TrainingAccuracy            - Training accuracy: 
%                               RMSE for regression or correct classification rate for classification
% TestingAccuracy             - Testing accuracy: 
%                               RMSE for regression or correct classification rate for classification
%
% MULTI-CLASSE CLASSIFICATION: NUMBER OF OUTPUT NEURONS WILL BE AUTOMATICALLY SET EQUAL TO NUMBER OF CLASSES
% FOR EXAMPLE, if there are 7 classes in all, there will have 7 output
% neurons; neuron 5 has the highest output means input belongs to 5-th class
%
% Sample1 regression: [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm_kernel('sinc_train', 'sinc_test', 0, 1, ''RBF_kernel',100)
% Sample2 classification: elm_kernel('diabetes_train', 'diabetes_test', 1, 1, 'RBF_kernel',100)
%
    %%%%    Authors:    MR HONG-MING ZHOU AND DR GUANG-BIN HUANG
    %%%%    NANYANG TECHNOLOGICAL UNIVERSITY, SINGAPORE
    %%%%    EMAIL:      EGBHUANG@NTU.EDU.SG; GBHUANG@IEEE.ORG
    %%%%    WEBSITE:    http://www.ntu.edu.sg/eee/icis/cv/egbhuang.htm
    %%%%    DATE:       MARCH 2012

%%%%%%%%%%% Macro definition
Regularization_coefficient=10;
 Kernel_type='lin';
 global Train_data Validate_data Test_data
train_data=Train_data;
T=train_data(:,end)';
P=train_data(:,1:end-1)';
clear train_data;                                   %   Release raw training data array
%%%%%%%%%%% Load vallidating dataset
validate_data=Validate_data;
V.T=validate_data(:,size(validate_data,2))';
V.P=validate_data(:,1:size(validate_data,2)-1)';
clear validate_data;                                    %   Release raw validate data array
%%%%%%%%%%% Load testing dataset
test_data=Test_data;
TV.T=test_data(:,size(test_data,2))';
TV.P=test_data(:,1:size(test_data,2)-1)';
clear test_data;       

C = Regularization_coefficient;
NumberofTrainingData=size(P,2);
NumberofValidatingData=size(V.P,2);
NumberofTestingData=size(TV.P,2);

%%%%%%%%%%% Training Phase %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
n = size(T,2);

Omega_train = kernel_matrix(P',Kernel_type, Kernel_para);
OutputWeight=((Omega_train+speye(n)/C)\(T')); 
TrainingTime=toc;

%%%%%%%%%%% Calculate the training output
Y=(Omega_train * OutputWeight)';                             %   Y: the actual output of the training data
%%%%%%%%%%% Calculate the output of validating input
tic;
Omega_validate = kernel_matrix(P',Kernel_type, Kernel_para,V.P');
VY=(Omega_validate' * OutputWeight)';                            %   TY: the actual output of the testing data
ValidatingTime=toc;
%%%%%%%%%%% Calculate the output of testing input
tic;
Omega_test = kernel_matrix(P',Kernel_type, Kernel_para,TV.P');
TY=(Omega_test' * OutputWeight)';                            %   TY: the actual output of the testing data
TestingTime=toc;

%%%%%%%%%% Calculate training & testing classification accuracy

%%%%%%%%%% Calculate training & testing accuracy (RMSE) for regression case
TrainingAccuracy=sqrt(mse(T - Y));
ValidatingAccuracy=sqrt(mse(V.T - VY));
TestingAccuracy=sqrt(mse(TV.T - TY));


% subplot(3,1,1)
% plot(T,'r-','linewidth',4);
% hold on
% plot(Y,'-','linewidth',4);
% subplot(3,1,2)
% plot(V.T,'r-','linewidth',4);
% hold on
% plot(VY,'-','linewidth',4);
% 
% subplot(3,1,3)
% plot(TV.T,'r-','linewidth',4);
% hold on
% plot(TY,'-','linewidth',4);



    
    
% %%%%%%%%%%%%%%%%%% Kernel Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% function omega = kernel_matrix(Xtrain,kernel_type, kernel_pars,Xt)
% %输入:Xtrain每行为一个输入
% nb_data = size(Xtrain,1);
% 
% 
% if strcmpi(kernel_type,'RBF_kernel') || strcmpi(kernel_type,'RBF')
%     %输入参数小于4（等于3）时是训练核矩阵，此处将训练数据映射到核空间
%     if nargin<4,
%         XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
%         omega = XXh+XXh'-2*(Xtrain*Xtrain');
%         omega = exp(-omega./kernel_pars(1));
%     else
%     %输入等于4时是将测试数据映射到核空间，此时第一个输入参数为训练数据
%     %第4个参数为测试数据
%         XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
%         XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
%         omega = XXh1+XXh2' - 2*Xtrain*Xt';
%         omega = exp(-omega./kernel_pars(1));
%     end
%     
% elseif strcmpi(kernel_type,'lin_kernel') || strcmpi(kernel_type,'lin')
%     if nargin<4,
%         omega = Xtrain*Xtrain';
%     else
%         omega = Xtrain*Xt';
%     end
%     
% elseif strcmpi(kernel_type,'poly_kernel') || strcmpi(kernel_type,'poly')
%     if nargin<4,
%         omega = (Xtrain*Xtrain'+kernel_pars(1)).^kernel_pars(2);
%     else
%         omega = (Xtrain*Xt'+kernel_pars(1)).^kernel_pars(2);
%     end
%      
% elseif strcmpi(kernel_type,'wav_kernel') || strcmpi(kernel_type,'wav')
%     if nargin<4,
%         XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
%         omega = XXh+XXh'-2*(Xtrain*Xtrain');
%         
%         XXh1 = sum(Xtrain,2)*ones(1,nb_data);
%         omega1 = XXh1-XXh1';
%         omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
%         
%     else
%         XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
%         XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
%         omega = XXh1+XXh2' - 2*(Xtrain*Xt');
%         
%         XXh11 = sum(Xtrain,2)*ones(1,size(Xt,1));
%         XXh22 = sum(Xt,2)*ones(1,nb_data);
%         omega1 = XXh11-XXh22';
%         
%         omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
%     end
% end
% 
% 


