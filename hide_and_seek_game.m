function status = hide_and_seek_game()
status = 0; % default
global hide_and_seek_game_done
clc;

% Maze setup
maze = [
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; % 1 = wall
1 0 0 0 1 0 0 0 1 0 0 0 0 4 1; % 0 = empty space 
1 0 1 5 1 0 1 2 1 0 1 0 1 0 1; 
1 0 1 0 0 0 0 0 1 0 1 0 0 6 1;
1 0 1 1 1 0 1 0 1 0 1 1 1 0 1;
1 0 0 0 0 0 1 0 0 0 0 0 1 0 1;
1 1 1 1 1 1 1 1 1 1 1 0 1 0 1;
1 1 0 0 0 2 0 0 1 0 0 0 1 0 1;
1 1 0 1 1 1 1 0 1 0 1 1 1 0 1;
1 1 0 1 0 0 1 0 0 0 1 0 0 0 1;
1 0 0 1 0 1 1 1 1 0 1 0 1 0 1;
1 0 1 0 0 0 0 0 1 0 0 0 1 3 1;
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
];

% Place invisibility trigger in the maze (e.g., at row 2, col 12)
maze(2,12) = 7; % 7 = invisibility trigger

% Game variables
playerPos = [2,2]; % starting position of player 
enemyPos = [6,13;2,11;5,6]; % enemy starting position
enemyDir = [0 -1;1 0;0 1]; % number of enemies
numEnemies = size(enemyPos,1);
pauseTime = 0.2;
elapsedTime = 0; score = 0; % track game time
invincible = false; speedBoost = false; invTime = 0; speedTime = 0;
hasKey = false; puzzleSolved = false;
invisAsked = false; % To check if question was already asked

% Joystick setup 
dataHasArduino = false; % default no adruino
try
    a = arduino('/dev/cu.usbmodem1301','Uno'); 
    SW_pin = 'D2';
    X_pin  = 'A0';
    Y_pin  = 'A1';
    % configurePin for digital input (pull-up not directly available for all boards)
    configurePin(a, SW_pin, 'DigitalInput');
    dataHasArduino = true;
catch ME % learned this language on Co-Pilot
    warning('Arduino not available or failed to initialize. Using keyboard only. (%s)', ME.message);
    a = [];
    SW_pin = ''; X_pin = ''; Y_pin = ''; %if failed disable adruino
end

%Figure set up
hFig = figure('Name','Hide-and-Seek Game','NumberTitle','off','KeyPressFcn',@keyPress, ...
    'CloseRequestFcn',@onClose); % create figure window with key and close call backs 
hAx = axes('Parent',hFig); % create axes inside figure
axis(hAx,'equal'); hold(hAx,'on'); 
xlim(hAx,[0 size(maze,2)]); ylim(hAx,[0 size(maze,1)]); % set y axis limits on mae height
set(hAx,'XTick',[],'YTick',[],'YDir','reverse');

% Store all game data 
data.maze = maze; data.playerPos = playerPos; data.enemyPos = enemyPos; % current position of all enemeies 
data.enemyDir = enemyDir; data.numEnemies = numEnemies; data.elapsedTime = elapsedTime; %how much time has passed
data.pauseTime = pauseTime; data.gameOver = false; data.score = score;
data.invincible = invincible; data.speedBoost = speedBoost; data.invTime = invTime; data.speedTime = speedTime; %remining time for speed boost
data.hAx = hAx; data.hasKey = hasKey; data.puzzleSolved = puzzleSolved; % wether puzzle has been solved
data.invisAsked = invisAsked; % invinsibility question has been asked
data.useArduino = dataHasArduino; % whether adruino joystiv being used or no 
data.arduino = a; %adruino object
data.SW_pin = SW_pin; %switch button on adruin
data.X_pin = X_pin; % x axis analong pin on adruino
data.Y_pin = Y_pin; % y axis analong pin on adruino

guidata(hFig,data); % save data figure for callbacks

drawMaze(data); % draw inital maze

% Timer
t = timer('ExecutionMode','fixedSpacing','Period',pauseTime,'TimerFcn',@updateGame);
start(t);

