% Script to plot a single WeCas .CEL file, assuming known format
% Ilhan Bok, Hai Lab, 2022
function [] = PlotSingleCEL_Square(target_file, SCON_ref)
    % REad the refernce scon and save displacement
    fid = fopen(SCON_ref);
    tline = fgetl(fid);
    dx = 0;
    dy = 0;
    while ischar(tline)
        if contains(tline,'PC')
            str1 = strsplit(tline,',');
            dx = str2double(str1{3});
            dy = str2double(str1{4});
            break
        end
        tline = fgetl(fid);
    end
    if dx > 13.5
        dy = 0;
    end
    bd = 20; % in microns ('buffer distance')

    bd = bd / 1000.0; % convert to millimeters
    %target_file = 'M3_.CEL';
    axis equal;
    
    fid = fopen(target_file);
    tline = fgetl(fid);
    
    l = 0;
    seen_ps = 0;
    ps = 0;
    prev_x = [];
    prev_y = [];
    x = [];
    y = [];
    while ischar(tline)
        if (mod(l,1000) == 0)
            fprintf("%d / %d\n",l,1252232);
        end
        tline = fgetl(fid);
        l  = l+1;
        if seen_ps
            try
                ps = contains(tline,'PS');
                cpairs = strsplit(tline,'; TL');
                s1 = cpairs{2};
                s1 = erase(s1,';');
                c1s = strsplit(s1,',');
                x(end+1) = str2double(c1s{1})+dx;
                x(end+1) = str2double(c1s{1})+0.0002+dx;
                y(end+1) = str2double(c1s{2})+dy;
                y(end+1) = str2double(c1s{2})+0.0002+dy;
                if ps % plot previous points, push new stack
                    % ... only if further than buffer distance
                    if norm([mean(prev_x) mean(prev_y)] - [mean(x) mean(y)]) > bd ...
                            || (isempty(prev_x) && isempty(prev_y))
                        patch(x,y,'red');
                        hold on;
                        prev_x = x;
                        prev_y = y;
                        x = [];
                        y = [];
                    end
                end
                if (mod(l,100) == 0)
                    %pause
                end
            catch e % looks like this line is not formatted.
                continue
            end
        else
            seen_ps = contains(tline,'PS');
        end
    end
    fclose(fid);
end