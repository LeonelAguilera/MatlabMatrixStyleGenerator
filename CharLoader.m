function characters = CharLoader()
characters = cell(1,128-33);
for i = 33:128
    characters{i} = zeros(9,7,3);
    characters{i}(2:8,2:6,:) = double(round(1-(imread(i+".png")./255)));
    characters{i} = characters{i}(:,:,1);
end
end