% Key press on they keyboard 
function keyPress(~,event) 
    data = guidata(hFig); %retrive data
    if data.gameOver, return; end % do nothing if the game is over
    move = [0 0]; %initalie move vector 
    switch event.Key
        case 'uparrow', move = [-1 0]; %move up
        case 'downarrow', move = [1 0]; %move down
        case 'leftarrow', move = [0 -1];% move left 
        case 'rightarrow', move = [0 1]; %move right 
        case 'space'      %attack enemy (had problem figuring this out not working)
            data = attackEnemy(data);
    end
    if any(move) %if any movement 
        newPos = data.playerPos + move; %calcuate new position
        if newPos(1)>=1 && newPos(1)<=size(data.maze,1) && newPos(2)>=1 && newPos(2)<=size(data.maze,2)
            if data.maze(newPos(1),newPos(2)) ~= 1
                data.playerPos = newPos;
                data = processCell(data,newPos); %process cell effect (hanles player movement)
            end
        end
    end
    guidata(hFig,data);
end

%  Process cell actions 
function data = processCell(data,pos)
    cellVal = data.maze(pos(1),pos(2)); % get value  of current cell
    switch cellVal
        case 3 % Hiding
            data.score = data.score + 5; data.maze(pos(1),pos(2)) = 0; beep;
        case 4 % Power-up
            data.invincible = true; data.invTime = 5; % 5 sec invincible
            data.speedBoost = true; data.speedTime = 5; % 5 sec speed
            data.maze(pos(1),pos(2)) = 0; beep;
        case 6 % Key
            data.hasKey = true; data.maze(pos(1),pos(2)) = 0;
            msgbox('You collected the key!','Key Collected');
        case 5 % Puzzle
            if ~data.hasKey
                msgbox('You need the key to solve this puzzle!','No Key');
            elseif ~data.puzzleSolved
                % Puzzle question
                answer = inputdlg('What is 5 + 3?','Puzzle');
                if isempty(answer)
                    msgbox('No answer given!','Failed');
                elseif str2double(answer{1}) == 8
                    data.score = data.score + 10; % correct answer
                    data.puzzleSolved = true;
                    data.maze(pos(1),pos(2)) = 0;
                    msgbox('Correct! Puzzle solved!','Success');
                else
                    data.gameOver = true; % wrong answer ends game
                    msgbox('Wrong answer! Game Over!','Failed');
                end
            end
        case 7 % Invisibility trigger
            if ~data.invisAsked
                msgbox('Come here if you want invisibility for 3 seconds!','Invisibility');
                % Ask question
                question = 'Which number is even?'; % ask question get's it right invicible for few secs 
                options = {'1','3','4','7'};
                [answerIndex,tf] = listdlg('PromptString',question,'SelectionMode','single','ListString',options);
                if tf && answerIndex == 3  % Correct answer is '4'
                    data.invincible = true;
                    data.invTime = 3;
                    msgbox('Correct! You are invisible for 3 seconds.','Invisibility');
                else
                    msgbox('No invisibility this time.','Info');
                end
                data.invisAsked = true; % Only ask once
                data.maze(pos(1),pos(2)) = 0; % Remove the trigger from the maze
            end
    end
end

% Attack enemies (if not facing player) having problem with figuring out
% this (got help from co-pilot figuring it out)
    function data = attackEnemy(data) %player position 
    player = data.playerPos;
    for k = 1:data.numEnemies
        enemy = data.enemyPos(k,:);
        dir = data.enemyDir(k,:);
        if enemy(1) < 1, continue; end  % skip "dead" enemies

        % Check if player is directly adjacent vertically or horizontally
        rowDiff = player(1) - enemy(1);
        colDiff = player(2) - enemy(2);

        if abs(rowDiff) + abs(colDiff) == 1  % adjacent
            attackDir = [rowDiff, colDiff]; % direction from enemy to player
            % Check if enemy is NOT facing the player
            if ~isequal(attackDir, dir)
                data.enemyPos(k,:) = [-100 -100]; % kill enemy
                data.score = data.score + 25; beep;
                msgbox('Enemy killed!','Sword');
            else
                msgbox('Enemy is facing you! Move behind or to the side.','Warning');
            end
        end
    end
