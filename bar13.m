
function bar13(bw,num)
bar_13=bw;
% figure(3),imshow(bar_13),title('ͼ��');
[m,n]=size(bar_13);

% num= 0;      %���59��������
i=200;
k=0; 
number=zeros(12,4);%��¼ÿ�����Ŷ�Ӧ�ĺڰ�����Ŀ�ȣ�11��ʾ�ܹ���11���ַ���48��ʾ��48���ڰ�����
bar_y=zeros(1,60);
    for j=1:n-1
        if bar_13(i,j)~=bar_13(i,j+1)
            k=k+1;
            bar_y(1,k)=j+1;
        end    
    end
nbar=0;%nbar��ʾ���ǵڼ�������
% rea=zeros(1,4);
jiou=zeros(1,12);%��ʾ���ǵڼ������ֵ���ż��������ȷ��ǰ����,��1��ʾ�棬0��ʾż��
shuzi=zeros(1,12);%��ʾ���ǵڼ���������ʲô
a=0;
b=0;
for k=4:56
    if k>27&&k<33
%         break;
       continue;
     else if k>=33
          q=k-29;
     else
         q=k;
         end
    end
    if mod(q,4)==0
        nbar=nbar+1;
    end
    if k<=27
        p=q-3-4*(nbar-1);
    else if k>32
          p=k-4*(nbar+1);   
        end
    end
    number(nbar,p)=bar_y(k+1)-bar_y(k);   
    if mod(q+1,4)==0%����һ���ַ��󣬾Ͱ�������������������������Ʊ߾��뷨
        t=number(nbar,1)+number(nbar,2)+number(nbar,3)+number(nbar,4);
        t1=number(nbar,1)+number(nbar,2);
        t2=number(nbar,2)+number(nbar,3);
        at1=round(t1*7/t);
        at2=round(t2*7/t);
        at=at1*10+at2;
        temp1=number(nbar,1);
        temp2=number(nbar,2);
%         temp3=number(nbar,3);
%         temp4=number(nbar,4);
        switch at
            case 53
               shuzi(1,nbar)=0;
               jiou(1,nbar)=1;
            case 44
%                 shuzi(1,nbar)=1;
                jiou(1,nbar)=1;  
                if temp1<temp2
                  shuzi(1,nbar)=7;
                else
                  shuzi(1,nbar)=1;
                end
            case 33
                jiou(1,nbar)=1;
                if temp2<temp1
                  shuzi(1,nbar)=2;
                else
                  shuzi(1,nbar)=8;
                end
            case 55
                jiou(1,nbar)=1;
                shuzi(1,nbar)=3;
             case 24
                jiou(1,nbar)=1;
                shuzi(1,nbar)=4;    
              case 35
                jiou(1,nbar)=1;
                shuzi(1,nbar)=5;
             case 22
                jiou(1,nbar)=1;
                shuzi(1,nbar)=6;   
              case 42
                jiou(1,nbar)=1;
                shuzi(1,nbar)=9; 
                
              case 23
               shuzi(1,nbar)=0;
               jiou(1,nbar)=0;
              case 34
%                 shuzi(1,nbar)=1;
                jiou(1,nbar)=0;
                if temp1<temp2
                  shuzi(1,nbar)=1;
                else
                  shuzi(1,nbar)=7;
                end
            case 43
                jiou(1,nbar)=0; 
                if temp2<temp1
                  shuzi(1,nbar)=8;
                else
                  shuzi(1,nbar)=2;
                end
            case 25
                jiou(1,nbar)=0;
                shuzi(1,nbar)=3;
             case 54
                jiou(1,nbar)=0;
                shuzi(1,nbar)=4;    
              case 45
                jiou(1,nbar)=0;
                shuzi(1,nbar)=5;
             case 52
                jiou(1,nbar)=0;
                shuzi(1,nbar)=6;   
              case 32
                jiou(1,nbar)=0;
                shuzi(1,nbar)=9;             
        end 
    end
end   
%������ż�Եó�ǰ����
% shuzi
% jiou
qiancode=[63 52 50 49 44 38 35 42 41 37 ];
muban=[32;16;8;4;2;1;0;0;0;0;0;0];%matlab������������
jious=jiou*muban;
for i=1:10
    if jious==qiancode(1,i)
        qian=i-1;
        break;
    end
end
%  fprintf('\nǰ����Ϊ��%d\n',qian);
%  fprintf('������ݷ�Ϊ��%d %d %d %d %d %d \n',shuzi(1:6));
%  fprintf('�Ҳ����ݷ�Ϊ��%d %d %d %d %d %d \n',shuzi(7:11));
%  fprintf('У���Ϊ��%d \n',shuzi(12));
    filename=strcat(num2str(num),'.txt');
    fid = fopen(filename, 'a+');
    fprintf(fid,'\tEAN13��������Ϊ��%d%d%d%d%d%d%d%d%d%d%d%d%d\n',qian,shuzi(1:12));
%     fprintf('EAN13��������Ϊ��%d%d%d%d%d%d%d%d%d%d%d%d%d \n',qian,shuzi(1:12));
    
  n1=sum(shuzi(1:2:11))*3;
  n2=sum(shuzi(2:2:11))+qian;
  nz=10-mod(n1+n2,10);
  if nz==shuzi(1,12)
      fprintf(fid,'   ��У�飬EAN-13������ȷ!\r\n');
  end
  fclose(fid);
end
                





