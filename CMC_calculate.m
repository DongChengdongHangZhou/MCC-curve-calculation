num_test = [1 1  1 2 2 2 3 3 3]; % 其实test就是probe, num_test矩阵的长度就是probe图片的张数。假设有N张probe，那么num_test就是1*N。第i个元素的值就是第i个probe属于第几类
num_train = [1 1 2 2 3]; % 其实train就是gallery，num_train矩阵的长度就是gallery图片的张数。假设有M张gallery,那么num_train就是1*M。第i个元素的值就是第i个gallery属于第几类
num_class = [1 2 3]; % 总共有k类，num_class就等于[1 2 3 ... k]
match_dist = rand(9,5); % 距离矩阵，尺寸为N*M，就是probe与gallery的距离矩阵


match_scores = zeros(length(num_test),length(num_class));
true_labels = zeros(length(num_test),length(num_class));
        for i=1:length(num_test)
            for j=1:length(num_class)
                [x,y]=find(num_class(j)==num_train);
                
                %选取匹配程度的中值
                label_distances(i,j) = median(match_dist(i,y));
                if num_test(i)==num_class(j)
                    true_labels(i,j)=1;
                end
            end
        end
        
        %生成CMC
        max_rank = length(num_class);
        
        %Rank取值范围
        ranks = 1:max_rank;
        
        %排序
        label_distances_sort = zeros(length(num_test),length(num_class));
        true_labels_sort = zeros(length(num_test),length(num_class));
        for i=1:length(num_test)
            [label_distances_sort(i,:), ind] = sort(label_distances(i,:));
            true_labels_sort(i,:) =  true_labels(i,ind);
        end
        
        %迭代
        rec_rates = zeros(1,max_rank);
        tmp = 0;
        for i=1:max_rank
            tmp = tmp + sum(true_labels_sort(:,i));
            rec_rates(1,i)=tmp/length(num_test);
        end  
  plot(1:max_rank,rec_rates)
