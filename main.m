warning off %#ok<WNOFF>
clear;
close all;
clc;
%��ȡͼƬ�ļ�
filename=strcat(num2str(1),'.txt');
fid=fopen(filename,'wt');
fprintf(fid,'');
fclose(fid);
%%�Ƿ����������̣�0Ϊ�������1Ϊ���
procedure = 1;
%************************************************************************
%��������6��ͼƬ�������뿴һ���ӿ���6�ŵ�����Ч��ʱ��ֻ��Ҫ��num�ķ�Χ��Ϊ1��7���ɣ�
%�������һ��һ�ſ���ֻ��Ҫ��num�ķ�Χ��Ϊ  n:n  (n=1,2,3,4,5,6)���ɣ�
for num=1:1
    filename=strcat(num2str(num),'.bmp');
    %rotation�ӳ�����Ϊ�˵õ���Ҫ��ת�ĽǶ�angle�Լ���ǩ�ı�Ե
    [gray,ero,angle]=rotation(filename);
    filename2=strcat('original_image/', 'a',filename);
    if procedure
        %********************************************************************%
        %��ĸʶ�����ocr������ģ��ƥ�䷨����ʶ��num,gray,ero,angleΪ��ĸʶ����Ҫ�õ��Ĳ���
        ocr_procedure(num,gray,ero,angle);
        %********************************************************************%
        %�������ʶ�𡢸�ȡ�����뺯��
        decode_barcode_procedure(filename2, angle);
    else
        %********************************************************************%
        %�����������̣�ֻ���������
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
