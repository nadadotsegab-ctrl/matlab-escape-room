 function status = Ian_Maze_Room()
status = 0;  % default: not finished
clc; close all;
global ian_done
ian_done = 0;  % initialize
ian_maze = escapeRoomEngine('terrain_pack.png',32,32,1,1,8,[255,255,255]);

%starting variables

%materials labeled for easy replacment

%foreground types
m1=16;
% m2=
%background types
b1=45;
b2=22;
b3=151;
b4=199;
%b5=
%all water types
wx=224;
wy=226;
w2=225;
w3=244;
w4=246;
w5=256;
w6=258;
w7=237;
w8=236;
w9=238;
%start and end (currently using same texture)
s=67;
e=67;
%traps
t1=8;
%tresure
f1=121;
f2=102;
%f2=
%f3=
 
 
 
 
background = [b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1;
              b1,s ,b2,b1,b2,b2,b1,b1,t1,b2,b2,b2,b2,b2,b2,b2,b1,t1,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b1;
              b1,b2,b2,b2,b2,b2,b2,b1,b2,b2,b1,b1,b1,b1,b1,b2,b1,b1,b1,b1,b2,b2,b2,b2,b1,b2,b1,b1,b2,b1;
              b1,b1,b2,b1,b1,b1,b2,b1,b1,b2,b1,b2,b1,t1,b1,b2,b1,b2,b2,b2,b2,b1,b1,b1,b1,b2,b1,b2,b2,b1;
              b1,b1,b2,b1,t1,b1,b2,b1,b2,b2,b2,b2,b1,b2,b1,b2,b1,b2,b1,b1,b1,b1,b2,b2,b2,b2,b1,b2,b1,b1;
              b1,b2,b2,b1,b2,b1,b2,b2,b2,b2,b1,b2,b1,b2,b2,b2,b1,b2,b1,b2,t1,b2,b2,b1,b1,b1,b1,b2,b1,b1;
              b1,b2,b1,b1,b2,b1,b1,b1,b1,b2,b1,b2,b1,b1,b1,b1,b1,b2,b1,b2,b1,b1,b1,b1,b2,b2,b1,b2,b2,b1;
              b1,b2,b1,b2,b2,b2,b2,b2,b1,b2,b1,b2,b2,b2,b2,b2,b1,b2,b1,b2,b1,b2,b2,b1,b2,b1,b1,b1,b2,b1;
              b1,b2,b2,b2,b1,b1,b2,b1,b1,b2,b1,b1,b1,b1,b2,b2,b2,b2,b1,b2,b1,b2,b2,b1,b2,t1,b2,b2,b2,b1;
              b1,b1,b1,b1,b1,b1,b2,b1,b1,b2,b2,b2,b2,b1,b1,b1,b1,b1,b1,b2,b2,b2,b2,b1,b2,b2,b2,b1,b1,b1;
              b1,b2,b2,b2,b2,b1,b2,b1,b1,b1,b2,b1,b2,b1,t1,b2,b2,b2,b2,b2,t1,b2,b2,b1,b2,b1,b1,b1,b2,b1;
              b1,b2,t1,b1,b2,b2,b2,b2,b2,b1,b2,t1,b2,b1,b2,b2,b1,b2,b1,b1,b1,b1,b2,b1,b2,b2,b2,b2,b2,b1;
              b1,b2,b2,b1,b1,b1,b1,b1,b2,b1,b1,b1,b2,b1,b2,b1,b1,b2,b1,b2,b2,b1,b2,b2,b2,b2,b1,b2,b1,b1;
              b1,b2,b2,b2,b2,b2,b1,b2,b2,b2,b2,b1,b2,b1,b2,b1,b2,b2,b1,b1,b2,b1,b2,b1,b1,b1,b1,b2,b2,b1;
              b1,b1,b1,b2,b1,b2,b1,b2,b1,b1,b2,b2,b2,b1,b2,b1,b2,b2,b2,b2,b2,b1,b2,b2,b2,b2,b1,b2,b2,b1;
              b1,b2,b2,b2,b1,b2,b1,b2,b1,b1,b1,b1,b2,b1,b2,b1,b1,b2,b1,b1,b2,b1,b2,b2,t1,b2,b1,b1,b2,b1;
              b1,b2,b1,b1,b1,b2,b1,b2,b1,t1,b2,b1,b1,b1,b2,b2,b1,b2,b2,b1,b2,b1,b1,b1,b2,b2,b2,b1,b2,b1;
              b1,b2,b1,b2,t1,b2,b1,b2,b1,b2,b2,b2,b2,b1,b1,b2,b1,b1,b2,b1,b2,b2,b2,b1,b2,t1,b2,b1,b1,b1;
              b1,b2,b1,b2,b2,b2,b1,b2,b1,b1,b1,b2,b2,b2,b2,b2,b1,t1,b2,b1,b1,b1,b1,b1,b1,b1,b2,b2,b2,b1;
              b1,b2,b1,b1,b2,b1,b1,b2,b2,b2,b1,b2,b1,b2,b1,b1,b1,b2,b1,b1,b2,b2,b2,b2,b2,b1,b1,b1,b2,b1;
              b1,b2,b2,b1,b2,b2,b1,b1,b1,b2,b2,b2,b1,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b1,b2,b2,b2,b1;
              b1,b2,b2,b1,b1,b2,b1,b2,b1,b1,b1,b2,b1,b1,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b1,b2,b1,b1,b1;
              b1,b2,b1,b1,b2,b2,b2,b2,b2,t1,b1,b2,b1,b1,b2,wx,w2,w2,w2,w2,w2,w2,wy,b2,b2,b1,b2,b2,b1,b1;
              b1,b2,b1,b1,b1,b2,b1,b2,b1,b1,b1,b2,b1,b2,b2,w3,b3,b3,b3,b3,b3,b3,w4,b2,b2,b1,b1,t1,f2,b1;
              b1,b2,b2,b2,b1,b2,b1,b2,b1,b2,b1,b2,b1,b1,b2,w3,b3,b3,b3,b3,b3,b3,w4,b2,b2,b2,b1,b1,b1,b1;
              b1,b1,b1,b2,b1,b2,b1,b2,b1,b2,b2,b2,b2,b1,b2,w3,b3,b3,b3,b3,b3,b3,w4,b2,b2,b2,b2,b2,b2,b1;
              b1,b2,b2,b2,b1,b2,b1,b2,b1,b1,b1,b2,b2,b1,b2,w3,b3,b3,b3,b3,b3,b3,w4,b2,b2,t1,b2,b2,b2,b1;
              b1,b2,b1,b1,b1,b2,b1,b2,b2,b2,b1,b2,b2,b1,b2,w3,w8,w7,w7,w7,w7,w9,w4,b2,b2,b2,b2,b2,b2,b1;
              b1,b2,b2,b2,b2,b2,b1,b2,t1,b2,b2,b2,b1,b1,b2,w3,w5,b4,b4,b4,b4,w6,w4,b2,b2,b2,b2,b2,e ,b1;
              b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b1,b4,b4,b4,b4,b4,b4,b1,b1,b1,b1,b1,b1,b1,b1;];
 
 
