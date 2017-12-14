function [ filtersCell ] = generateLawsFilters()
%GENERATELAWSFILTERS Summary of this function goes here
%   Detailed explanation goes here

%% Define Filters
level5 = struct(...
    'filter', [1, 4, 6, 4, 1], ...
    'abv', 'L5', ...
    'prime', 2 ...
    );

edge5 = struct(...
    'filter', [-1, -2, 0, 2, 1], ...
    'abv', 'E5', ...
    'prime', 3 ...
    );

spot5 = struct(...
    'filter', [-1, 0, 2, 0, -1], ...
    'abv', 'S5', ...
    'prime', 5 ...
    );

ripple5 = struct(...
    'filter', [+1, -4, 6, -4, +1], ...
    'abv', 'R5', ...
    'prime', 7 ...
    );

wave5 = struct(...
    'filter', [+1, +2, 0, -2, +1], ...
    'abv', 'W5', ...
    'prime', 9 ...
    );

%% Group filters
filterArray = [level5, edge5, spot5, ripple5, wave5];

%% Generate all filter combinations
nFilters = numel(filterArray);

filtersCell = cell(nFilters^3, 1); 
iFilter = 1;

for iYFilter = 1:nFilters
    yFilter = filterArray(iYFilter);
    yFilterMask = shiftdim(yFilter.filter,1);

    for iXFilter = 1:nFilters
        xFilter = filterArray(iXFilter);
        xFilterMask = xFilter.filter;
        
        xyMultiplication = nDimensionalMult(yFilterMask, xFilterMask);
        
        for iZFilter = 1:nFilters
            zFilter = filterArray(iZFilter);
            zFilterMask = shiftdim(zFilter.filter,-1);
            filtersCell{iFilter} = struct( ...
                'filter', squeeze(nDimensionalMult(xyMultiplication, zFilterMask)), ...
                'name', [yFilter.abv, xFilter.abv, zFilter.abv], ...
                'id', yFilter.prime * xFilter.prime * zFilter.prime ...
            );
            iFilter = iFilter + 1;
        end
    end
end



end

%% Ndimensional Multiplication
function result = nDimensionalMult(v1, v2)
    sizeV1 = size(v1);
    sizeV2 = size(v2);
    result = reshape(reshape(v1, [], 1)*reshape(v2, 1, []), [sizeV1 sizeV2]);
end