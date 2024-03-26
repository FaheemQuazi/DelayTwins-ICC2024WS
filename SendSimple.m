Iter = 1;
ItemsMoonSimple = ItemList;
ItemsEarthSimple = ItemList;
TXQueueSimple = {};

for t=0:TimeStep:MaxTime
    % Sending: First Come First Serve Algorithm
    CurrSize = 0;
    SendQueue = {};
    for i=1:ItemCount
        if ItemsMoonSimple(i).TPsi <= t
            ItemsMoonSimple(i).TPsi = t + ItemsMoonSimple(i).NewGenerationTime;
            ItemsMoonSimple(i).DataCounter = ItemsMoonSimple(i).DataCounter + 1;
            %did we just generate this item OR 
            %has it not sent since generation
            if CurrSize + ItemsMoonSimple(i).SPsi <= BRPerStep
                CurrSize = CurrSize + ItemsMoonSimple(i).SPsi;
                ItemsMoonSimple(i).SendCount = ItemsMoonSimple(i).SendCount + 1;
                SendQueue = [SendQueue ItemsMoonSimple(i)];
            end
        end
    end

    TXQueueSimple = [TXQueueSimple ; {(t+TDelayAtStep) TDelayAtStep SendQueue}];

    % Receiving 
    while t >= TXQueueSimple{1,1}
        for i=1:numel(TXQueueSimple{1,3})
            CurrItem = TXQueueSimple{1,3}(i);
            for j=1:ItemCount
                if CurrItem.Name == ItemsEarthSimple(j).Name
                    ItemsEarthSimple(j).TPsi = CurrItem.TPsi;
                    ItemsEarthSimple(j).DataCounter = CurrItem.DataCounter;
                    ItemsEarthSimple(j).SendCount = ItemsEarthSimple(j).SendCount + 1;
                    break
                end
            end
        end
        TXQueueSimple(1,:) = [];
    end

    % Get Mean of AoI
    MeanAoS = 0; 
    for i=1:ItemCount
        CurrItem = ItemsEarthSimple(i);
        MeanAoS = MeanAoS + CurrItem.AoS(t);
        LoggedDataSimple(Iter, i) = CurrItem.DataCounter;
        LoggedSendCountSimple(Iter, i) = CurrItem.SendCount;
    end
    LoggedYAoSSimple(Iter) = MeanAoS / ItemCount;
    LoggedXTime(Iter) = t;

    Iter = Iter + 1;
end