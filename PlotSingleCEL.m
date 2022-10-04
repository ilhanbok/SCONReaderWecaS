% Script to plot a single WeCas .CEL file, assuming known format
% Ilhan Bok, Hai Lab, 2022

target_file = 'M3_.CEL';
axis equal;

fid = fopen(target_file);
tline = fgetl(fid);

l = 0;
seen_dz = 0;
dz = 0;
x = [];
y = [];
while ischar(tline)
    fprintf("%d / %d\n",l,1252232);
    tline = fgetl(fid);
    l  = l+1;
    if seen_dz
        try
            dz = contains(tline,'DZ');
            s1 = erase(tline,'DZ');
            s2 = erase(s1,'TL');
            s3 = erase(s2,' ');
            cpairs = strsplit(s3,';');
            c1 = cpairs{1};
            c2 = cpairs{2};
            c1s = strsplit(c1,',');
            c2s = strsplit(c2,',');
            x(end+1) = str2double(c1s{1});
            x(end+1) = str2double(c2s{1});
            y(end+1) = str2double(c1s{2});
            y(end+1) = str2double(c2s{2});
            if dz % plot previous points, push new stack
                patch(x,y,'red');
                hold on;
                x = [];
                y = [];
            end
            if (mod(l,100) == 0)
                %pause
            end
        catch e % looks like this line is not formatted.
            continue
        end
    else
        seen_dz = contains(tline,'DZ');
    end
end
fclose(fid);