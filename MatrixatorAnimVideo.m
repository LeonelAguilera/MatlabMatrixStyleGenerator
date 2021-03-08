function output = MatrixatorAnimVideo(ResX,ResY,TrailLen,colorA,colorB,nFrames,varargin)
nVarargin = nargin - 6; % Dimension of varargin.
                        % Change so that for a given number of arguments, nVarargin has the correct value.
export_folder = "Rendered_imgs\";
% Checks:
if exist("Charloader", "File") ~= 2 % Stop if CharLoader is not found
    disp("Error. Cannot find Charloader script.");
    return;
end
if nFrames>999 % Stop if user wants too many frames
    disp("Error. Name parsing for frames higher than 999 isn't currently supported");
    return;
end
if (exist(export_folder, "dir")~=7)
    disp("Message. 'Rendered_imgs' isn't in current folder. Creatinf folder...");
    [status, msg] = mkdir("Rendered_imgs");
    if status==0 % This means folder couldn't be created
        disp("Error. Cannot create folder.");
        disp(msg);
        return;
    end
    disp(msg);
end

% End of checks

% pause(5)
%{
Por si no es evidente, este código ha sido hecho para cumplir con su
objetivo de forma fácil y rápida, mantenerlo será horrible, más ineficiente
no puede ser y no está comentado ni el nombre, a lo mejor esto cambia, pero
no tiene pinta
%}
colorA = rgb2hsv(colorA);
colorB = rgb2hsv(colorB);
step = 1/TrailLen;
coordinates = meshgrid(1:ResY,1:ResX)';
easterEggs = cell(nargin,3);
for i=1:(nVarargin)
    easterEggs{i,1} = double(varargin{i});
    easterEggs{i,2} = ceil(ResX*rand(1));
    while(easterEggs{i,2}+size(easterEggs{i,2},2) >= ResX-10)
        easterEggs{i,2} = ceil(ResX*rand(1));
    end
    easterEggs{i,3} = ceil(ResY*rand(1));
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

% Mentioned logo, probably copy for other words
whitemap = ones(size(logo));



ShadowMap = rand(ResY,ResX);
[~,Index] = max(ShadowMap);
Index = Index - TrailLen*ceil(Index./TrailLen);

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

for i=1:(nVarargin)
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
V = imresize(V,size(logo)); % Mentioned logo, probably copy for other words

V = V.*logo;

output(:,:,1) = imresize(kron(H,ones(9,7)),size(logo),'nearest');
output(:,:,2) = imresize(kron(S,ones(9,7)),size(logo),'nearest');
output(:,:,3) = V;

% output(:,:,1) = kron(H,ones(9,7));
% output(:,:,2) = kron(S,ones(9,7));
% output(:,:,3) = V;

output = hsv2rgb(output);
imshow(output)
pause(0.1);


for frame = 2:nFrames
    lineStart = Index*step-frame*step;
    lineEnd   = lineStart + step*(ResY-1);
    
    for x = 1:ResX
        ShadowMap(:,x) = (lineStart(x):step:lineEnd(x))';
    end
    ShadowMap = ShadowMap-floor(ShadowMap);
    ShadowMap(coordinates>(Index+frame)) = 0;
    
    
    letters(2:ResY,:) = letters(1:ResY-1,:);
    letters(1,:) = round((126-33)*rand(1,ResX))+33;
    
    for i=1:(nVarargin)
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
    V = imresize(V,size(logo)); % Mentioned logo, probably copy for other words
    
%     V = V.*logo;
    
    pre = zeros(size(V));
    pre(V>0)=1;
    whitemap = max(whitemap - pre.*(1-logo),0); % Mentioned logo, probably copy for other words
%     subplot(1,2,2);
%     imshow(whitemap)
    
%     V = V.*logo;
    V = min(V+(1-logo).*(1-whitemap),1); % Mentioned logo, probably copy for other words
    
    output(:,:,1) = imresize(kron(H,ones(9,7)),size(logo),'nearest');%.*whitemap+(220/360).*(1-whitemap);
    output(:,:,2) = imresize(kron(S,ones(9,7)),size(logo),'nearest');%.*(1-whitemap);
    output(:,:,3) = V;
    
    output = hsv2rgb(output);
    subplot(1,1,1);
    imshow(output)
    
    % Creating frames with a consistent name, ordered in directory
    if frame < 10
        name = "Frame_000"+frame+".png";
    elseif frame < 100
        name = "Frame_00"+frame+".png";
    elseif frame < 1000
        name = "Frame_0"+frame+".png";
    else
        name = "Frame_"+frame+".png";
    end
    imwrite(output,export_folder+name);
    pause(0.1);
end

for frame = 73:(72+48) %72+48=120
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
    V = imresize(V,size(internet));
    
    %     V = V.*logo;
    
    pre = zeros(size(V));
    pre(V>((1/(frame-72))*((1/(frame-72))>0.1)))=1;
    whitemap = max(whitemap - pre.*(1-internet),0);
    whitemap = whitemap.*logo;
%         subplot(1,2,2);
%         imshow(whitemap)
%         V = V.*logo;
%     V = min(V+(1-internet).*(1-whitemap),1);
    V = min(V+(1-whitemap),1);
%     V = V.*logo;
    output(:,:,1) = imresize(kron(H,ones(9,7)),size(internet),'nearest');%.*whitemap+(220/360).*(1-whitemap);
    output(:,:,2) = imresize(kron(S,ones(9,7)),size(internet),'nearest');%.*(1-whitemap);
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
    imwrite(output,export_folder+name);
    pause(0.1);
end

for i=1:(nVarargin)
    % disp("x: "+easterEggs{i,2})
    % disp("y: "+easterEggs{i,3})
    H(mod(easterEggs{i,3}+frame,ResY)+1,easterEggs{i,2}+1:easterEggs{i,2}+size(easterEggs{i,1},2)) = 0;
end

pause(2);
output(:,:,1) = imresize(kron(H,ones(9,7)),size(logo)).*whitemap+(220/360).*(1-whitemap);
output(:,:,2) = imresize(kron(S,ones(9,7)),size(logo));%.*whitemap;
output(:,:,3) = V;

output = hsv2rgb(output);
subplot(1,1,1);
imshow(output)
end
