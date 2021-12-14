I = imread('blackhole.jpg');
% imshow(I);
B = dec2bin(I);
C = reshape(B',1,numel(B));
N=size(C);
N=N(2);
N
count=0;
M=200000;
final_bn={};
loop_n=(N/M);
for i=1:loop_n
    bn=zeros(1,M);
    index=1;
    for j=(i-1)*M+1:min(N,(i-1)*M+M)
        bn(index)=C(j)-'0';
        index=index+1;
    end
    decoded_b=Viterbi(bn);
    count=count+sum(bn==decoded_b);
    if i==1
        final_bn=decoded_b;
    else
        final_bn=[final_bn decoded_b];
    end
    final_loop=i*M;
end
index=1;
for j=final_loop+1:N
    bn=zeros(1,N-final_loop);
    bn(index)=C(j)-'0';
    index=index+1;
end
decoded_b=Viterbi(bn);
count=count+sum(bn==decoded_b);
final_bn=[final_bn decoded_b];
size(final_bn)
count/N
