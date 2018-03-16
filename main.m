warning off %#ok<WNOFF>
clear;
close all;
clc;
%读取图片文件
filename=strcat(num2str(1),'.txt');
fid=fopen(filename,'wt');
fprintf(fid,'');
fclose(fid);
%%是否输出处理过程图像，0为不输出，1为输出
procedure = 1;
%************************************************************************
%共测试了6张图片，每张图片有3到6个条形码，当你想看一次性看完6张的译码效果时，只需要将num的范围设为1：7即可！
%如果你想一张一张看，只需要将num的范围设为  n:n  (n=1,2,3,4,5,6)即可！
for num=1:1
    filename=strcat(num2str(num),'.bmp');
    %rotation子程序是为了得到需要旋转的角度angle以及标签的边缘
    [gray,ero,angle]=rotation(filename);
    filename2=strcat('original_image/', 'a',filename);
    if procedure
        %********************************************************************%
        %字母识别程序ocr，采用模板匹配法进行识别，num,gray,ero,angle为字母识别需要用到的参量
        ocr_procedure(num,gray,ero,angle);
        %********************************************************************%
        %条形码的识别、割取、译码函数
        decode_barcode_procedure(filename2, angle);
    else
        %********************************************************************%
        %不输出处理过程，只输出处理结果
        ocr(num,gray,ero,angle);
        decode_barcode(filename2, angle);
    end
    
    filename=strcat(num2str(1),'.txt');
    fid=fopen(filename,'a+');
    fprintf(fid,'\r\n\n\n');
    fclose(fid);
    clear;
    
end
filename=strcat(num2str(1),'.txt');
winopen(filename)
