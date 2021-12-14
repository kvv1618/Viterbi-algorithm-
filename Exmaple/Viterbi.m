function decoded_b=Viterbi(bn)
    N=size(bn);
    N=N(2);
    n=(0:N);
    t=1:N;
    prcodes=[[0;0;0],[1;1;0],[1;0;0],[0;1;0],...
    [1;1;1],[0;0;1],[0;1;1],[1;0;1]];
    %===== Mersenne twister
    % s=RandStream.create('mt19937ar','seed',134);
    % RandStream.setGlobalStream(s);
%     bn=randi([0 1],1,N);
    Rn=zeros(3,N); % coded sequence
    Sn=zeros(1,N+1); % state
    for k=1:N
    kn=4*bn(k)+Sn(k);
    Rn(:,k)=prcodes(:,kn+1);
    Sn(k+1)=floor(kn/2); % transition
    end
%     plot(n,Sn,'o',n,Sn,'-'); grid
    Rnt=reshape(Rn,1,3*N);
    save codedseq bn Rnt -V6



    %===== decoderv.m =====

    %==== Test sequence
    Rnte=Rnt;
    P=3; N=length(Rnte)/P;
    prcodes=[[0;0;0],[1;1;0],[1;0;0],[0;1;0],...
    [1;1;1],[0;0;1],[0;1;1],[1;0;1]];
    pstate=[1 3 1 3;2 4 2 4]; ostate=zeros(4,N-P+3);
    wght=zeros(4,1); st=[];
    %===== level 1
    idxd=1; idxf=3;
    bl=Rnte(idxd:idxf)'*ones(1,2);
    delta=sum(xor([[0;0;0] [1;1;1]],bl));
    wght=wght+[delta(1);0;delta(2);0];
    ostate(:,1)=[1;0;1;0]; st=[st wght];
    %===== level 2
    idxd=4; idxf=6;
    bl=Rnte(idxd:idxf)'*ones(1,4);
    delta=sum(xor([[0;0;0] [1;0;0]...
    [1;1;1] [0;1;1]],bl));
    wght=[wght(1)+delta(1); wght(3)+delta(2);...
    wght(1)+delta(3); wght(3)+delta(4)];
    st=[st wght]; ostate(:,2)=[1;3;1;3];
    %===== level 3...
    for k=3:N
    idxd=P*(k-1)+1; idxf=idxd+2;
    bl=Rnte(idxd:idxf)' * ones(1,8);
    delta=sum(xor(prcodes,bl));
    [td,ti]=min(reshape(delta+[wght' wght'],2,4));
    wght=td'; st=[st wght];
    ostate(:,k)=pstate(ti+[0:2:6])';
    end
    %===== backtracking
    mpath=zeros(1,N+1); rseq=mpath; mbits=zeros(1,N);
    [mmin,idx]=min(st(:,end));
    idxm=idx(1); mpath(N+1)=idxm;
    for k=N:-1:1
    mpath(k)=ostate(idxm,k);
    mbits(k)=floor((idxm-1)/2);
    idxm=ostate(idxm,k);
    end

%     figure
%     subplot(2,1,1);
%     stem(t,bn);
%     title('Original sequence')
%     subplot(2,1,2);
%     stem(t,mbits);
%     title('Decoded sequence')
    decoded_b=mbits;

end