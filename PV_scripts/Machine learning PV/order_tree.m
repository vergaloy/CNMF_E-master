function perm = order_tree(Z)
 

    numLeaves = size(Z, 1) + 1; % the number of observations

   
    Z = transz(Z);
    [~, Z, leafOrder, numLeaves] = decrowd(numLeaves, Z, 0, []);
    [~, ~, perm] = orderTree(numLeaves, Z, leafOrder, true);
end

function Z = transz(Z)
    %TRANSZ Translate output of LINKAGE into another format.
    %   This is a helper function used by DENDROGRAM and COPHENET.
    %   For each node currently labeled numLeaves+k, replace its index by
    %   min(i,j) where i and j are the nodes under node numLeaves+k.

    %   In LINKAGE, when a new cluster is formed from cluster i & j, it is
    %   easier for the latter computation to name the newly formed cluster
    %   min(i,j). However, this definition makes it hard to understand
    %   the linkage information. We choose to give the newly formed
    %   cluster a cluster index M+k, where M is the number of original
    %   observation, and k means that this new cluster is the kth cluster
    %   to be formed. This helper function converts the M+k indexing into
    %   min(i,j) indexing.

    numLeaves = size(Z, 1) + 1;

    for i = 1:(numLeaves - 1)
        if Z(i, 1) > numLeaves
            Z(i, 1) = traceback(Z, Z(i, 1));
        end

        if Z(i, 2) > numLeaves
            Z(i, 2) = traceback(Z, Z(i, 2));
        end

        if Z(i, 1) > Z(i, 2)
            Z(i, 1:2) = Z(i, [2 1]);
        end
    end
end
function a = traceback(Z, b)
    numLeaves = size(Z, 1) + 1;

    if Z(b - numLeaves, 1) > numLeaves
        a = traceback(Z, Z(b - numLeaves, 1));
    else
        a = Z(b - numLeaves, 1);
    end

    if Z(b - numLeaves, 2) > numLeaves
        c = traceback(Z, Z(b - numLeaves, 2));
    else
        c = Z(b - numLeaves, 2);
    end

    a = min(a, c);
end

function [T, Z, leafOrder, numLeaves] = decrowd(numLeaves, Z, p, leafOrder)
    % If there are more than p nodes, the dendrogram looks crowded.
    % The following code will make the last p link nodes into leaf nodes,
    % and only these p nodes will be visible.
    T = (1:numLeaves)';

    if (numLeaves > p) && (p ~= 0)
        Y = Z((numLeaves - p + 1):end, :); % get the last nodes
        [T, W] = getDecrowdedOrdering(T, Y, p);
        T = assignOriginalLeavesToNodes(numLeaves, T, Z, p);
        Z = createSmallerTree(W, Y);
        [leafOrder, numLeaves] = assignLeafOrderToNodes(T, leafOrder, p);
    end
end
function [T, W] = getDecrowdedOrdering(T, Y, p)
    R = unique(Y(:, 1:2));
    Rlp = R(R <= p);
    Rgp = R(R > p);
    W(Rlp) = Rlp; % use current node number if <=p
    W(Rgp) = setdiff(1:p, Rlp); % otherwise get unused numbers <=p
    W = W(:);
    T(R) = W(R);
end
function T = assignOriginalLeavesToNodes(numLeaves, T, Z, p)
    for i = numLeaves - p:-1:1
        T(Z(i, 2)) = T(Z(i, 1));
    end
end
function Z = createSmallerTree(W, Y)
    Y(:, 1) = W(Y(:, 1));
    Y(:, 2) = W(Y(:, 2));
    % At this point, it's possible that Z(i,1) < Z(i,i) for some rows.
    % The newly formed cluster will always be
    % represented by the number in Z(i,1);
    Z = Y;
