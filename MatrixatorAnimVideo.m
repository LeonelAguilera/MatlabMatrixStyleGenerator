function output = MatrixatorAnimVideo(ResX,ResY,TrailLen,colorA,colorB,varargin)
% pause(5)
colorA = rgb2hsv(colorA);
colorB = rgb2hsv(colorB);
step = 1/TrailLen;
coordinates = meshgrid(1:ResY,1:ResX)';
easterEggs = cell(nargin,3);
for i=1:(nargin-5)
    easterEggs{i,1} = double(varargin{i});
    easterEggs{i,2} = round(ResX*rand(1));
    while(easterEggs{i,2}+size(easterEggs{i,2},2) >= ResX-10)
        easterEggs{i,2} = round(ResX*rand(1));
    end
    easterEggs{i,3} = round(ResY*rand(1));
end

characters = CharLoader();

% logo = 1-imresize(double(imread("Logo.png"))./255,[9*ResY,7*ResX]);
logo = (double(imread("Logo.png"))./255);
logo = logo(:,:,1);
internet = double(imread("Internet.png"))./255;
internet = internet(:,:,1);
desde = double(imread("Desde.png"))./255;
desde = desde(:,:,1);
abajo = double(imread("Abajo.png"))./255;
abajo = abajo(:,:,1);

whitemap = ones(size(logo));

disp(size(characters{32}))
disp(size(characters{33}))
ShadowMap = rand(ResY,ResX);
[~,Index] = max(ShadowMap);
Index = Index - TrailLen*ceil(Index./TrailLen);
disp(Index);
% disp(min(max(Index+1,1),ResY))
% disp(min(max(Index+2,1),ResY))
% disp(min(max(Index+10,1),ResY))
lineStart = Index*step-step;
lineEnd   = lineStart + step*(ResY-1);

for x = 1:ResX
    ShadowMap(:,x) = (lineStart(x):step:lineEnd(x))';
end
ShadowMap = ShadowMap-floor(ShadowMap);
ShadowMap(coordinates>Index+1) = 0;

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
V = imresize(V,size(logo));

V = V.*logo;

output(:,:,1) = imresize(kron(H,ones(9,7)),size(logo));
output(:,:,2) = imresize(kron(S,ones(9,7)),size(logo));
output(:,:,3) = V;

% output(:,:,1) = kron(H,ones(9,7));
% output(:,:,2) = kron(S,ones(9,7));
% output(:,:,3) = V;

output = hsv2rgb(output);
imshow(output)
pause(0.1);
imwrite(output,"Frame_0001.png");

for frame = 2:200
    lineStart = Index*step-frame*step;
    lineEnd   = lineStart + step*(ResY-1);
    
    for x = 1:ResX
        ShadowMap(:,x) = (lineStart(x):step:lineEnd(x))';
    end
    ShadowMap = ShadowMap-floor(ShadowMap);
    ShadowMap(coordinates>(Index+frame)) = 0;
    
    
    letters(2:ResY,:) = letters(1:ResY-1,:);
    letters(1,:) = round((126-33)*rand(1,ResX))+33;
    
    for i=1:(nargin-5)
        letters(mod(easterEggs{i,3}+frame,ResY)+1,easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2)) = easterEggs{i,1};
        ShadowMap(mod(easterEggs{i,3}+frame,ResY)+1,easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2)) = min(ShadowMap(mod(easterEggs{i,3}+frame,ResY)+1,easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2)),1);
    end
    
    %     ShadowMap = ShadowMap.*logo;
    
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
    
    %     H = imresize(H,size(logo));
    %     S = imresize(S,size(logo));
    V = imresize(V,size(logo));
    
%     V = V.*logo;
    
    pre = zeros(size(V));
    pre(V>0.5)=1;
    whitemap = max(whitemap - pre.*(1-logo),0);
%     subplot(1,2,2);
%     imshow(whitemap)
    
%     V = V.*logo;
    V = min(V+(1-logo).*(1-whitemap),1);
    
    output(:,:,1) = imresize(kron(H,ones(9,7)),size(logo)).*whitemap+(220/360).*(1-whitemap);
    output(:,:,2) = imresize(kron(S,ones(9,7)),size(logo));%.*whitemap;
    output(:,:,3) = V;
    
    output = hsv2rgb(output);
    subplot(1,1,1);
    imshow(output)
    if frame < 10
        name = "Frame_000"+frame+".png";
    elseif frame < 100
        name = "Frame_00"+frame+".png";
    elseif frame < 1000
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

pause(10);
output(:,:,1) = kron(H,ones(9,7));
output(:,:,2) = kron(S,ones(9,7));
output(:,:,3) = V;

output = hsv2rgb(output);
subplot(1,1,1);
imshow(output)
end
