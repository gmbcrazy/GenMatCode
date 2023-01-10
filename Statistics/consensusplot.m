function [hnam,hleaf]=consensusplot(f1, varargin)
% CONSENSUSPLOT reads files written by consensusHRG (C++ program) and 
%    renders the corresonding radial dendrogram.
%    Source: http://www.santafe.edu/~aaronc/randomgraphs/
% 
%    CONSENSUSPLOT returns handles to certain parts of the figure, for 
%    further customization. hnam is a vector of handles to the text labels 
%    on the outer edge (h1), and hleaf is a vector of handles to the leaf 
%    shapes (h2).
%    
%    The optional argument 'scale' allows the user to specify as scalar 
%    value by which to rescale these aspects on the initial rendering. The
%    optional argument 'groups' causes consensusplot to import a .groups 
%    file that gives the numerical group assigments of each input vertex.
%    
%    Note: In the example below, consensusplot also imports a file named
%    karate-names.lut and, if 'groups' is called, a file named
%    karate.groups. Both names are derived from the input argument f1.
% 
%    Example:
%       filename   = '/Users/myname/Documents/karate-consensus.tree';
%       [h1,h2] = consensusplot(filename,'scale',2);
%       [h1,h2] = consensusplot(filename,'groups');
%
%    For more information about experimental functions, try 
%       'type consensusplot'

% Version 1.0     (2008 May)
% Version 1.0.1   (2008 September)
% Version 1.0.2   (2009 January)
% Version 1.0.3   (2011 September)
% Copyright (C) 2008-2011 Aaron Clauset (Santa Fe Institute)
% Distributed under GPL 2.0
% http://www.gnu.org/copyleft/gpl.html
% CONSENSUSPLOT comes with ABSOLUTELY NO WARRANTY
% 
% Notes:
% 
% 1. Verbose mode, which outputs the text of the imported .hrg file, can be
%    activated like so
%    
%       h = consensusplot(filename,'v');

verbose  = false;
lim      = 1.0;
f_groups = false;

% parse command-line parameters; trap for bad input
i=1;
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i},
        case 'scale',        lim      = varargin{i+1}; i = i + 1;
        case 'groups',       f_groups = true;          i = i + 1;
        case 'v',            verbose  = true;          i = i + 1;
        otherwise, argok=0; 
    end
  end
  if ~argok, 
    disp(['(CONSENSUSPLOT) Ignoring invalid argument #' num2str(i+1)]); 
  end
  i = i+1; 
end
if ~isempty(lim) && (~isscalar(lim) || lim<0)
	fprintf('(CONSENSUSPLOT) Error: ''scale'' argument must be a scalar value near 1');
    fprintf('; using default.\n');
    lim = 1.0;
end;

% parse filename
k = findstr(f1,'-consensus.tree');
if isempty(k),
	fprintf('Error: %s does not appear to be a valid consensus tree file.\n',f1);
    return;
end;
if f_groups,
    l = findstr(f1,'_');
    f3 = strcat(f1(1:l(1)-1),'.groups');
else
    f3 = '';
end;

% --- Import tree data---
% import the -consensus.tree file
try
	clear k tline a b c d x R1 R2 R3 R4 I P M N nn tn;
	fid = fopen(f1,'r');
	k=1;
	while (true)
		tline = fgetl(fid);
		if ~ischar(tline), break, end;
		disp(tline);
		[a,R1] = strtok(tline(2:end));
		[b,R2] = strtok(R1(4:end));
		[x,R2] = strtok(R2);
		[c,R3] = strtok(R2);
		[x,R3] = strtok(R3);
		[d,R4] = strtok(R3);
		[I(k,1),P(k,1),M(k,1),N(k,1)] = deal(str2double(a)+1,str2double(b),1+str2double(c),str2double(d));
		nn{k} = [];
		tn{k} = [];
		for i=1:N(k)
			[a,R3] = strtok(R4);
			[b,R4] = strtok(R3);
			if strcmp(b,'(D)'), nn{k}  = [nn{k}; str2double(a)+1];
            else nn{k}  = [nn{k}; str2double(a)];
			end;
			tn{k}  = [tn{k}; b];
		end;
		tn{k} = cellstr(tn{k});
		[Y,K] = sort(nn{k});
		nn{k} = Y;
		tn{k} = tn{k}(K);
		k=k+1;
	end;
	fclose(fid);
	clear R1 R2 R3 R4 a b c d x i K Y;
