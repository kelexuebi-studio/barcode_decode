function block=gblock(bw)
    bw=bw(617:937,1:1000);
    maxw=1000;
    maxh=321;
    h=1;
    w=5;
    while w<maxw
        w=5;
        while bw(h,w)==1&&w<maxw
            w=w+1;
        end
        h=h+1;
    end
    h1=h;
    h=maxh;
    w=5;
    while w<maxw
        w=5;
        while bw(h,w)==1&&w<maxw
            w=w+1;
        end
        h=h-1;
    end
    h2=h;
    bw=bw(h1:h2,5:1000);
%     figure,imshow(bw);
    bw=adj(bw);
    bw=adj(bw);
    block=bw;
end

function bw=adj(bw)
    [maxw,maxh]=size(bw);
    bw=~bw;
%      figure,imshow(bw);
    midw=round(maxw/2);
    wl=1;
    wr=maxw;
    h=1;
    tmp=bw;
    while wl==1&&wr==maxw
        wl=midw;
        wr=midw; 
        while bw(h,wl)==0&&wl>1
            wl=wl-1;
        end
        while bw(h,wr)==0&&wr<maxw
            wr=wr+1;
        end
        if wr==maxw&&wl~=1
           tmp=imrotate(bw,0.8,'crop');
        end
        if wr~=maxw&&wl==1
           tmp=imrotate(bw,-0.8,'crop');     
        end
        h=h+1;
    end
    bw=~tmp;
end



