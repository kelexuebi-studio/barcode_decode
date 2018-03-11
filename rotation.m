function  [gray,ero,angle]=rotation(filename)
% filename=strcat(num2str(num),'.bmp');
filename1=strcat('new_image/','new',filename);
originImg=imread(filename1);
% figure,imshow(originImg),title('photoshp������ԭʼͼƬ');
if size(originImg,3)==3
    gray=rgb2gray(originImg);
else
    gray=originImg;
end
%�����㣬��ȡ����ǩ�ı߿�
bw=im2bw(gray,0.01);
se1=strel('rectangle',[6,6]);
ero=imerode(bw,se1);
se1=strel('rectangle',[6,6]);
dil=imdilate(bw,se1);
ero=dil-ero;
% figure,imshow(ero),title('��������ȡ��ǩ�߿�');
%�����ǩ�������ֱ����Ĳ�ֵdiff,ÿ����ת0.1*diff�ȣ�ֱ��abs(diff��<=1,��˵����ǩ�Ѿ���ת����ȷ��λ�á�
%[m,n]=size(ero);
diff=2;
angle=0;
while abs(diff)>1
    [c, r, v]=find(ero');
    h=round((r(size(r,1))+r(1))/2);
    h=h-150;
    w1=1;
    while ero(h,w1)==0
        w1=w1+2;
    end
    h=h+300;
    w2=1;
    while ero(h,w2)==0
        w2=w2+2;
    end
    diff=w1-w2;
    ero=imrotate(ero,0.1*diff,'crop');
    angle=angle+0.1*diff;
end
% figure,imshow(ero),title('ת���ı�ǩ�߿�');
end
