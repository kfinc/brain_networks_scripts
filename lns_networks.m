% Script for transforming m x m binary connectivity matrix into n x x matrix 
% representing number of connections between predefined modules (as example
% 13 large-scale networks from 264 Power ROIs matrix).

% Input: 
%    - binary connectivity matrix
%    - vector of large-scale network assignment for each ROI     
% Output: 
%    - n x n matrix representing number of connections between predefined modules 
%    - n x n matrix visualization

%% LOADING DATA

% loading binary connectivity matrix 
A = load ('/home/finc/Dropbox/Copy/001_RESEARCH/001_PROJECTS/001_NOW/000_LearningBrain/2018/FC_matrices_2018/Dual/Power/all_sessions/Power_e-c_1000_NEW.txt')

% loading vector with large-scale networks(LSN) abbreviations (here - for
% 264 Power ROIs
M = importdata('/home/finc/Dropbox/Copy/001_RESEARCH/001_PROJECTS/001_NOW/000_LearningBrain/2018/modules.txt', ' ');

%% CREATING 264x13 MATRIX WITH SEPARATE COLUMN FOR EACH LSN

LSN = zeros(size(M,1),size(unique(M),1));
columns = unique(M);

for col = 1:length(columns)             % for every module
   module = columns{col};
    for row = 1:size(M,1)
       if isequal(M{row},module)
            LSN(row,col) = 1;
        else
            LSN(row,col) = 0;
       end
    end
end

%% MATRIX MULTIPLICATION TO RECEIVE 13X13 MATRIX WITH ROW AND COLUMNS CORRESPONDING TO LSN

NETWORKS = LSN'*A*LSN;

%% RESULTS VISUALIZATION

imagesc(NETWORKS); 
colorbar;
colormap(flipud(hot));
columns = unique(M);
xticklabels = columns;
xticks = linspace(1, size(NETWORKS, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels)
yticklabels = columns;
yticks = linspace(1, size(NETWORKS, 2), numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels)
set(gca,'dataAspectRatio',[1 1 1])

dlmwrite('Power_networks.txt',full(NETWORKS),'delimiter',' ','precision','%d');

