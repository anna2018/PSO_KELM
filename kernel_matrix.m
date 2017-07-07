function omega = kernel_matrix(Xtrain,kernel_type, kernel_pars,Xt)
%����:Xtrainÿ��Ϊһ������
nb_data = size(Xtrain,1);


if strcmpi(kernel_type,'RBF_kernel') || strcmpi(kernel_type,'RBF')
    %�������С��4������3��ʱ��ѵ���˾��󣬴˴���ѵ������ӳ�䵽�˿ռ�
    if nargin<4,
        XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        omega = exp(-omega./kernel_pars(1));
    else
    %�������4ʱ�ǽ���������ӳ�䵽�˿ռ䣬��ʱ��һ���������Ϊѵ������
    %��4������Ϊ��������
        XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
        XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*Xtrain*Xt';
        omega = exp(-omega./kernel_pars(1));
    end
    
elseif strcmpi(kernel_type,'lin_kernel') || strcmpi(kernel_type,'lin')
    if nargin<4,
        omega = Xtrain*Xtrain';
    else
        omega = Xtrain*Xt';
    end
    
elseif strcmpi(kernel_type,'poly_kernel') || strcmpi(kernel_type,'poly')
    if nargin<4,
        omega = (Xtrain*Xtrain'+kernel_pars(1)).^kernel_pars(2);
    else
        omega = (Xtrain*Xt'+kernel_pars(1)).^kernel_pars(2);
    end
     
elseif strcmpi(kernel_type,'wav_kernel') || strcmpi(kernel_type,'wav')
    if nargin<4,
        XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        
        XXh1 = sum(Xtrain,2)*ones(1,nb_data);
        omega1 = XXh1-XXh1';
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
        
    else
        XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
        XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*(Xtrain*Xt');
        
        XXh11 = sum(Xtrain,2)*ones(1,size(Xt,1));
        XXh22 = sum(Xt,2)*ones(1,nb_data);
        omega1 = XXh11-XXh22';
        
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
    end
end




