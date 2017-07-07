
clc;
global Train_data  Validate_data  Test_data
Train_data=T_data;
Validate_data=V_data;
Test_data=TT_data;
%%PSO优化核函数参数

functname='Experiment2';
plotfcn = 'goplotpso';
shw     = 1;
xrng=[0,10];
yrng=[0,10];
minmax=0;
mvden = 2; 
ps    = 30;
modl  = 1;
% note: if errgoal=NaN then unconstrained min or max is performed
  if minmax==1
    %  errgoal=0.97643183; % max for f6 function (close enough for termination)
      errgoal=NaN;
  else
     % errgoal=0; % min
      errgoal=NaN;
  end
minx = xrng(1);
  maxx = xrng(2);
  miny = yrng(1);
  maxy = yrng(2);
  dims=1;
varrange=[];
  mv=[];
  for i=1:dims
      varrange=[varrange;minx maxx];
      mv=[mv;(varrange(i,2)-varrange(i,1))/mvden];
  end
  ac      = [2.1,2.1];% acceleration constants, only used for modl=0
  Iwt     = [0.9,0.4];  % intertia weights, only used for modl=0
  epoch   = 400; % max iterations
  wt_end  = 100; % iterations it takes to go from Iwt(1) to Iwt(2), only for modl=0
  errgrad = 1e-99;   % lowest error gradient tolerance
  errgraditer=100; % max # of epochs without error change >= errgrad
  PSOseed = 0;    % if=1 then can input particle starting positions, if= 0 then all random
  % starting particle positions (first 20 at zero, just for an example)
   PSOseedValue = repmat([0],ps-10,1);
  
  psoparams=...
   [shw epoch ps ac(1) ac(2) Iwt(1) Iwt(2) ...
    wt_end errgrad errgraditer errgoal modl PSOseed];

[pso_out,tr,te]=pso_Trelea_vectorized(functname, dims,...
      mv, varrange, minmax, psoparams,plotfcn,PSOseedValue);


