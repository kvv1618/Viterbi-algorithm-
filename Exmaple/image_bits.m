I = imread('blackhole.jpg');
figure
imshow(I);
%%
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
%%
final_bits=zeros(1,N);
final_data=blanks(N);
for i=1:N
    if final_bn(i)==0
        final_data(i)='0';
    else
        final_data(i)='1';
    end
end
Final=reshape(final_data,8,2359296);
Final1=Final';
X=bin2dec(Final1);
A=zeros(768,1024,3,'uint8');
l=0;
m=768;
for i=1:3
    for j=1:1024
        for k=1:768
            A(k,j,i)=X(m*l+k);
        end
        l=l+1;
    end
end

 imwrite(A,'newimage.jpg','jpg');
 imfinfo('newimage.jpg');
 image(A);           
