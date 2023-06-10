function [plot] = dt_frame(filename, flipX,flipY, width, height,tstart,tend,cd_data)
%cd_data = load_cd_events(filename, flipX, flipY);

x=cd_data.x;
y=cd_data.y;
ts=cd_data.ts;
p=cd_data.p;
CD=zeros(height,width);
indexstart=find(ts==tstart, 1);
indexend=find(ts==tend, 1, 'last' );

for i=indexstart:indexend
    xc=x(i);
    yc=y(i);
   CD(yc,xc)=CD(yc,xc) + p(i);
end
CD(CD>=100)=NaN;
lim=max(abs(CD),[],'all');
plot=image(CD,'CDataMapping','scaled')
colormap(parula)
colorbar;
clim([-lim,lim])
colorbar
xlim([0,width]);
ylim([0,height]);

end

