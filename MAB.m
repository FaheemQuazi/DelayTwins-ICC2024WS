function [w] = MAB(it, t, iter, BRPerStep)
%MAB Execute MAB-based weight formulation
%   A Detailed Explanation of this formulation is in the paper
    arguments
        it   (1,1) Item %Item to calculate on
        t   (1,1) double %Current Time
        iter   (1,1) double %Iteration
        BRPerStep (1,1) double %Bit Rate Available at current time
    end
    Q = it.AoS(t);
    c = it.PPsi;
    Nt = it.SendCount;
    w = Q + c * sqrt(0.5 * log(t) / Nt);
end