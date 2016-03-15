signs = {'alive', 'all', 'answer', 'boy', 'building', 'buy', 'change_mind_', 'cold', 'come', 'computer_PC_', 'cost', 'crazy', 'danger', 'deaf', 'different', 'draw', 'drink', 'eat', 'exit', 'flash-light', 'forget', 'girl', 'give', 'glove', 'go', 'God', 'happy', 'head', 'hear', 'hello', 'his_hers', 'hot', 'how', 'hurry', 'hurt', 'I', 'innocent', 'is_true_', 'joke', 'juice', 'know', 'later', 'lose', 'love', 'make', 'man', 'maybe', 'mine', 'money', 'more', 'name', 'no', 'Norway', 'not-my-problem', 'paper', 'pen', 'please', 'polite', 'question', 'read', 'ready', 'research', 'responsible', 'right', 'sad', 'same', 'science', 'share', 'shop', 'soon', 'sorry', 'spend', 'stubborn', 'surprise', 'take', 'temper', 'thank', 'think', 'tray', 'us', 'voluntary', 'wait_notyet_', 'what', 'when', 'where', 'which', 'who', 'why', 'wild', 'will', 'write', 'wrong', 'yes', 'you', 'zero'}; 


curve_X = zeros(22, 100, 3*9*length(signs));

count = 1;

max_vals = zeros(22, 1, 3*9*length(signs));
min_vals = zeros(22, 1, 3*9*length(signs));

for i = 1 : length(signs)

    for k = 1 : 9
        
        item_1 = load(['data/asl_glove/tctodd' num2str(k) '/' signs{i} '-1.tsd']);
        item_2 = load(['data/asl_glove/tctodd' num2str(k) '/' signs{i} '-2.tsd']);
        item_3 = load(['data/asl_glove/tctodd' num2str(k) '/' signs{i} '-3.tsd']);
        
        curve_X(:, 1:size(item_1,1), count) = item_1';
        curve_X(:, 1:size(item_2,1), count + 1) = item_2';
        curve_X(:, 1:size(item_3,1), count + 2) = item_3';
        
        max_vals(:,1, count) = max(curve_X(:,:,count),[],2);
        max_vals(:,1, count + 1) = max(curve_X(:,:,count + 1),[],2);
        max_vals(:,1, count + 2) = max(curve_X(:,:,count + 2),[],2);
        
        min_vals(:,1, count) = min(curve_X(:,:,count),[],2);
        min_vals(:,1, count + 1) = min(curve_X(:,:,count + 1),[],2);
        min_vals(:,1, count + 2) = min(curve_X(:,:,count + 2),[],2);
        
        count = count + 3;
        
    end
    
end

ground_truth = reshape(repmat( 1:length(signs), 3*9, 1), 1, 3*9*length(signs));

max_vals = max(max_vals,[],3);
min_vals = min(min_vals,[],3);

clear count i item_1 item_2 item_3 k

save('data/asl');