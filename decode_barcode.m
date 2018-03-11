%%�������ʶ�𡢸�ȡ�����뺯��������������
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
%     figure,imshow(gray),title('δת����ԭʼͼƬ');
    gray1=imrotate(gray,angle,'crop');
%     figure,imshow(gray1),title('ת�����ԭʼͼƬ');
    %*****************************************************%
    %��������ֱ�
    %ͼ��һ���ﺬ�� i=1:(m/a-1)������
    %ͼ��һ���ﺬ��j=1:(n/b-1)������,���δ����ң����ϵ������ƣ���ÿһ�����εĻҶ�ֵ�ú��ݻҶȲ�ֱ�ֵ���滻
    %�����Ļ���������������ݻҶȲ�ֱ�ֵ����Ƚϴ��������򽫻�Ƚ�С��������ֵ����ɳ���������������ָ����
     %****************************************************%
    for i=1:(m/a-1)
        for j=1:(n/b-1)
            x=a*(2*i-1)/2;
            y=b*(2*j-1)/2;
            rsum=0;
            csum=0;
            %������κ�����ƽ��ֵ
            for p=-a/2:(a/2-1)
                for q=-b/2:(b/2-1)
                    rsum=abs(double(gray(x+p+1,y+q+2))-double(gray(x+p+1,y+q+1)))+rsum;
                end
            end
            %�������������ƽ��ֵ
            for q=-b/2:(b/2-1)
                for p=-a/2:(a/2-1)
                    csum=abs(double(gray(x+p+2,y+q+1))-double(gray(x+p+1,y+q+1)))+csum;
                end
            end
            %������������ƽ��ֵΪ0����Ϊ�˼�������������Ϊ1
            if  csum==0
                csum=1;
            end
            %���ݲ�ֱ�ֵ�����������������������ֵ��ϴ󣻷����Ƚ�С
            scale=rsum/csum;
            %���˾���������ƽ��ֵ�����þ��ε�ÿһ�����ص�
            for q=-b/2:(b/2-1)
                for p=-a/2:(a/2-1)
                    gray(x+p+1,y+q+1)=scale;
                end
            end
            %matlab����������Ǿ�����������㣬����һ��ʼ�Ӵ�matlab��̫��Ϥ���������������ֱȽ�ƫ��c��ѭ��������
           % gray(-a/2:(a/2-1),-b/2:(b/2-1))=scale;
        end
    end
%     figure,imshow(gray),title('���ݲ�ֱ�ֵͼ��');
    %����ݲ�ֱ�ֵͼ���ֵ�ľ�ֵ����׼�ȷ����ֵ������ֵ
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
%     figure,imshow(gray),title('���ݲ�ֱ�ֵ�ĸ���3r׼���ֵ����ͼ��');%figure����ͬʱ��ʾ����ͼ��
    %�����ø�ʴ��Ŀ��֮���ȥ��
    se=strel('rectangle',[68,30]);
    ero=imerode(gray,se);
    se1=strel('rectangle',[58,380]);
    dil=imdilate(ero,se1);
    se2=strel('rectangle',[1,260]);
    ero2=imerode(dil,se2);
%     figure,imshow(ero2),title('�ɹ���ȡ������������ͼ��');
    for i=1:m
        for j=1:n
            if ero2(i,j)==0
                ero2(i,j)=255;
            else
                ero2(i,j)=1;
            end
        end
    end
%     figure,imshow(ero2),title('�ڰ����ضԵ����ͼ��');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %data:16.5.18
    %author:lyj
    %�����״�ĵط������һ��������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    point=zeros(6,6);
    i = 1;
    j = 1;
    %����bar_num��ʾ���ϵ��µĵڼ��������룬���ڲ����е�ͼƬ�����ֻ�����������룬����point=zeros(6,6);
    % point=zeros(6,6);��¼�����������������������
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
                j = 1;%�������м�⵽��һ���������ͻ�������ѭ����Ȼ��j��С�ı仯�Ǹ������������while��ʵ�ֵģ���ô��������һ��������֮��ǵ�Ҫ��j���¸���ֵ      
            end
            j =j +1;%����������һ��û�м�⵽�����룬��ôj��С�ı仯����Ҫ����������
        end
        j=1;%��һ�м�����֮��ǵ���j���»ָ�Ϊ1.
        i = i + 1;
    end
    ngray=ero2+gray0;
%     figure,imshow(ngray),title('�������ȡ');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %date 2016/5/21
    %�����������ͣ�code128��EAN-13�����б���������������Ĳ�ͬ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hangliek=zeros(bar_num,2);
    flag=zeros(bar_num);
    for i=1: bar_num
        hangliek(i,1)=point(i,5)-point( i,1);%����
        hangliek(i,2)=point(i,4)-point( i,2);%����
        area=hangliek(i,1)*hangliek(i,2);
     %�۲췢�ֵ�areaС��60000����˵������������������򣬶�����������������
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
    %2016/5/28   n��ʾ����ͼƬ�еĵڼ���������
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
%         figure,imshow(picture),title('�������ȡ');
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