catch
	fprintf('Error: failed to read %s\n',f1);
	return;
end;
if length(unique(cell2mat(nn(:)))) < 50 && (lim > 0.999 && lim < 1.001)
    lim = 1.5;
end;

% if necessary, report the contents of the file
if verbose
    fprintf('\n');
	for i=1:length(I)
		fprintf('[ %i ] %7.0f   P= %2.0f   N= %i ',I(i),P(i),M(i),N(i));
		for j=1:N(i)
			fprintf(' %i %s',nn{i}(j),char(tn{i}(j)));
		end;
		fprintf('\n');
	end;
end;

% make 'names', which maps internal indices to node names in the .tree file
f_et = 0;
%if min(cell2mat(nn(:)))==0, f_et = 1; end;            % detect indexing issue
et = [];
for i=1:length(I)
    for j=1:N(i)
        if strcmp(char(tn{i}(j)),'(G)')
            if f_et==1, nn{i}(j) = nn{i}(j) + 1; end; % fix indexing issue
            et = [et; nn{i}(j)];
        end;
    end;
end;
names = [(1:length(unique(et)))' unique(et)];
%if f_et==1, names(:,2) = names(:,2) - 1; end;

% because the .tree file records the 'real' name X for each graph vertex 
% when it lists one as "X (G)", this can present problems subsequently. To
% fix this, we run through the nn cell matrices and replace each
% occurrence of X with its 'internal' name Y given in the corresponding row
% of names.
for i=1:length(I)
    for j=1:N(i)
        if strcmp(char(tn{i}(j)),'(G)')
            nn{i}(j) = names(names(:,2)==nn{i}(j),1);
        end;
    end;
end;

% import the .groups file. this maps node names in the .pairs file onto their
% group indices
if f_groups
    f_g_ok = false;
    for i=1:length(l)
        f3 = strcat(f1(1:l(i)-1),'.groups');
        try
            ss = textread(f3,'%s');
            gg = sortrows([str2num(char(ss(1:2:end))) str2num(char(ss(2:2:end)))]);
            groups = [names(:,1) gg(:,2)];
            for i=1:length(I)
                for j=1:N(i)
                    if strcmp(char(tn{i}(j)),'(G)')
                        nn{i}(j) = names(names(:,2)==nn{i}(j),1);
                    end;
                end;
            end;

            f_g_ok = true;
            break;
        catch
            % do nothing
        end;
    end;
    if ~f_g_ok
        fprintf('Warning: failed to read %s. Using defaults.\n',f3);
        groups = [names(:,1) ones(size(names(:,1)))];
    end;
else
    groups = [names(:,1) ones(size(names(:,1)))];
end;

% --- Parse consensus tree data ---
% Do DFS traversal of tree structure (starting at the root of each tree in the
% forest, which is given by a M(i)=0 value), and create a list of leaf vertices 
% in the order they were visited. Simultaneously, build a matrix structure that
% one could pass to the dendrogram() function; we also build a variation on 
% that structure where instead of labeling internal vertices with new numbers, 
% we give them the minimum leaf index in their subtree (this is the variable Q).

roots = find(M==0);         % get list of all tree roots
leaf  = [];
D     = []; Q = [];
R = [I I zeros(size(I))];	% lookup table: internal index to n+I index and n index
marks = zeros(size(I));     % 
pars  = -1*ones(size(I));   % 
con   = max(cell2mat(nn'));	% number of leaf vertices
depth = zeros(con,1);       % depth of each leaf vertex
H     = [I zeros(size(I))]; % 
for i=1:length(roots)
	curr        = I(roots(i));
	marks(curr) = 1;
	dep         = 0;
	while (true)
		if (length(nn{curr})==1)
			break;
		elseif (marks(curr) > length(nn{curr}))
			clear child hchild qchild;
			marks(curr) = -1;
			con         = con + 1;
			R(curr,2)   = con;			% index for D matrix
			for k=1:length(tn{curr})
				if (strcmp(tn{curr}(k),'(G)'))
					 child(k) = nn{curr}(k);
					hchild(k) = 0;
					qchild(k) = child(k);
				else
					 child(k) = R(nn{curr}(k),2);
					hchild(k) = H(nn{curr}(k),2);
					qchild(k) = R(nn{curr}(k),3);
				end;
			end;
			R(curr,3) = min(qchild);	% index for Q matrix
			H(curr,2) = 1+max(hchild);	% height of join
			for k=1:length(child)
				D = [D; [ child(k) R(curr,2) H(curr,2)]];
				Q = [Q; [qchild(k) R(curr,3) H(curr,2)]];
			end;
			curr = pars(curr);			% move up in tree
			dep  = dep - 1;             % decrement depth
			if (curr == -1)
				break;                  % root has no parent
			end;
		elseif (marks(curr) > 0)
			marks(curr) = marks(curr)+1;
			if (strcmp(tn{curr}(marks(curr)-1),'(D)'))
				pars(nn{curr}(marks(curr)-1)) = curr;
				curr        = nn{curr}(marks(curr)-1);
				dep         = dep + 1;
				marks(curr) = 1;
			else
				leaf = [leaf; nn{curr}(marks(curr)-1)];
				depth(nn{curr}(marks(curr)-1)) = dep + 1;
			end;
		end;
	end;
end;
% cleanup some memory
clear marks H con dep pars R child hchild qchild curr i;
temp = unique(D(:,2));
for i=1:length(Q)
	Q(i,4) = find(temp==D(i,2));
end;
clear temp;


% --- Draw radial consensus tree ---
m    = size(Q,1)+1;
s    = length(leaf);
cmap = [0 0 0];
T    = zeros(m-1,1);						% post angles
S    = zeros(m-1,2);						% post radii
C    = zeros(length(I),2);					% crossbar angles
D    = zeros(length(I),1);					% crossbar radius
Y    = ones(m,1);
W    = Q;

% Get list of leafs in the order they first appear in Q. This will be used
% to label the leafs in the figure. Then create X vector, which maps a
% leaf index in Q to its clockwise-ordered position in the leaf ordering
%label = num2str(leaf);
[~,X] = sort(leaf);
label = num2str(names(leaf,2));
glabs = groups(leaf,2);

dtheta = 2*pi/s;
angles = dtheta*(0:(s-1));

% Create end-points for posts (we'll do the crossbars after), in polar
% coordinates. The posts are pairs of lines, where T(i) stores the angle of
% the ith post, and R(i,:) stores the radii of the outer and inner
% endpoints of the post.
W(:,3) = (1 - (Q(:,3)./max(Q(:,3))));   % rescale distances
A      = angles(X)';                    % angles of leaf nodes
temp   = unique(W(:,4));
for n=1:length(I)
    grab = find(W(:,4)==temp(n));
    for k=1:length(grab)
        z        = grab(k);
        [i,~,w]  = deal(W(z,1),W(z,2),W(z,3));
        T(z)     = A(i);				% angle of post
        S(z,:)   = [Y(i) w];			% radii of post endpoints
    end;
    tt    = (A(W(grab(1)))+A(W(grab(end))))/2;
    A(W(grab,1)) = tt;                  % x-loc of crossbar center
    Y(W(grab,1)) = w;                   % new depth of subtree
    C(n,:)= [T(grab(1)) T(grab(end))];	% angles of crossbar
    D(n)  = S(grab(1),2);				% radius of crossbar
end;
clear temp tt grab;

% Create arcs for crossbars. These are portions of a circle that span
% the inner endpoints of the two posts, converted to cartesian coordinates
% for plotting.
for n=1:length(I)
    t      = linspace(C(n,1),C(n,2));
    cb{n}  = [D(n).*sin(t)' D(n).*cos(t)'];
    ext(n) = abs(C(n,1)-C(n,2));
end;

% Draw the posts.
figure;
set(gcf,'Position', [0, 0, 500, 500]);
h1    = zeros(m-1,1);							% list of handles to posts
for n=1:length(T)
    x = [S(n,1)*sin(T(n)) S(n,2)*sin(T(n))];	% convert to cartesian coordinates
    y = [S(n,1)*cos(T(n)) S(n,2)*cos(T(n))];	%
    h(n) = line(x,y,'color',cmap); hold on;		% plot line
    set(h(n),'LineWidth',[1.5]);
end
% Draw the crossbars.
h2 = zeros(length(I),1);						% list of handles to crossbars
for n=1:length(I)
    h2(n)=plot(cb{n}(:,1),cb{n}(:,2),'k');
    set(h2(n),'LineWidth',[1.5]);
end;
msize = floor(lim*9);
	
% Pretty-up the figure: lay out the leaf nodes.
x = sin(angles)';
y = cos(angles)';
mar = {'o','d','s','v','^','o','s','v','^','o','s','v','^','d'};
if f_groups,
    gn  = length(unique(groups(:,2)));
    if gn==2
        mfc = [0 0 0; 1 1 1]; mar = {'d','o'};
    elseif gn==3
        mfc = [0 0 0; 0.5 0.5 0.5; 1 1 1]; mar = {'d','o','s'};
    else
        mc  = linspace(0,1,ceil(log(gn)/log(3))); mcn = length(mc);
        mfc = zeros(gn,3);
        for i=1:gn
            mfc(i,:) = [mc(mod(floor((i-1)/mcn^2),mcn)+1) mc(mod(floor((i-1)/mcn),mcn)+1) mc(mod(i-1,mcn)+1)];
        end;
    end;
else
    mfc = [1 1 1];
end;
hleaf = zeros(length(glabs),1);
for i=1:size(hleaf,1)
    hleaf(i)=plot(x(i),y(i),mar{glabs(i)},'MarkerSize',msize,'MarkerFaceColor', ...
        mfc(glabs(i),:), 'MarkerEdgeColor',[0 0 0]); hold on;
    set(hleaf(i),'Color',cmap);
end;
axis square;
axis([-1 1 -1 1]);
axis off;

% Pretty-up the figure: lay out their labels.
fac  = 1.05;
hnam = zeros(length(glabs),1);
for i=1:size(hnam,1)
    if (i <= ceil(m/2))
        hnam(i) = text(fac*x(i),fac*y(i),label(i,:));
        % right-side of circle
        set(hnam(i),'Rotation', 90-180*angles(i)/pi, 'FontWeight','bold', ... 
            'HorizontalAlignment','left', 'VerticalAlignment', ... 
            'Middle','Color',cmap,'FontSize',10*lim);
    else
        hnam(i) = text(fac*x(i),fac*y(i),label(i,:));
        % left-side of circle
        set(hnam(i),'Rotation',-90-180*angles(i)/pi, 'FontWeight','bold', ... 
            'HorizontalAlignment','right', 'VerticalAlignment', ... 
            'Middle','Color',cmap,'FontSize',10*lim);
    end;
end;
hold off;

% clean up memory
clear m T R C D Y W u X cmap dtheta angles t A cb x y n i j w k ... 
    label fac lim fsz h1 h2 g1 g2;

