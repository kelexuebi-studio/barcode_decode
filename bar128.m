function bar128(bw,num2)
load code128;
bar_128=bw;
% figure,imshow(bar_128),title('图像');
[m,n]=size(bar_128);

% num= 0;      %检测59根条形码
i=50;
k=0;
% number=zeros(12,4);%记录每个符号对应的黑白条码的宽度，11表示总共有11个字符，48表示有48个黑白条纹
% code_y=zeros(1,60);
for j=1:n-1
    if bar_128(i,j)~=bar_128(i,j+1)
        k=k+1;
        code_y(k)=j+1;
    end
end

[a,b]=size(code_y);
num=zeros(7);
% n=(b-8)/6+1;
for k=(b-7):(b-1)
    p=k-b+8;
    
    num(p)=code_y(k+1)-code_y(k);
end
%%

mubank=zeros(1,3);
mubank(1)=(num(4)+num(5)+num(6))/3;
mubank(3)=(num(2)+num(3))/2;
mubank(2)=(num(1)+num(7))/2;


%n表示的是共有多少个字母

n=(b-8)/6;
if n==11||n==15
    number=zeros(n,6);%记录黑白条纹的实际宽度
    error=[0,0,0];%记录黑白条纹的实际宽度与模板宽度的差值
    series=zeros(n,6);%用1 2 3 表示的黑白条纹
    yima='';
    disp(yima);
    nbar=1;%nbar表示的是第几个字符
    for k=1:(b-14)
        if mod(k-1,6)==0&&k~=1
            nbar=nbar+1;
        end
        q=k-(nbar-1)*6;
        number(nbar,q)=code_y(k+1)-code_y(k);
        if number(nbar,q)>=mubank(3)+3%这个2可能还会造成误差，得通过调试去确定最优值
            series(nbar,q)=4;
        else
            error=number(nbar,q)-mubank;
            find(min(abs(error)')==abs(error));
            series(nbar,q)=find(min(abs(error)')==abs(error));%; %matlab中有求矩阵最小值以及绝对值的函数
        end
        %说明已经读完一个字符
        if mod(k,6)==0
            str1=strcat(num2str(series(nbar,1)),num2str(series(nbar,2)));
            for i=3:6
                str1=strcat(str1,num2str(series(nbar,i)));
            end
            %         str1
            if k==6
                for i=104:106
                    if strcmp(str1,code128{i,1})
                        flagj=i-102;
                        break;
                    end
                end
            else
                
                for i=1:103
                    if strcmp(str1,code128{i,1})
                        %                    yima(1,nbar)=code128{i,flagj}
                        if strcmp(code128{i,flagj},'CODEB')
                            flagj=3;
                        end
                        if strcmp(code128{i,flagj},'CODEA')
                            flagj=2;
                        end
                        if strcmp(code128{i,flagj},'+')
                            break;
                        end
                        if strcmp(code128{i,flagj},'FNC4')
                            break;
                        end
                        if strcmp(code128{i,flagj},'CODEC')
                            flagj=4;
                            
                        else
                            yima=strcat(yima,code128{i,flagj});
                            break;
                        end
                    end
                end
            end
        end
    end
    % fprintf('code128译码结果为：%s\n',yima);
    filename=strcat(num2str(num2),'.txt');
    fid = fopen(filename, 'a+');
    fprintf(fid,'\tcode128译码结果为：%s\r\n',yima);
    fclose(fid);
end
