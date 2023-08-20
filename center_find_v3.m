function [cx,cy]=center_find_v3(filename, flipX,flipY, width, height,tstart,tend,dir, dframe, cd_data)
%flipX and flip Y defaults to zero and flips with 1. 

%width and height should match the resolution of your camera: for evt 2 use 640 x 480 for evt 3 use 1280 x 720

% tstart is when the center finder starts in microseconds

% tend is when the center finder ends in microseconds

%dir is whether you are looking for objects that block light or produce
%light. -1 for when objects block light and 1 for when objects produce
%light

%dframe is the amount of microseconds to accumulate for each image frame
%produced. it is also the amount of time between when the code finds the
%center. 


%cd_data = load_cd_events(filename, flipX, flipY);

x=cd_data.x+1;
y=cd_data.y+1;
ts=cd_data.ts;
p=cd_data.p;
CD=zeros(height,width);
if dir>0
    for j=tstart:tend
        indexstart=find(ts==j, 1);
        indexend=find(ts==j, 1, 'last' );
        for i=indexstart:indexend
            xc=x(j+i);
            yc=y(j+i);
            CD(yc,xc)=CD(yc,xc) + p(i+j);
        end
        if rem(j,dframe)==0
            [cy_h,cx_h]=find(CD>0);
            if isempty(cy_h) | isempty(cx_h)
                cx(j+1)=0;
                cy(j+1)=0;
            else
                cx(j+1)=mean(cx_h);
                cy(j+1)=mean(cy_h);
            end
            CD_A=CD;
            CD_A(abs(CD_A)>=100)=NaN;
            lim=max(abs(CD_A),[],'all')
            plotA=image(CD_A,'CDataMapping','scaled');
            hold on
            colormap(parula)
            colorbar;
            if isempty(lim)==1
                lim=1;
            end
            clim([-lim,lim])
            colorbar
            xlim([0,width]);
            ylim([0,height]);
            plot(round(cx(end),0),round(cy(end),0),'Or','markersize',12,'linewidth',2);
            hold off
            text(500,400,sprintf('%f',j))
            F=getframe;
        end
    end
elseif dir<0
    for j=tstart:tend
        indexstart=find(ts==j, 1);
        indexend=find(ts==j, 1, 'last' );
        for i=indexstart:indexend
            xc=x(j+i);
            yc=y(j+i);
            CD(yc,xc)=CD(yc,xc) + p(i+j);
        end
        if rem(j,dframe)==0
            [cy_h,cx_h]=find(CD<0);
            if isempty(cy_h) | isempty(cx_h)
                cx(j+1)=0;
                cy(j+1)=0;
            else
                cx(j+1)=mean(cx_h);
                cy(j+1)=mean(cy_h);
            end
            CD_A=CD;
            CD_A(abs(CD_A)>=100)=NaN;
            lim=max(abs(CD_A),[],'all')
            plotA=image(CD_A,'CDataMapping','scaled');
            hold on
            colormap(parula)
            colorbar;
            if isempty(lim)==1
                lim=1;
            end
            clim([-lim,lim])
            colorbar
            xlim([0,width]);
            ylim([0,height]);
            plot(round(cx(end),0),round(cy(end),0),'Or','markersize',12,'linewidth',2);
            hold off
            text(500,400,sprintf('%f',j))
            F=getframe;
        end
    end
end


for k=2:numel(cx)
dp(k-1)=sqrt(((cx(k)-cx(k-1))^2)+((cy(k)-cy(k-1))^2));
end
vel=dp/dframe;
t=tstart:tend;
figure
plot(t,vel,'.b');
for L=2:numel(vel)
dvel(L-1)=(vel(L)-vel(L-1));
end
accel=dvel/dframe;
t=tstart:1:tstart+numel(accel);
figure
plot(t,accel,'b.');
end







