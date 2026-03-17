function [] = Example_KeyboardInput_Dungeon()
global johnatan_done
% EXAMPLE_KEYBOARDINPUT_DUNGEON
% Keyboard demo using Dungeon.png tileset. Player must solve math problems
% to remove barriers and progress.

   
    rng('shuffle');

    % --- initialize room using Dungeon tileset ---
    myRoom = escapeRoomEngine('terrain_pack.png',32,32,1,1,8);
    allpics = reshape(1:400, [20,20])';

    % tile indices
    floorTile   = 22;        % walkable floor
    wallTile    = 45;       % wall
    barrierTile = 122;        % barrier that requires math problem
    doorTile    = 6;  % door
    playerTile  = 7*20+2;   % player

    % background layout (3 rows x 20 cols)
    background = [wallTile*ones(1,20); ...
                  floorTile*ones(1,20); ...
                  wallTile*ones(1,20)];

    % Place the door at the bottom-right
    background(3,20) = doorTile;

    % draw initial scene
    drawScene(myRoom, background);

    % --- foreground and player initialization ---
    [nRows, nCols] = size(background);
    foreground = 16 * ones(nRows, nCols);

    % Place barriers along the second row
    foreground(2,5)  = barrierTile;
    foreground(2,10) = barrierTile;
    foreground(2,15) = barrierTile;

    player_r = 2; player_c = 1; % start position
    foreground(player_r, player_c) = playerTile;

    drawScene(myRoom, background, foreground);

    % --- loop control ---
    in_door = false;

    while ~in_door && ishandle(gcf)
        key_down = getKeyboardInput(myRoom);

        if isempty(key_down)
            pause(0.01); continue;
        end

        % clear current player cell
        foreground(player_r, player_c) = floorTile;
        new_r = player_r; new_c = player_c;

        % Movement: arrow keys or WASD
        switch lower(key_down)
            case {'rightarrow','d'}
                if player_c < nCols, new_c = player_c + 1; end
            case {'leftarrow','a'}
                if player_c > 1, new_c = player_c - 1; end
            case {'uparrow','w'}
                if player_r > 1, new_r = player_r - 1; end
            case {'downarrow','s'}
                if player_r < nRows, new_r = player_r + 1; end
            case 'q'
                break;
        end

        % Check target tile
        targetTile = foreground(new_r, new_c);

        if targetTile == wallTile
            % Can't move into walls
            new_r = player_r; new_c = player_c;

        elseif targetTile == barrierTile
            % Must solve math problem to remove barrier
            passed = false;
            while ~passed
                [exprStr, correctVal] = makeRandomProblem();
                answer = inputdlg({['Solve: ' exprStr]}, 'Barrier Challenge', [1 40]);

                if isempty(answer)
                    % Cancelled: stay put
                    new_r = player_r; new_c = player_c;
                    break;
                end

                userVal = str2double(strtrim(answer{1}));
                if isnan(userVal)
                    uiwait(msgbox('Invalid input. Enter a number.','Error','modal'));
                    continue;
                end

                if abs(userVal - correctVal) < 1e-6
                    uiwait(msgbox('Correct! Barrier removed!','Success','modal'));
                    background(new_r, new_c) = floorTile; % remove barrier
                    passed = true;
                else
                    uiwait(msgbox('Incorrect. Try again.','Try again','modal'));
                end
            end
        end

        % update player position
        player_r = new_r; player_c = new_c;
        foreground(player_r, player_c) = playerTile;

        % redraw scene
        drawScene(myRoom, background, foreground);

        % Check if player reached door
        if background(player_r, player_c) == doorTile
    in_door = true;
    msgbox('You win!');
    johnatan_done = 1;  % mark the game as completed

    % Close the figure immediately so Main_Room can continue
    if ishandle(myRoom)
        close(myRoom);
    end

    return;  % exit the function and return to Main_Room.m
end

        pause(0.01);
    end
end

% --- helper: generate a random math problem ---
function [exprStr, value] = makeRandomProblem()
    ops = {'+' , '-' , '*' , '/'};
    op = ops{randi(numel(ops))};
    switch op
        case '+'
            a = randi([0,20]); b = randi([0,20]); value = a + b;
        case '-'
            a = randi([0,20]); b = randi([0,a]); value = a - b;
        case '*'
            a = randi([0,12]); b = randi([0,12]); value = a * b;
        case '/'
            b = randi([1,12]); q = randi([0,12]); a = b*q; value = a / b;
    end
    exprStr = sprintf('%d %s %d = ?', a, op, b);
end
