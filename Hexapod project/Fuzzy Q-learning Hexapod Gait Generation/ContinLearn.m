clear all

% InitializeConProb


alpha=.8;
lambda=.9;
Rew_mat=zeros(729);
Fuzzy_Reward=readfis('Reward');
Kgain=-1500;
Dgain=-50;
exitflag=1;
SimTime=.5;


st=111111;
load ConLeRes

tic;


for iter=1:5000
States(nn+1)=st;
ThetaB=StDeg(st);

PossibAc=PosAc(st);

% ac=PossibAc(randi([1,63])); %Next action is chosen randomly.

% ac=AcCh(Qr,st); % Next action is chosen Greedy (max Q)

ac=AcCh_eps(Qr,st,.1); % Next action is chosen based on its own reward.


ThetaE=StDeg(ac);

JointInit=InPosHex(ThetaB);

sim('HexWaRo_StAc_Workspace')

BodyMov=LeOfSeFun(LeTi1,LeTi2,LeTi3,LeTi4,LeTi5,LeTi6);
BodyTilt=BoOriFun(BodPos(:,4:6));

Rew=evalfis([100*BodyMov,BodyTilt],Fuzzy_Reward);% Displacement in Fuzzy Reward is assigned in (cm)

sa=Qm(st,ac);
% [st_i,ac_i]=ind2sub([729,729],sa);

cu_st=ac;
FuAc=PosAc(cu_st);
sap=Qm(cu_st*ones(63,1),FuAc);%All possible future actions;



Rew_mat(sa)=Rew;
Qr(sa)=alpha*(Rew+lambda*max(max(Qr(sap))))+(1-alpha)*Qr(sa);

st=ac
nn=nn+1
Actions(nn)=st;
Rew_array(nn)=Rew;
% Q_array(:,:,nn)=Qr;
end

EvalTime=toc;
% TotEval=EvalTime+TotEval;
save ConLeRes Qr st nn  Actions Rew_array States
plot(Qr(Qm(States(:),Actions(:))))