end
% Sneak kill when player is directly behind an enemy and presses down
% the code at the top and this is supposed to do the same thing but i could
% not figure out what is wrong with the top one so i added this one 
function data = sneakKillIfBehind(data)
    player = data.playerPos;
    for k = 1:data.numEnemies
        enemy = data.enemyPos(k,:);
        dir = data.enemyDir(k,:);
        if enemy(1) < 1, continue; end  % dead/skipped enemy

        % Check adjacency
        rowDiff = player(1) - enemy(1);
        colDiff = player(2) - enemy(2);
        if abs(rowDiff) + abs(colDiff) == 1  % adjacent
            attackDir = [rowDiff, colDiff];   % direction from enemy to player
            % If player is behind the enemy (attackDir == -dir) then sneak kill:
            if isequal(attackDir, -dir)
                data.enemyPos(k,:) = [-100 -100]; % kill enemy
                data.score = data.score + 25;
                try beep; catch, end
                msgbox('Sneak kill from behind!','Stealth');
            end
        end
    end
end


% Update game function
function updateGame(~,~)
    data = guidata(hFig); % retrive all game data stored in figure 
    if data.gameOver %check if game over
        try stop(t); catch, end %stop timer
        try delete(t); catch, end
        return; %exit game 
    end

    % JOYSTICK INPUT 
    moveFromJoystick = [0 0];
    if data.useArduino && ~isempty(data.arduino)
        try
            xVal = readVoltage(data.arduino, data.X_pin);
            yVal = readVoltage(data.arduino, data.Y_pin);
            sw   = readDigitalPin(data.arduino, data.SW_pin);
            % thresholds (adjust if needed)
            low = 1.5; high = 3.5;

            if yVal < low,  moveFromJoystick = [-1 0]; end   % up
            if yVal > high, moveFromJoystick = [1 0];  end   % down
            if xVal < low,  moveFromJoystick = [0 -1]; end   % left
            if xVal > high, moveFromJoystick = [0 1];  end   % right

            if sw == 0
                data = attackEnemy(data); % joystick button pressed (active low)
            end
        catch ME
            % reading failed; disable Arduino use to avoid repeated errors
            warning('Joystick read failed, disabling Arduino: %s', ME.message);
            data.useArduino = false;
            data.arduino = [];
        end
    end

    % Process joystick movement (if any)
    if any(moveFromJoystick)
        newPos = data.playerPos + moveFromJoystick; %calculate the new position based on joystick input
        if newPos(1)>=1 && newPos(1)<=size(data.maze,1) && ... %check if the new position is inside the maze boundaries
           newPos(2)>=1 && newPos(2)<=size(data.maze,2) && ...
           data.maze(newPos(1),newPos(2)) ~= 1

            data.playerPos = newPos; %update player position
            data = processCell(data,newPos); %process any effects like new cell power up puzzel or key
        end
    end

    % Timers (invincibility / speed)
    if data.invincible 
        data.invTime = data.invTime - data.pauseTime; %reduce time of invincibility
        if data.invTime <= 0, data.invincible = false; end
    end
    if data.speedBoost
        data.speedTime = data.speedTime - data.pauseTime; %reduce the remmaining speed boost bt the time between updates 
        if data.speedTime <= 0, data.speedBoost = false; end
    end

    % Move enemies
    for k = 1:data.numEnemies
        if data.enemyPos(k,1) > 0 %check if enemy is dead
            newPos = moveEnemyPatrol(data.enemyPos(k,:), data.enemyDir(k,:), data.maze);
            if isequal(newPos, data.playerPos) && ~data.invincible
                data.gameOver = true; % player loses
                drawMaze(data);
                title(data.hAx,['Enemy caught you! Game Over! Score: ', num2str(data.score)]); %show game over message if enemy killed the player 
                guidata(hFig, data);
                try stop(t); catch, end %stop timer 
                try delete(t); catch, end
                return; %exit if game over 
            end
            data.enemyPos(k,:) = newPos; % update enemy position
            data.enemyDir(k,:) = randDir();
        end
    end

    % Check win: require key collected AND puzzle solved
    if data.hasKey && data.puzzleSolved
        data.gameOver = true; %end game
        drawMaze(data);
        title(data.hAx,['You solved the puzzle and won! Score: ',num2str(data.score)]);
        guidata(hFig, data); %save updated game data
        try stop(t); catch, end
        try delete(t); catch, end
        hide_and_seek_game_done = 1
        return;

    end

    drawMaze(data);
    title(data.hAx,['Time: ',num2str(floor(data.elapsedTime)),' sec | Score: ',num2str(data.score)]);
    data.elapsedTime = data.elapsedTime + data.pauseTime;
    guidata(hFig,data);
