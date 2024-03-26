Iter = 1;
ItemsMoonMAB = ItemList;
ItemsEarthMAB = ItemList;
TXQueueMAB = {};

for t=0:TimeStep:MaxTime
    % Sending: Max AoI (sorted send)
    
    % Check for Updates
    for i=1:ItemCount
        if ItemsMoonMAB(i).TPsi <= t
            ItemsMoonMAB(i).TPsi = t + ItemsMoonMAB(i).NewGenerationTime;
            ItemsMoonMAB(i).DataCounter = ItemsMoonMAB(i).DataCounter + 1;
        end
    end

    % sort items by greatest weight highest to lowest
    [~, idx] = sort(arrayfun(@(x) MAB(x, t, Iter, BRPerStep), ItemsEarthMAB), 'descend');
    ItemsMoonMABSend = ItemsMoonMAB(idx);
    
    CurrSize = 0;
    SendQueue = {};
    for i=1:ItemCount
        if CurrSize + ItemsMoonMABSend(i).SPsi <= BRPerStep
            CurrSize = CurrSize + ItemsMoonMABSend(i).SPsi;
            %Update this copy
            ItemsMoonMABSend(j).SendCount = ItemsMoonMABSend(j).SendCount + 1;
            %Update the original Moon version
            for j=1:ItemCount
                if ItemsMoonMABSend(i).Name == ItemsMoonMAB(j).Name
                    ItemsMoonMAB(j).SendCount = ItemsMoonMAB(j).SendCount + 1;
                    break
                end
            end
            SendQueue = [SendQueue ItemsMoonMABSend(i)];
        end
    end

    TXQueueMAB = [TXQueueMAB ; {(t+TDelayAtStep) TDelayAtStep SendQueue}];


    % Receiving 
    while t >= TXQueueMAB{1,1}
        for i=1:numel(TXQueueMAB{1,3})
            CurrItem = TXQueueMAB{1,3}(i);
            for j=1:ItemCount
                if CurrItem.Name == ItemsEarthMAB(j).Name
                    ItemsEarthMAB(j).TPsi = CurrItem.TPsi;
                    ItemsEarthMAB(j).DataCounter = CurrItem.DataCounter;
                    ItemsEarthMAB(j).SendCount = ItemsEarthMAB(j).SendCount + 1;
                    break
                end
            end
        end
        TXQueueMAB(1,:) = [];
    end

    % Get Mean of AoI
    MeanAoS = 0; 
    for i=1:ItemCount
        CurrItem = ItemsEarthMAB(i);
        MeanAoS = MeanAoS + CurrItem.AoS(t);
        LoggedDataMAB(Iter, i) = CurrItem.DataCounter;
        LoggedSendCountMAB(Iter, i) = CurrItem.SendCount;
    end
    LoggedYAoSMAB(Iter) = MeanAoS / ItemCount;
    LoggedXTime(Iter) = t;

    Iter = Iter + 1;
end