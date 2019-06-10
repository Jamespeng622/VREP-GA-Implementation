--initialize function (call once)
function initialize()
    
    Num_robot = 4
    
    math.randomseed(os.time())
    teststr='gene:'

    reversed = false

    gene = {}
    for i = 1, Num_robot, 1 do
        gene[i] = {}
    end

    for i = 1, Num_robot, 1 do
        for j = 1, 128, 1 do
            gene[i][j] = math.random(2)%2
        end
    end
    -- Encoding:
    -- Amp  | Phase
    -- 01-04  65-68: bumper1-motor1's weight       
    -- 05-08  69-72: bumper1-motor2's weight       
    -- 09-12  73-76: bumper1-motor3's weight       
    -- 13-16  77-80: bumper1-motor4's weight       
    -- Amp  | Phase 
    -- 17-20  81-84: bumper2-motor1's weight       
    -- 21-24  85-88: bumper2-motor2's weight       
    -- 25-28  89-92: bumper2-motor3's weight      
    -- 29-32  93-96: bumper2-motor4's weight 
    -- Amp  | Phase
    -- 33-36  97-100 : bumper3-motor1's weight
    -- 37-40  101-104: bumper3-motor2's weight
    -- 41-44  105-108: bumper3-motor3's weight
    -- 45-48  109-112: bumper3-motor4's weight
    -- Amp  | Phase
    -- 49-52  113-116: bumper4-motor1's weight
    -- 53-56  117-120: bumper4-motor2's weight
    -- 57-60  121-124: bumper4-motor3's weight
    -- 61-64  125-128: bumper4-motor4's weight
end

--fliping function, for quicker bitwise operation
function flip(n)
    if n == 1 then
        return 0
    else return 1
    end
end


function reverse(index)
    g = {}
    for i = 1, 128, 1 do
        g[i] = gene[index][128-i]
    end
    
    for i = 1, 128, 1 do
        gene[index][i] = g[i]
    end
end




--reads an index, then returns gene as a string
function getGene(index, mode)
    local g = ' '

    if(mode == 1) then
        g = 'Gene '
        g = g..tostring(index)
        g = g..': '
    else 
        g = ''
    end

    for i = 1, 128, 1 do
        g = g..tostring(gene[index][i])
    end

    return g
end

--crossover function with integrated mutate function
--directly alters our gene pool
--p1, p2 are parents / w1, w2 are worst cases 
--read p1, p2, w1, w2 as indexes
function crossover(p1, p2, w1, w2)
    local crossoverPoint1 = 0
    local crossoverPoint2 = 0
    local mutateRate = 40
    local reverseRate = 30
    local mutatePoint = 0
    local c1 = {}
    local c2 = {}
    reversed = false
    math.randomseed(os.time())
    crossoverPoint1 = 1 + math.random(128)%64
    crossoverPoint2 = 65 + math.random(128)%64
    for i = 1, crossoverPoint1, 1 do
        c1[i] = gene[p1][i]
        c2[i] = gene[p2][i]
    end

    for i = crossoverPoint1+1, crossoverPoint2, 1 do
        c1[i] = gene[p2][i]
        c2[i] = gene[p1][i]
    end

    for i = crossoverPoint2+1, 128, 1 do
        c1[i] = gene[p1][i]  
        c2[i] = gene[p2][i]  
    end
    -- c1 = p1-p2-p1
    -- c2 = p2-p1-p2

    if(math.random(1000)%100 <= mutateRate) then
        mutatePoint = 1 + math.random(256)%128
        c1[mutatePoint] = flip(c1[mutatePoint])
    end

    if(math.random(1000)%100 <= mutateRate) then
        mutatePoint = 1 + math.random(256)%128
        c2[mutatePoint] = flip(c2[mutatePoint])
    end

    for j = 1, 128, 1 do
        gene[w1][j] = c2[j]
        gene[w2][j] = c1[j]
    end
    -- gene[w1] = c2 (p2-p1-p2)
    -- gene[w2] = c1 (p1-p2-p1)

    if(math.random(1000)%100 <= reverseRate) then
        reverse(w2)
        reversed = true
    end
