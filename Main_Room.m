clc; clear;

% Run Jonathan first
global johnatan_done
johnatan_done = 0;   % initialize

Example_KeyboardInput_Dungeon();  % Jonathan game

% Wait until Jonathan finishes
while johnatan_done == 0
    pause(0.1);
end

% Run Ian Maze Room
global ian_done
ian_done = 0;   % initialize

Ian_Maze_Room();  % start Ian's game

% Wait until Ian finishes
while ian_done == 0
    pause(0.1);
end

% Optional: Run Rodney Maze after Hide-and-Seek
global rodney_done
rodney_done = 0;  % initialize


Engineering_Proj();  % start Rodney Maze

% Wait until Rodney finishes
while rodney_done == 0
    pause(0.1);
end
% Run Hide-and-Seek
global hide_and_seek_game_done
hide_and_seek_game_done = 0;  % initialize

hide_and_seek_game();  % start Hide-and-Seek automatically

% Wait until Hide-and-Seek finishes
while hide_and_seek_game_done == 0
    pause(0.1);
end


