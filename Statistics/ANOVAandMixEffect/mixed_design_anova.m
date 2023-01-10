%% This script includes (1) a data set simulation and (2) mixed-design analysis using ANOVAN
%
% In a mixed-design ANOVA model:
% one factor (a fixed effects factor) is a between-subjects variable and 
% the other (a random effects factor) is a within-subjects variable)
%
% http://en.wikipedia.org/wiki/Mixed-design_analysis_of_variance

clear all

n=10; % Defines sample size of each group (food_type). The sample size can differ between groups.

subject    = 1:n*3;                                 % Subject id.
food_type = [ones(1,n) 2*ones(1,n) 3*ones(1,n)];    % Groups of subjects in each food-type
gender    = randi(2,[1,n*3]);                       % Subject gender

% Defines the value of simulated observations. You define the influence of
% the factors, in isolation or combined.
subject_variation = 80 + 5*randn(1,n*3);
weight1   = 1*4*food_type + 1*-20*gender + 1*5*food_type.*gender + subject_variation + 2*randn(1,n*3);
weight2   = 1*2*food_type + 1*-20*gender + 1*5*food_type.*gender + subject_variation + 2*randn(1,n*3);

% Each observation has to be assigned to the level of each fator
observation = [weight1 weight2];
factors     = { [subject subject] ; [food_type food_type] ; [gender gender] ; [ones(1,n*3) 2*ones(1,n*3)] };

% The subjects (line 1 on factors cell) are nested in food_type and
% gender groups (lines 2 and 3, respectivelty).
nesting     = zeros(4,4);   nesting(1,2)=1;    nesting(1,3)=1;

% Run
[p,table,stat,terms] = anovan( observation ,  factors , ...
    'random', 1 , 'nested', nesting , 'model', 'interaction', ... 
    'varnames',{'subject','food_type','gender','repetition'}, ...
    'display','off');

% Display p-values in command window
clc
for i=1:size(table,1)-2
    disp([table{i,1} repmat(' ',1,abs(40-length(table{i,1}))) num2str(table{i,7}) ])
end

% Plot the observations of each subject
clf
color_food_type=[1 0 0; 0 1 0; 0 0 1]*0.7;
line_gender{1}='s:'; line_gender{2}='o-';
count=0;
for f=1:3
    for g=1:2
        count=count+1;
        legend_str{count}=['food = ' num2str(f) ', gender = ' num2str(g)];
        plot([1.5 1.5],[75 75],line_gender{g},'color',color_food_type(f,:),'linewidth',2)
        hold on        
    end
end
for p=1:3*n
    plot([1 2],[weight1(p) weight2(p)],line_gender{gender(p)},'color',color_food_type(food_type(p),:),'linewidth',2)
end
axis tight
xlim([0.1 2.9])
legend(legend_str,'Location','EastOutside')
xlabel('Time')
ylabel('Weight')
set(gca,'xtick',[1 2])

%%