end


--fitness function gets the fitness of the current gen
--then it sorts through it and returns best and worst
--returns p1, p2, w1, w2 as indexes
function fitness()
    local p1 = 0
    local p2 = 0
    local w1 = 0
    local w2 = 0
    local temp = 0
    local rtemp = 0
    local per = {}
    local rank = {}

    for i = 1, Num_robot, 1 do
        rank[i] = i
    end

    for i = 1, Num_robot, 1 do
        per[i] = sim.getFloatSignal('per' .. tostring(i)) --minimal distance toward target   
    end
    
    for i = 1, Num_robot, 1 do
        for j = 1, Num_robot, 1 do
            if(per[j] > per[j+1]) then
                temp = per[j+1]
                per[j+1] = per[j]
                per[j] = temp

                rtemp = rank[j+1]
                rank[j+1] = rank[j]
                rank[j] = rtemp
            end
        end
    end

    return rank[1], rank[2], rank[8], rank[7]  --index of p1, p2, w1, w2
end


--parses the binary gene and returns decimal
function parseWgt(index, wgt_num)  --index : robot's ID; wgt_num :1~32
    local wgt = 0
    for i = 1, 4, 1 do
        wgt = wgt + (2^(4-i)*gene[index][wgt_num*4-4+i])
    end
    wgt = wgt / 16 --scaling ( wgt ranges from 0 to 1)
    return wgt
end


function feedSignal()
    for i = 1,Num_robot,1 do  --total num of robots
        for j = 1,32,1 do   --num of weights per robot
            sim.setFloatSignal( "wgt" .. tostring(i) .. '_' .. tostring(j), parseWgt(i,j) ) --output format: wgt1_1
        end
    end
end



function sysCall_init()
    sim.setIntegerSignal('generation', 0)
    
    --Saves the performance of the robots
    for i = 1,Num_robot,1 do
        sim.setFloatSignal('per' .. tostring(i), 0.0)
    end
    

    initialize()
    feedSignal()
    p1 = 0
    p2 = 0
    w1 = 0
    w2 = 0
    
    sim.addStatusbarMessage('[Generation ' .. tostring(sim.getIntegerSignal('generation')..']'))
    for i = 1, Num_robot, 1 do
        sim.addStatusbarMessage(getGene(i, 1))
        --sim.addStatusbarMessage(tostring(gene[i][84]))
    end

    currentGen = tostring(sim.getIntegerSignal('generation'))
    bestNum = ' '
    bestGene = ' '
    bestSetLow = ' '
    bestSetHigh = ' '
    bestRate = ' '
    bestPer = ' '
    parents = ' '
    eliminated = ' '
    reversedStr = ' ' 
    stateArr = {'Initializing...', 'Running...', 'Computing...', 'Sending...'}
    state = stateArr[1]

    console = 0
    
    console = sim.auxiliaryConsoleOpen('Stair Ditto', 15, 2, nil, nil, nil, nil)
    sim.auxiliaryConsolePrint(console, 'Current Generation: ' .. tostring(0) .. '\n')
    sim.auxiliaryConsolePrint(console, 'Simulation Time: ' .. tostring(sim.getSimulationTime()) .. '\n')
    sim.auxiliaryConsolePrint(console, 'Current State: ' .. state .. '\n')
    sim.auxiliaryConsolePrint(console, '\n')
    sim.auxiliaryConsolePrint(console, '--Last Generation Stats--\n')
    sim.auxiliaryConsolePrint(console, 'Best Robot#: ')
    sim.auxiliaryConsolePrint(console, '\nBest Gene: ')
    sim.auxiliaryConsolePrint(console, '\nBest Set#1(low): ')
    sim.auxiliaryConsolePrint(console, '\nBest Set#2(high): ')
    sim.auxiliaryConsolePrint(console, '\nBest Rates: ')
    sim.auxiliaryConsolePrint(console, '\nBest Performance: ')
    sim.auxiliaryConsolePrint(console, '\nParents(p1, p2): ')
    sim.auxiliaryConsolePrint(console, '\nEliminated(w1, w2): ')
    sim.auxiliaryConsolePrint(console, '\nReversed: \n')
    