end

%  Draw maze (Co-Pilot helped come out with the idea and starting the code)
function drawMaze(data)
    cla(data.hAx); hold(data.hAx,'on'); [rows,cols]=size(data.maze);
    for r=1:rows % loop through each cell in maze
        for c=1:cols
            switch data.maze(r,c)
                case 1, rectangle(data.hAx,'Position',[c-1,r-1,1,1],'FaceColor',[0.5 0.5 0.5]); % wall gray square 
                case 2, rectangle(data.hAx,'Position',[c-1,r-1,1,1],'FaceColor',[0.8 0.6 0.4]); % floor browinish square
                case 3, rectangle(data.hAx,'Position',[c-1,r-1,1,1],'FaceColor','g'); % hiding spot
                case 4, rectangle(data.hAx,'Position',[c-1,r-1,1,1],'FaceColor','y'); % power up yellow square (to be invincible)
                case 5, rectangle(data.hAx,'Position',[c-1,r-1,1,1],'FaceColor','c'); % key red square
                case 6, rectangle(data.hAx,'Position',[c-1,r-1,1,1],'FaceColor','r');
                case 7
                    rectangle(data.hAx,'Position',[c-1,r-1,1,1],'FaceColor','m'); % magenta square
                    text(c-0.5, r-0.5, 'Come here!', 'HorizontalAlignment','center', ...
                        'FontSize',6,'Color','k'); % label for invisibility
            end
        end
    end

    % Player
    x = data.playerPos(2)-0.5; y = data.playerPos(1)-0.5;
    if data.invincible %check if player has invinciblity power
        plot(data.hAx,x,y,'yo','MarkerFaceColor','y','MarkerSize',20); % draw player as a yellow circle if invincible
    else
        plot(data.hAx,x,y,'ro','MarkerFaceColor','r','MarkerSize',20); % draw player as a red circle
    end

    % Enemies
    for k=1:data.numEnemies
        ex=data.enemyPos(k,2)-0.5; ey=data.enemyPos(k,1)-0.5;
        if ex<0 || ey<0, continue; end
        rectangle(data.hAx,'Position',[ex-0.3,ey-0.3,0.6,0.6],'FaceColor','b'); % draw the enemy as a blue rectngle 
        dirVec=data.enemyDir(k,:)*0.8; 
        plot(data.hAx,[ex ex+dirVec(2)],[ey ey+dirVec(1)],'r-','LineWidth',2); % draw a red line showing enemy's facing direction
    end

    axis(data.hAx,'equal'); xlim(data.hAx,[0 cols]); ylim(data.hAx,[0 rows]);
    set(data.hAx,'XTick',[],'YTick',[]); hold(data.hAx,'off'); drawnow;
end

% Enemy movement, gives enemy random movement (I used co-pilot to come
% witht the idea)
function newPos = moveEnemyPatrol(enemy,dir,maze)
    temp = enemy + dir;
    r = max(min(temp(1),size(maze,1)),1);
    c = max(min(temp(2),size(maze,2)),1);
    if maze(r,c) ~= 1
        newPos = temp;
    else
        newPos = enemy;
    end
end

function d = randDir()
    dirs=[-1 0;1 0;0 -1;0 1]; d=dirs(randi(4),:);
end

%Figure close callback to clean up timer and Arduino
% This function safely stops the timer, disconnects the Arduino if used,
% and closes the game window so there are no leftover running processes or
% hardware connections when user exits the game.
% AI assistance was used for creating this cleanup logic
function onClose(~,~)
    data = guidata(hFig);
    % stop & delete timer 
    try
        stop(t);
        delete(t);
    catch
    end
    % clear Arduino if used
    if isfield(data,'arduino') && ~isempty(data.arduino)
        try
            clear data.arduino;
        catch
        end
    end
    delete(hFig); % close the game 
end

end
