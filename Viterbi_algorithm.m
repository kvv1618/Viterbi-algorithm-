clear all
%==== Test sequence
% Rnte=[0 0 0 1 1 0 1 1 1 0 1 0 0 0 0];
% load('codedseq.mat','Rnt');
% load('codedseq.mat', 'n');
% load('codedseq.mat', 'bn');
clear all, N=10; 
n=(0:N-1);
prcodes=[[0;0;0],[1;1;0],[1;0;0],[0;1;0],[1;1;1],[0;0;1],[0;1;1],[1;0;1]]
%===== Mersenne twister
s=RandStream.create('mt19937ar','seed',134);
RandStream.setGlobalStream (s);
bn=randi([0 1],1,N);
% bn=[1,0,1,1,1,1,1,1,0,0]; 
Rn=zeros(3,N); % coded sequence
Sn=zeros(1,N); % state
for k=1:N-1
    kn=4*bn(k)+Sn(k);
    Rn(:,k)=prcodes(:,kn+1);
    Sn(k+1)=floor(kn/2); % transition
end
plot(n,Sn,'o',n,Sn,'-'); grid
Rnt=reshape(Rn,1,3*N);
save codedseq bn n Rnt -V6


Rnte=Rnt;
P=3; N=length(Rnte)/P;
prcodes=[[0;0;0],[1;1;0],[1;0;0],[0;1;0],[1;1;1],[0;0;1],[0;1;1],[1;0;1]];
pstate=[1 3 1 3;2 4 2 4];
ostate=zeros(4,N-P+2);
wght=zeros(4,1);
st=[];
%===== level 1
idxd=1; idxf=3;
bl=Rnte(idxd:idxf)'*ones(1,2);
delta=sum(xor([[0;0;0] [1;1;1]],bl));
wght=wght+[delta(1);0;delta(2);0];
ostate(:,1)=[1;0;1;0];
st=[st wght];
%===== level 2
idxd=4; idxf=6;
bl=Rnte(idxd:idxf)'*ones(1,4);
delta=sum(xor([[0;0;0] [1;0;0] [1;1;1] [0;1;1]],bl));
wght=[wght(1)+delta(1); wght(3)+delta(2);wght(1)+delta(3); wght(3)+delta(4)];
st=[st wght];
ostate(:,2)=[1;3;1;3];
%===== level 3...
for k=3:N
idxd=P*(k-1)+1; idxf=idxd+2;
bl=Rnte(idxd:idxf)' * ones(1,8);
delta=sum(xor(prcodes,bl));
% delta+[wght' wght'];
reshape(delta+[wght' wght'],2,4);
[td,ti]=min(reshape(delta+[wght' wght'],2,4));
wght=td';
st=[st wght];
ostate(:,k)=pstate(ti+[0:2:6])';
end
%===== backtracking
mpath=zeros(1,N+1);
rseq=mpath;
mbits=zeros(1,N);
[mmin,idx]=min(st(:,end));
idxm=idx(1);
mpath(N+1)=idxm;
for k=N:-1:1
% ostate;
mpath(k)=ostate(idxm,k);
mbits(k)=floor((idxm-1)/2); 
idxm=ostate(idxm,k);
end
st, ostate, mpath, mbits,
subplot(2,1,1)
stem(n,mbits)
subplot(2,1,2)
stem(n,bn)
