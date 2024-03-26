%% Scenario Basics
% Minimum Delay to add per iteration of simulation [s]
DelayPhysDist = 2;
% Number of Relays to incorporate in simulation [#]
RelayCountMin = 0;
RelayCountMax = 3;
% Delay per relay hop [s]
DelayRelayMin = 0.1;
DelayRelayMax = 0.2;
% Bit Rate per time slot (data size) [Mbps]
BRMin = 4; 
BRMax = 20;
BRStep = 4;

%% RNG Setup
% Randomness Seed (for repeatability)
RSeed = 1234;
% RNG Initializer
rng(RSeed, "simdTwister");

%% Mission Setup
% The time step resolution for simulation
TimeStep = .1;
% Max Time for simulation [s]
MaxTime = 60;
% Items to be synced in sim (Make > 5 for random item additions)
MaxItems = 5;