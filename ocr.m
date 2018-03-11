function   ocr(num,gray,ero,angle)
%行
[~, r1,~]=find(ero');
minh=r1(1);
maxh=r1(size(r1,1));
%列
[~, r2,~]=find(ero);
minw=r2(1);
maxw=r2(size(r2,1));
gray=imrotate(gray,angle,'crop');
for y=minh+20:maxh-20
    for x=minw+30:maxw-30
        newImg(y-minh-19,x-minw-29)=gray(y,x);
    end
end
%放缩
gray = imresize(newImg, [1400 1100]);
clear newImg
threshold = 0.85*graythresh(gray);
bw=im2bw(gray,threshold);
block=gblock(bw);
%Storage matrix word from image
word=[ ];
re=~block;
% figure,imshow(re),title('22.......');
%Opens text.txt as file for write
filename=strcat(num2str(1),'.txt');
fid = fopen(filename, 'a+');
fprintf(fid,'第%d张图片的处理:\r\n(1)字符识别结果:\r\n',num);
% Load templates
load templates
global templates
% Compute the number of letters in template file
num_letras=size(templates,2);
ret=1;
re2=re;
while ret
    [ft, re2]=lines(re2);
    imgn=ft;
%     figure,imshow(imgn),title('22.......');
    [L, Ne] = bwlabel(imgn);
    for n=1:Ne
        [r,c] = find(L==n);
        n1=imgn(min(r):max(r),min(c):max(c));
        [h, w]=size(n1);
        if w>60
            break;
        end
    end
    if w>60
        ret=0;
    end
    if isempty(re2)  %See variable 're' in Fcn 'lines'
        break
    end
end
if ret==0
    threshold = 0.8*graythresh(gray);
    bw=im2bw(gray,threshold);
    block=gblock(bw);
    %Storage matrix word from image
    word=[ ];
    re=~block;
end
while 1
    %Fcn 'lines' separate lines in text
    [fl, re]=lines(re);
    imgn=fl;
    %     figure,imshow(imgn),title('22..fa.....');
    %Uncomment line below to see lines one by one
    %imshow(fl);pause(0.5)
    %-----------------------------------------------------------------
    % Label and count connected components
    [L, Ne] = bwlabel(imgn);
    sh=1;
    a=0;
    for n=1:Ne
        if n+a>Ne
            break;
        end
        [r,c] = find(L==n+a);
        % Extract letter
        n1=imgn(min(r):max(r),min(c):max(c));
        [h, w]=size(n1);
        %         ginput();
        if h<0.8*sh&w<15
            if n+a==Ne
                letter='.';
            else
                a=a+1;
                [r,c] = find(L==n+a);
                n2=imgn(min(r):max(r),min(c):max(c));
                [h2, w2]=size(n2);
                if h>0.14*sh
                    letter='i';
                else
                    if h2<0.25*sh
                        letter=':';
                    else
                        letter='i';
                    end
                end
            end
        else
            if w<15
                letter='I';
            else
                if h<0.8*sh
                    img_r=imresize(n1,[42 24]);
%                     figure,imshow(img_r),title('22..fa.....');
                    letter=read_letter(img_r,num_letras,0);
                else
                    % Resize letter (same size of template)
                    img_r=imresize(n1,[42 24]);
%                     figure,imshow(img_r),title('22..fa.....');
                    %             ginput();
                    %Uncomment line below to see letters one by one
                    %imshow(img_r);pause(0.5)
                    %-------------------------------------------------------------------
                    % Call fcn to convert image to text
                    letter=read_letter(img_r,num_letras,1);
                    % Letter concatenation
                    sh=(h+sh)/2;
                end
            end
        end
        word=[word letter];
    end
    %fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
    fprintf(fid,'\t%s\r\n',word);%Write 'word' in text file (upper)
    % Clear 'word' variable
    word=[ ];
    %*When the sentences finish, breaks the loop
    if isempty(re)  %See variable 're' in Fcn 'lines'
        break
    end
end
  fprintf(fid,'(2)条形码识别结果:\r\n');
fclose(fid);
%Open 'text.txt' file
end