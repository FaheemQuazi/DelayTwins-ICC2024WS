Iter = 1;
ItemsMoonMaxAoI = ItemList;
ItemsEarthMaxAoI = ItemList;
TXQueueMaxAoI = {};

for t=0:TimeStep:MaxTime
    % Sending: Max AoI (sorted send)
    
    % Check for Updates
    for i=1:ItemCount
        if ItemsMoonMaxAoI(i).TPsi <= t
            ItemsMoonMaxAoI(i).TPsi = t + ItemsMoonMaxAoI(i).NewGenerationTime;
            ItemsMoonMaxAoI(i).DataCounter = ItemsMoonMaxAoI(i).DataCounter + 1;
        end
    end

    % sort items by AoI highest to lowest
    [~, idx] = sort(arrayfun(@(x) x.AoI(t), ItemsEarthMaxAoI), 'descend');
    ItemsMoonMaxAoIToSend = ItemsMoonMaxAoI(idx);
    
    CurrSize = 0;
    SendQueue = {};
    for i=1:ItemCount
        if CurrSize + ItemsMoonMaxAoIToSend(i).SPsi <= BRPerStep
            CurrSize = CurrSize + ItemsMoonMaxAoIToSend(i).SPsi;
            ItemsMoonMaxAoIToSend(i).SendCount = ItemsMoonMaxAoIToSend(i).SendCount + 1;
            %Update the original Moon version
            for j=1:ItemCount
                if ItemsMoonMaxAoIToSend(i).Name == ItemsMoonMaxAoI(j).Name
                    ItemsMoonMaxAoI(j).SendCount = ItemsMoonMaxAoI(j).SendCount + 1;
                    break
                end
            end
            SendQueue = [SendQueue ItemsMoonMaxAoIToSend(i)];
        end
    end

    TXQueueMaxAoI = [TXQueueMaxAoI ; {(t+TDelayAtStep) TDelayAtStep SendQueue}];


    % Receiving 
    while t >= TXQueueMaxAoI{1,1}
        for i=1:numel(TXQueueMaxAoI{1,3})
            CurrItem = TXQueueMaxAoI{1,3}(i);
            for j=1:ItemCount
                if CurrItem.Name == ItemsEarthMaxAoI(j).Name
                    ItemsEarthMaxAoI(j).TPsi = CurrItem.TPsi;
                    ItemsEarthMaxAoI(j).DataCounter = CurrItem.DataCounter;
                    ItemsEarthMaxAoI(j).SendCount = ItemsEarthMaxAoI(j).SendCount + 1;
                    break
                end
            end
        end
        TXQueueMaxAoI(1,:) = [];
    end

    % Get Mean of AoI
    MeanAoS = 0; 
    for i=1:ItemCount
        CurrItem = ItemsEarthMaxAoI(i);
        MeanAoS = MeanAoS + CurrItem.AoS(t);
        LoggedDataMaxAoI(Iter, i) = CurrItem.DataCounter;
        LoggedSendCountMaxAoI(Iter, i) = CurrItem.SendCount;
    end
    LoggedYAoSMaxAoI(Iter) = MeanAoS / ItemCount;
    LoggedXTime(Iter) = t;

    Iter = Iter + 1;
end