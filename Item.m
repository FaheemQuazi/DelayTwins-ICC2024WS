% Item Class
% T in paper = TSync + MaxAge
classdef Item
    properties
        % Parameters that are synced
        Name      (1,1) string = "I" %Item Name for readability
        TPsi      = 0 %Generation Time [s] (CHANGES OVER TIME)
        PPsi      = 1 %Priority [#]
        SPsi      = 1 %Size [MB]

        % Sim Parameters
        NewGenerationTime = 0 %Time To Generate new Item [s] (CHANGES OVER TIME)
        SendCount = 0 %number of times this item has been sent[s] (CHANGES OVER TIME)
        DataCounter = 0 %Increments when updated (CHANGES OVER TIME)
    end
    methods
        function I = Item(n,t,p,s,g)
            I.Name  = n;
            I.TPsi = t;
            I.PPsi = p;
            I.SPsi = s;
            I.NewGenerationTime = g;
        end
        function o = AoS(it,t)
            arguments
                it   (1,1) Item
                t    (1,1) double {mustBeReal, mustBeNonnegative} %current time
            end
            % Account for Sync Delay
            o = max(0, t - it.TPsi);
        end
        function o = AoI(it,t)
            arguments
                it   (1,1) Item
                t    (1,1) double {mustBeReal, mustBeNonnegative} %current time
            end
            o = t - it.TPsi - it.NewGenerationTime; % To get actual generation time
        end
    end
end