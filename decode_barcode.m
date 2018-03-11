%%条形码的识别、割取、译码函，不输出处理过程
function decode_barcode(filename, angle)
originImg2=imread( filename);
    if size(originImg2,3)==3
        gray=rgb2gray(originImg2);
    else
        gray=originImg2;
    end
    gray=imrotate(gray,angle,'crop');
    gray0=gray;
    [m,n]=size(gray);
    a=6;
    b=16;
%     figure,imshow(gray),title('未转正的原始图片');
    gray1=imrotate(gray,angle,'crop');
%     figure,imshow(gray1),title('转正后的原始图片');
    %*****************************************************%
    %计算横向差分比
    %图像一列里含有 i=1:(m/a-1)个矩形
    %图像一行里含有j=1:(n/b-1)个矩形,矩形从左到右，从上到下推移，将每一个矩形的灰度值用横纵灰度差分比值来替换
    %这样的话，条形码区域横纵灰度差分比值将会比较大，其他区域将会比较小，经过阈值处理可初步将条形码区域分割出来
     %****************************************************%
    for i=1:(m/a-1)
        for j=1:(n/b-1)
            x=a*(2*i-1)/2;
            y=b*(2*j-1)/2;
            rsum=0;
            csum=0;
            %计算矩形横向差分平均值
            for p=-a/2:(a/2-1)
                for q=-b/2:(b/2-1)
                    rsum=abs(double(gray(x+p+1,y+q+2))-double(gray(x+p+1,y+q+1)))+rsum;
                end
            end
            %计算矩形纵向差分平均值
            for q=-b/2:(b/2-1)
                for p=-a/2:(a/2-1)
                    csum=abs(double(gray(x+p+2,y+q+1))-double(gray(x+p+1,y+q+1)))+csum;
                end
            end
            %若矩形纵向差分平均值为0，则为了计算有意义令它为1
            if  csum==0
                csum=1;
            end
            %横纵差分比值，若落在条形码区域，则该数值会较大；否则会比较小
            scale=rsum/csum;
            %将此矩形纵向差分平均值付给该矩形的每一个像素点
            for q=-b/2:(b/2-1)
                for p=-a/2:(a/2-1)
                    gray(x+p+1,y+q+1)=scale;
                end
            end
            %matlab的最大优势是矩阵和数组运算，由于一开始接触matlab不太熟悉，故用了上面这种比较偏向c的循环方法。
           % gray(-a/2:(a/2-1),-b/2:(b/2-1))=scale;
        end
    end
%     figure,imshow(gray),title('横纵差分比值图像');
    %求横纵差分比值图像比值的均值、标准差，确定二值化的阈值
    me=mean2(gray);
    st=std2(gray);
    par1=1;
    par2=0;
    threshold1=me+par1*st;
    threshold2=me+par2*st;
    for i=1:m
        for j=1:n
            if gray(i,j)<threshold1&&gray(i,j)>threshold2
                gray(i,j)=256;
            else
                gray(i,j)=0;
            end
        end
    end
%     figure,imshow(gray),title('横纵差分比值的根据3r准则二值化后图像');%figure命令同时显示两幅图像
    %先利用腐蚀把目标之外的去掉
    se=strel('rectangle',[68,30]);
    ero=imerode(gray,se);
    se1=strel('rectangle',[58,380]);
    dil=imdilate(ero,se1);
    se2=strel('rectangle',[1,260]);
    ero2=imerode(dil,se2);
%     figure,imshow(ero2),title('成功提取条形码区域后的图像');
    for i=1:m
        for j=1:n
            if ero2(i,j)==0
                ero2(i,j)=255;
            else
                ero2(i,j)=1;
            end
        end
    end
%     figure,imshow(ero2),title('黑白像素对调后的图像');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %data:16.5.18
    %author:lyj
    %程序易错的地方是最后一个条形码
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    point=zeros(6,6);
    i = 1;
    j = 1;
    %利用bar_num表示从上到下的第几个条形码，由于测试中的图片中最多只有六个条形码，故令point=zeros(6,6);
    % point=zeros(6,6);记录的是条形码的三个顶点坐标
    bar_num = 0;
    while i<m-5
        while j<n
            while ero2(i,j)<=128
                bar_num = bar_num + 1;
                point( bar_num,1) = i;
                point( bar_num,2) = j;
                i = i + 20;
                while ero2(i,j)<128&&ero2(i,j+1)<128
                    j = j + 1;
                end
                point( bar_num,3) = i-20;
                point( bar_num,4) = j;
                j=(point( bar_num,2)+point( bar_num,4))/2;
                while ero2(i,j)<128&&ero2(i+1,j)<128
                    if i<m-1
                        i = i + 1;
                    end
                end
                point( bar_num,6)=point( bar_num,2);
                point( bar_num,5)=i;
                if i < m-41
                    i = i+40;
                else
                    i=1944;
                end
                j = 1;%当程序有检测到第一个条形码后就会进入这个循环，然后j大小的变化是根据里面的三个while来实现的，那么当检测完第一个条形码之后记得要让j重新赋初值      
            end
            j =j +1;%当程序在这一行没有检测到条形码，那么j大小的变化就需要在这里增加
        end
        j=1;%当一行检测完成之后记得让j重新恢复为1.
        i = i + 1;
    end
    ngray=ero2+gray0;
%     figure,imshow(ngray),title('条形码割取');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %date 2016/5/21
    %对条形码类型（code128和EAN-13）的判别利用条形码面积的不同
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hangliek=zeros(bar_num,2);
    flag=zeros(bar_num);
    for i=1: bar_num
        hangliek(i,1)=point(i,5)-point( i,1);%行数
        hangliek(i,2)=point(i,4)-point( i,2);%列数
        area=hangliek(i,1)*hangliek(i,2);
     %观察发现当area小于60000，就说明它不是条形码的区域，而是其他背景的区域
        if area<60000
            flag(i)=0;
            continue;
        end
        if hangliek(i,1)>200
            flag(i)=2;
        else
            flag(i)=1;
        end
    end
    %2016/5/28   n表示的是图片中的第几个条形码
    for n=1:bar_num 
        picture=zeros(hangliek(n,1),hangliek(n,2));
        for i=1:hangliek(n,1)
            for j=1:hangliek(n,2)
                picture(i,j)=gray0(point(n,1)+i, point(n,2)+j);
                if picture(i,j)<100
                    picture(i,j)=0;
                else
                    picture(i,j)=255;
                end
            end
        end
%         figure,imshow(picture),title('条形码割取');
        switch flag(n)
            case 1
                bar128(picture,1);
            case 2
                bar13(picture,1);
            otherwise
                continue;
        end
        clear picture
    end