foreground = [m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,142,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,f1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;
              m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1,m1;];



%first drawing
drawScene(ian_maze,background,foreground)

%boundry for movement
max_dim=31;

%not in door
in_door=0;
%initial player position
player_v=2;
player_h=2;
%player sprite
pos=142;
%draw player sprite at player location
foreground(player_v,player_h)=pos; 
%test zooming(it works)
xlim([-512 1280])
ylim([-512 1280])

%movement loop
while(in_door==0)
%gets user inputs
    key_down = getKeyboardInput(ian_maze);
    %all if/elseif statments work the same with small value changes
    if(strcmp(key_down,'rightarrow')==1 && player_h<max_dim && background(player_v,player_h+1)~=b1)
    %         ^ checks for arrow key.and^. ^checks if player is in bounds.^checks if player will hit wall.
        foreground(player_v,player_h)=m1;
        player_h=player_h+1;
        foreground(player_v,player_h)=pos;
    elseif(strcmp(key_down,'leftarrow')==1 && player_h>1 && background(player_v,player_h-1)~=b1)
        foreground(player_v,player_h)=m1;
        player_h=player_h-1;
        foreground(player_v,player_h)=pos;
    elseif(strcmp(key_down,'uparrow')==1 && player_v>1 && background(player_v-1,player_h)~=b1)
        foreground(player_v,player_h)=m1;
        player_v=player_v-1;
        foreground(player_v,player_h)=pos;
    elseif(strcmp(key_down,'downarrow')==1 && player_v<max_dim && background(player_v+1,player_h)~=b1)
        foreground(player_v,player_h)=m1;
        player_v=player_v+1;
        foreground(player_v,player_h)=pos;
    end
    %test auto tracking. IT WORKS!!!!!
    ylim([(player_v*256-1024) (player_v*256+768)])
    xlim([(player_h*256-1024) (player_h*256+768)])

    %checks if player walked on a trap
    if background(player_v,player_h)==t1
        player_v=2;
        player_h=2;
        disp('A pebble fell down a hole!')
        continue
    end
    if background(player_v,player_h)==f2
        msgbox('HOW DID YOU FIND THIS???')
    end
    %checks if player is at door
if(player_h==max_dim-2 && player_v==max_dim-2)
    drawScene(ian_maze, background, foreground)
    in_door = 1; 
    msgbox('You escaped the endless maze of pebble trapping');
    
    ian_done = 1;  % signal main script
    return;
end
%update screen
drawScene(ian_maze, background, foreground)
end

