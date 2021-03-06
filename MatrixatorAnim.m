function output = MatrixatorAnim(ResX,ResY,TrailLen,colorA,colorB)
colorA = rgb2hsv(colorA);
colorB = rgb2hsv(colorB);
step = 1/TrailLen;
characters = CharLoader();
ShadowMap = rand(ResY,ResX);
% imshow(ShadowMap);
% pause(2)
[~,Index] = max(ShadowMap);
% disp(Index)
Index = Index - TrailLen*ceil(Index./TrailLen);
% disp(Index)

lineStart = Index*step-step;
lineEnd   = lineStart + step*(ResY-1);

for x = 1:ResX
    ShadowMap(:,x) = (lineStart(x):step:lineEnd(x))';
end
ShadowMap = ShadowMap-floor(ShadowMap);

letters = round((126-33)*rand(ResY,ResX))+33;

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
    imshow(output)
    pause(0.1);
end
end
