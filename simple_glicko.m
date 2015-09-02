%simple glicko implementation 

% init constants
global q = log(10) / 400

%define functions
function[g] = g(opponent)
  disp("g() Called")
  global q
  g = 1 / sqrt( 1 + 3 * q^2 * opponent.RD^2 / pi^2 )
endfunction

function [E] = E(player, opponent)
  disp("E() Called")
  tempExponent = -g(opponent)*(player.r - opponent.r) / 400
  E = 1 / (1 + 10 ^  tempExponent)
endfunction

function [dSqr] = dSqr(player, opponents, matches)
  disp("dSqr() Called")
  global q
  dSqr = 0
  matchesSum = 0
  for match = matches
    opponent = opponents(match.opponent)
    matchesSum = matchesSum + (g(opponent) ^ 2) * E(player, opponent) * (1 - E(player, opponent))
  endfor
  dSqr = (q^2 * matchesSum) ^ -1
endfunction

function [r] = r(player, opponents, matches)
  disp("r() called")
  global q
  matchesSum = 0
  
  for match = matches
    opponent = opponents(match.opponent)
    matchesSum = matchesSum + g(opponent) * (match.outcome - E(player,opponent))
  endfor
  
  tempR1 = q / (1 / (player.RD ^ 2) + (1 / dSqr(player, opponents, matches)))
  tempR2 = tempR1 * matchesSum;
  disp(tempR2)
  r = player.r + tempR2 
endfunction

function [RD] = RD(player, opponents, matches)
  disp("RD() called")
  RD = sqrt(((1 / player.RD ^ 2) + 1 / dSqr(player, opponents, matches)) ^ -1)
endfunction

#define test function
function runTest()
  disp("runTest() called")
  #do test calculations
  opponents(1).r = 1400
  opponents(1).RD = 30
  opponents(2).r = 1550
  opponents(2).RD = 100
  opponents(3).r = 1700
  opponents(3).RD = 300

  player.r = 1500
  player.RD = 200

  matches(1).opponent = 1
  matches(1).outcome = 1
  matches(2).opponent = 2
  matches(2).outcome = 0
  matches(3).opponent = 3
  matches(3).outcome = 0


  testNewR = r(player, opponents, matches);
  testNewRD = RD(player, opponents, matches);
  
  disp(testNewR)
  disp(testNewRD)
endfunction

#run test
runTest()










