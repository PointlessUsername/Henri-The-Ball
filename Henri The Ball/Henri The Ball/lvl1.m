clear; clc; close all
%-----------------------Setup-----------------------------%

%Obtain screen resolution
set(0,'units','pixels')
res = get(0,'screensize');
%fraction of screenresoluton vs expected screen size
x=res(3)/1920;
y=res(4)/1080;

%figure
platformFigure = figure('color',[.4,.3,.4],'KeyPressFcn',@keyboard,'WindowState', 'maximized');

%Provide user withs message
annotation('textbox', [.15, 0.875,.1,.1], 'string', 'Use WASD or the arrow keys to move, press down to stop moving','EdgeColor','none','FontSize',25*(x+y)/2,'color',[1,.99,1])

%axes
platformAxis = axes('color',[.9,.9,.9],...
    'XLim',[0,100],'XTickLabels',[],'XTick',[],...
    'YLim',[0,100],'YTickLabels',[],'YTick',[]);

%player
global playerVel
global playerPos
playerVel = [0,0]; %Player velocity [x,y]
playerPos = [3,2]; %players position
player = line(playerPos(1),playerPos(2),'marker','.','markersize',70*(x+y)/2,'color',[.7,.2,.2]);

%drawing environment
rectangle('Position',[0,0,2,100],'FaceColor',[.3,.3,.3])
rectangle('Position',[15,15,5,5])
rectangle('Position',[30,30,4.5,5])
rectangle('Position',[45,45,4,5])
rectangle('Position',[60,60,3.5,5])
rectangle('Position',[75,75,25,5])
rectangle('Position',[98,0,2,75],'FaceColor',[.3,.3,.3])

%Environment x and y values
blocks=[0,15,30,45,60,75;... %min x value (-1 to account for player width)
    2,20,34.5,50,63.5,100;... %max x value (+1 to account for player width)
    0,15,30,45,60,75;... %min y values
    100,20.5,35.5,50.5,65.5,80.5]; %max y values

%-----------------------loop----------------------------%
while true
    %check if wall is hit
    
    %check if player hit left or right wall
    if (playerPos(1)<=3 && sign(playerVel(1))==-1) ||(playerPos(1)>=100 && sign(playerVel(1))==1) || ((playerPos(1)>=97&&playerPos(2)<=75) && sign(playerVel(1))==1)
        playerVel(1)=0;
    end
    %check if player hit the roof or is on the floor
    if (playerPos(2)<=2 && sign(playerVel(2))==-1)
        playerVel(2)=0;
        playerPos(2)=2;
    elseif (playerPos(2)>=98 && sign(playerVel(2))==1)
        playerVel(2)=0;
        playerPos(2)=98;
    end
    
    %gravity
    if playerPos(2)>2
        playerVel(2)=playerVel(2)-.1;
    end
    
    %check if ball hits block
    underBlock=(find(((playerPos(1)+1)>=blocks(1,:)) == ((playerPos(1))<=blocks(2,:))));
    besideBlock=(find(((playerPos(2)+1)>=blocks(3,:)) == ((playerPos(2)-1.5)<=blocks(4,:))));
    for pos=underBlock
        if (playerVel(2)<=0) && max(pos==besideBlock)
            playerVel=[playerVel(1);0];
            playerPos(2)=blocks(4,besideBlock(2))+1.5;
        end
    end
    
    %If you reach the end, go to the next level
    if playerPos(1)==100 && playerPos(2)>=77
        lvl2
    end
    
    %move player
    playerPos=playerPos+playerVel;
    set(player,'XData',playerPos(1),'YData',playerPos(2))
    pause(.015)
end
%-----------------------Functions---------------------%
function keyboard(~,event)
global playerVel
global playerPos
switch event.Key
    %sets player velocity(left or right)
    case {'leftarrow','a'}
        playerVel(1)=-0.5; %Move left
    case {'rightarrow','d'}
        playerVel(1)=0.5; %Move Right
    case 'r' %restart
        playerVel=[0,0];
        playerPos=[3,2];
end


%jump condition
if ((event.Key == "space")||(event.Key == "w")||(event.Key == "uparrow")) &&(playerVel(2)==0)
    playerVel(2)=2; %Jump up
elseif ((event.Key == "s")||(event.Key == "downarrow")) && (playerVel(2)~=0)
    playerVel(2)=-5; %Accelerate downwards
elseif ((event.Key == "s")||(event.Key == "downarrow")) && (playerVel(2)==0)&& (playerPos(2)>2) && (playerPos(1)<97) && (playerVel(1)==0)
    playerPos(2)=playerPos(2)-8.01; %Go through block
end
if (event.Key=="downarrow")||(event.Key=="s")
    playerVel(1)=0; %stop moving horizontaly
end
end