end



function sysCall_actuation()
    
    --print results here
    sim.auxiliaryConsolePrint(console, 'Current Generation: '..currentGen..'\n')
    sim.auxiliaryConsolePrint(console, 'Simulation Time: '..tostring(sim.getSimulationTime())..'\n')
    sim.auxiliaryConsolePrint(console, 'Current State: '..state..'\n')
    sim.auxiliaryConsolePrint(console, '\n')
    sim.auxiliaryConsolePrint(console, '--Last Generation Stats--\n')
    sim.auxiliaryConsolePrint(console, 'Best Robot#: '..bestNum)
    sim.auxiliaryConsolePrint(console, '\nBest Gene: '..bestGene)
    sim.auxiliaryConsolePrint(console, '\nBest Set#1(low): '..bestSetLow)
    sim.auxiliaryConsolePrint(console, '\nBest Set#2(high): '..bestSetHigh)
    sim.auxiliaryConsolePrint(console, '\nBest Rates: '..bestRate)
    sim.auxiliaryConsolePrint(console, '\nBest Performance: '..bestPer)
    sim.auxiliaryConsolePrint(console, '\nParents(p1, p2): '..parents)
    sim.auxiliaryConsolePrint(console, '\nEliminated(w1, w2): '..eliminated)
    sim.auxiliaryConsolePrint(console, '\nReversed: '..reversedStr..'\n')
    --finish printing
    

    if(sim.getSimulationTime()%100 == 5) then
        state = stateArr[2]
    end


    if(sim.getSimulationTime()%100 == 95) then
        state = stateArr[4]
    end


    if((sim.getSimulationTime()%100 == 0) and (sim.getSimulationTime() > 0)) then
        p1, p2, w1, w2 = fitness()
        
        state = stateArr[3]
        currentGen = tostring(sim.getIntegerSignal('generation')+1)
        bestNum = tostring(p1)
        bestGene = getGene(p1, 0)
        bestPer = tostring(sim.getFloatSignal('per'..tostring(p1)))
        parents = tostring(p1)..', '..tostring(p2)
        eliminated = tostring(w1)..', '..tostring(w2)
        if(reversed == true) then
            reversedStr = 'true'
            else reversedStr = 'false'
        end
        
        --print results here
        sim.auxiliaryConsolePrint(console, 'Current Generation: '..currentGen..'\n')
        sim.auxiliaryConsolePrint(console, 'Simulation Time: '..tostring(sim.getSimulationTime())..'\n')
        sim.auxiliaryConsolePrint(console, 'Current State: '..state..'\n')
        sim.auxiliaryConsolePrint(console, '\n')
        sim.auxiliaryConsolePrint(console, '--Last Generation Stats--\n')
        sim.auxiliaryConsolePrint(console, 'Best Robot#: '..bestNum)
        sim.auxiliaryConsolePrint(console, '\nBest Gene: '..bestGene)
        sim.auxiliaryConsolePrint(console, '\nBest Performance: '..bestPer)
        sim.auxiliaryConsolePrint(console, '\nParents(p1, p2): '..parents)
        sim.auxiliaryConsolePrint(console, '\nEliminated(w1, w2): '..eliminated)
        sim.auxiliaryConsolePrint(console, '\nReversed: '..reversedStr..'\n')
        --finish printing
        
        crossover(p1, p2, w1, w2)
        feedSignal()
        sim.setIntegerSignal('generation', sim.getIntegerSignal('generation') + 1)

        sim.addStatusbarMessage('[Generation '..tostring(sim.getIntegerSignal('generation')..']'))
        
        for i = 1, Num_robot, 1 do
        sim.addStatusbarMessage(getGene(i, 1))
        --sim.addStatusbarMessage(tostring(gene[i][84]))
        end

    end

end

function sysCall_sensing()
    -- put your sensing code here
end

function sysCall_cleanup()
    -- do some clean-up here
end