end
function [leafOrder, numLeaves] = assignLeafOrderToNodes(T, leafOrder, p)
    if ~isempty(leafOrder)
        leafOrder = T(leafOrder)';
        d = diff(leafOrder);
        d = [1 d];
        leafOrder = leafOrder(d ~= 0);

        if numel(leafOrder) ~= p
            error(message('stats:dendrogram:InvalidLeafOrder'));
        end
    end
    numLeaves = p; % reset the number of nodes to be p (row number = p-1).
end

function [X, Y, perm] = orderTree(numLeaves, Z, leafOrder, check)
    % Initializes X such that there will be no crossing
    Y = zeros(numLeaves, 1);

    if isempty(leafOrder)
        r = Y;
        W = arrangeZIntoW(numLeaves, Z);
        [X, perm] = fillXFromW(numLeaves, W, r);
    else % if a leaf order is specified
        X(leafOrder) = 1:numLeaves; % get X based on the specified order
        if (check) % check whether leafOrder will have crossing branch
            checkCrossing(Z(:, 1:2), leafOrder);
        end
        perm = leafOrder;
    end
end
function W = arrangeZIntoW(numLeaves, Z) % to remove crossing
    W = zeros(size(Z));
    W(1, :) = Z(1, :);
    nsw = zeros(numLeaves, 1);
    rsw = nsw;
    nsw(Z(1, 1:2)) = 1;
    rsw(1) = 1;
    k = 2; s = 2;
    while (k < numLeaves)
        i = s;
        while rsw(i) ||~any(nsw(Z(i, 1:2)))

            if rsw(i) && i == s
                s = s + 1;
            end

            i = i + 1;
        end
        W(k, :) = Z(i, :);
        nsw(Z(i, 1:2)) = 1;
        rsw(i) = 1;

        if s == i
            s = s + 1;
        end
        k = k + 1;
    end
end
function [X, perm] = fillXFromW(numLeaves, W, r)
    X = 1:numLeaves; %the initial points for observation 1:n
    g = 1;

    for k = 1:numLeaves - 1
        i = W(k, 1); % the left node in W(k,:)

        if ~r(i)
            X(i) = g;
            g = g + 1;
            r(i) = 1;
        end

        i = W(k, 2); % the right node in W(k,:)

        if ~r(i)
            X(i) = g;
            g = g + 1;
            r(i) = 1;
        end
    end
    perm(X) = 1:numLeaves;
end
function checkCrossing(Z, order)
    % check whether the give Tree will have crossing branches
    % with the given permutation vector

    numBranches = size(Z, 1);
    numLeaves = numBranches + 1;
    % reorder the tree
    perm = order(:);
    % XPos is the position indices for leaves 1:numLeaves.
    XPos(perm) = 1:numLeaves;
    Z0 = Z; % keep the original tree
    % renumber the leave nodes in Z such that number N represents the
    % Nth nodes in the plot
    Z = XPos(Z);
    % Check if the reordered tree structure leads to a
    % tree with no crossing branches
    minPos = 1:numLeaves;
    maxPos = 1:numLeaves;
    sz = ones(numLeaves, 1);

    for i = 1:numBranches
        currentMinPos = min(minPos(Z(i, :)));
        currentMaxPos = max(maxPos(Z(i, :)));
        currentSize = sum(sz(Z(i, :)));

        if currentMaxPos - currentMinPos + 1 ~= currentSize
            warning(message('stats:dendrogram:CrossingBranches'));
            break;
        end

        j = XPos(Z0(i, 1)); % j is the cluster number for the newly formed cluster.
        % Note that we can't use j = XPos(min(Z0(i,:))),
        % Because when not all of the points are shown, the value in the
        % first column of Z may be bigger than the value in the second column.
        minPos(j) = currentMinPos;
        maxPos(j) = currentMaxPos;
        sz(j) = currentSize;
    end
end

function T = findLocalClustering(X, T, k, m)
    n = m;
    while n > 1
        n = n - 1;
        if X(n, 1) == k % node k is not a leave, it has subtrees
            T = findLocalClustering(X, T, k, n); % trace back left subtree
            T = findLocalClustering(X, T, X(n, 2), n);
            break;
        end
    end
    T(m) = 1;
end


