function status = Engineering_Proj()
status = 1;  % when player wins
global rodney_done
rodney_done = 0;
clc

a = arduino('/dev/cu.usbmodem1301','Uno');
LG='D12';
LR='D13';



myRoom = escapeRoomEngine('terrain_pack.png',32,32,1,1,8,[255,255,255]);
b1=30;
b2=150;
b3=7;


f1=16;
f2=142;
%f3=
%The code listed below is the background of the map.
background=[b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2;
            b2,b3,b1,b1,b1,b1,b2,b2,b1,b1,b1,b1,b1,b1,b2,b3,b2;
            b2,b2,b2,b1,b2,b1,b1,b1,b1,b2,b2,b1,b2,b2,b2,b1,b2;
            b2,b2,b2,b1,b2,b2,b2,b1,b2,b2,b2,b1,b1,b2,b2,b1,b2;
            b2,b1,b1,b1,b2,b1,b1,b1,b1,b2,b2,b2,b1,b1,b1,b1,b2;
            b2,b1,b2,b2,b2,b1,b2,b2,b1,b2,b1,b1,b1,b2,b1,b2,b2;
            b2,b1,b2,b1,b2,b2,b2,b1,b1,b2,b1,b2,b1,b2,b1,b1,b2;
            b2,b1,b1,b1,b2,b2,b1,b1,b2,b2,b1,b2,b1,b2,b2,b1,b2;
            b2,b2,b2,b1,b2,b2,b2,b1,b1,b1,b1,b2,b1,b1,b2,b2,b2;
            b2,b1,b1,b1,b1,b1,b2,b1,b2,b1,b2,b2,b2,b1,b2,b1,b2;
            b2,b2,b1,b2,b2,b1,b1,b1,b2,b2,b2,b1,b2,b1,b1,b1,b2;
            b2,b2,b1,b1,b2,b1,b2,b2,b2,b1,b2,b1,b2,b2,b2,b1,b2;
            b2,b1,b1,b2,b2,b1,b1,b1,b2,b1,b2,b1,b1,b1,b1,b1,b2;
            b2,b1,b2,b2,b1,b1,b2,b1,b2,b1,b2,b2,b1,b2,b2,b1,b2;
            b2,b1,b1,b2,b1,b2,b2,b1,b1,b1,b1,b1,b1,b1,b2,b1,b2;
            b2,b3,b2,b2,b2,b2,b1,b1,b2,b1,b2,b2,b2,b1,b2,b3,b2;
            b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2,b2];
                

foreground=[f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f2,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;
            f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1,f1;];






drawScene(myRoom,background,foreground);%Add foreground when done with background

max_dim=17;
framerate = 30; % frames per second
in_door=0;
background(end-1, end-1)=7;
wizard_r=9;
wizard_c=9;
blue_guy_pos=142;
foreground(wizard_r,wizard_c)=blue_guy_pos; %initialize the first cell to the little wizard. 

%Character Movement with Key Inputs
while(in_door==0)
    %Get user input
    key_down = getKeyboardInput(myRoom);
    writeDigitalPin(a,LG,0);
    writeDigitalPin(a,LR,0);
    %Get user input every time throught the loop
    %Foreground matrix updated every time through the loop depending on
    %arrow pushed
    if(strcmp(key_down,'rightarrow')==1 && wizard_c<max_dim )
        foreground(wizard_r,wizard_c)=16;
        wizard_c=wizard_c+1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'leftarrow')==1 && wizard_c>1)
        foreground(wizard_r,wizard_c)=16;
        wizard_c=wizard_c-1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'uparrow')==1 && wizard_r>1)
        foreground(wizard_r,wizard_c)=16;
        wizard_r=wizard_r-1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'downarrow')==1 && wizard_r<max_dim)
        foreground(wizard_r,wizard_c)=16;
        wizard_r=wizard_r+1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    end
    %Character Drown Message
    if background(wizard_r,wizard_c) == b2
       foreground(wizard_r,wizard_c)=16;
       msgbox('You Drowned,Try Again!')
       wizard_r=9;
       wizard_c=9;
       foreground(wizard_r,wizard_c)=blue_guy_pos;
       writeDigitalPin(a,LR,1);
      
    end
%Wrong Pathway entered
    if wizard_r==2 && wizard_c==2 || wizard_r==16 && wizard_c==2 || wizard_r==2 && wizard_c==16
        in_door=0;
        drawScene(myRoom, background, foreground)
        msgbox('Wrong Door, Find Another');
        writeDigitalPin(a,LR,1);
        pause(5)
        writeDigitalPin(a,LR,0);
    end

    %Test if wizard is at the door matrix positions
    if(wizard_r==max_dim-1 && wizard_c==max_dim-1)
    in_door=1; % got to door
    drawScene(myRoom, background, foreground)
    msgbox('You win!');
    writeDigitalPin(a,LG,1);
    pause(5)
    writeDigitalPin(a,LG,0);
    
    
    rodney_done = 1;   % signal main script that Rodney Maze is done
end
    
    %This If Statement codes the LEDpins to shine red when the user picks
    %the wrong door,
    

    %Update the matrix image to the screen. 
    drawScene(myRoom, background, foreground)
    
end

