function output = MatrixatorAnim(ResX,ResY,TrailLen,colorA,colorB,varargin)
%pause(5)
colorA = rgb2hsv(colorA);
colorB = rgb2hsv(colorB);
step = 1/TrailLen;
easterEggs = cell(nargin,3); % Sidenote: nargin is Number of ARGuments INput
for i=1:(nargin-5)
    easterEggs{i,1} = double(varargin{i});
    easterEggs{i,2} = round(ResX*rand(1));
    while(easterEggs{i,2}+size(easterEggs{i,2},2) >= ResX-10)
        easterEggs{i,2} = round(ResX*rand(1));
    end
    easterEggs{i,3} = round(ResY*rand(1));
end

if exist("Charloader", "File") ~= 2 % Stop if CharLoader is not found
    disp("Error. Cannot find Charloader script.");
    return;
end

characters = CharLoader(); % Loading characters
disp(size(characters{32})) % This should print "0 0"
disp(size(characters{33})) % This should print "9 7"
ShadowMap = rand(ResY,ResX);
[~,Index] = max(ShadowMap);
Index = Index - TrailLen*ceil(Index./TrailLen);

lineStart = Index*step-step;
lineEnd   = lineStart + step*(ResY-1);

for x = 1:ResX
    ShadowMap(:,x) = (lineStart(x):step:lineEnd(x))';
end
ShadowMap = ShadowMap-floor(ShadowMap);

letters = round((126-33)*rand(ResY,ResX))+33;

for i=1:(nargin-5)
    letters(easterEggs{i,3},easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2)) = easterEggs{i,1};
end

CharMap = [characters{letters(1,:)}];
for y = 2:ResY
    CharMap = [CharMap;[characters{letters(y,:)}]];
end



H = rand(ResY,ResX)*(colorB(1)-colorA(1))+colorA(1);
S = rand(ResY,ResX)*(colorB(2)-colorA(2))+colorA(2);
V = kron(ShadowMap,ones(9,7));
V = V.*CharMap;


output(:,:,1) = kron(H,ones(9,7));
output(:,:,2) = kron(S,ones(9,7));
output(:,:,3) = V;

output = hsv2rgb(output);
imshow(output)
pause(0.1);

for frame = 2:60
    lineStart = Index*step-frame*step;
    lineEnd   = lineStart + step*(ResY-1);
    
    for x = 1:ResX
        ShadowMap(:,x) = (lineStart(x):step:lineEnd(x))';
    end
    ShadowMap = ShadowMap-floor(ShadowMap);
    
    letters(2:ResY,:) = letters(1:ResY-1,:);
    letters(1,:) = round((126-33)*rand(1,ResX))+33;
    
    for i=1:(nargin-5)
        letters(mod(easterEggs{i,3}+frame,ResY)+1,easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2)) = easterEggs{i,1};
        ShadowMap(mod(easterEggs{i,3}+frame,ResY)+1,easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2)) = min(ShadowMap(mod(easterEggs{i,3}+frame,ResY)+1,easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2))+0.3,1);
    end
    
    CharMap = [characters{letters(1,:)}];
    for y = 2:ResY
        CharMap = [CharMap;[characters{letters(y,:)}]];
    end
    
    H(2:ResY,:) = H(1:ResY-1,:);
    H(1,:) = rand(1,ResX)*(colorB(1)-colorA(1))+colorA(1);
    S(2:ResY,:) = S(1:ResY-1,:);
    S(1,:) = rand(1,ResX)*(colorB(2)-colorA(2))+colorA(2);
    V = kron(ShadowMap,ones(9,7));
    V = V.*CharMap;
    
    output(:,:,1) = kron(H,ones(9,7));
    output(:,:,2) = kron(S,ones(9,7));
    output(:,:,3) = V;
    
    output = hsv2rgb(output);
    subplot(1,1,1);
    imshow(output)
    if frame < 10
        name = "Frame_0"+frame+".png";
    else
        name = "Frame_"+frame+".png";
    end
    imwrite(output,name);
    pause(0.1);
end

for i=1:(nargin-5)
    disp("x: "+easterEggs{i,2})
    disp("y: "+easterEggs{i,3})
    H(mod(easterEggs{i,3}+frame,ResY)+1,easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2)) = 0;
end

%pause(10);
output(:,:,1) = kron(H,ones(9,7));
    output(:,:,2) = kron(S,ones(9,7));
    output(:,:,3) = V;
    
    output = hsv2rgb(output);
    subplot(1,1,1);
    imshow(output)
end
