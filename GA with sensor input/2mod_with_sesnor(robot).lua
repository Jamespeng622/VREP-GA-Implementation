-- For an example of snake controlled distributively, have a look at the ACM-R5 model!
function get_force(index)
    result,force,torque=sim.readForceSensor( bumper[index] )
    if (result>0) then
        return force[3]
    else return 0
    end   
end

if (sim_call_type==sim.syscb_init) then 
    femaleMotor={-1,-1}
    maleMotor={-1,-1}
    position = {}
    poszmax=0

    bumper={}
    bumper[1]=sim.getObjectHandle("Force_sensor1")
    bumper[2]=sim.getObjectHandle("Force_sensor2")
    bumper[3]=sim.getObjectHandle("Force_sensor3")
    bumper[4]=sim.getObjectHandle("Force_sensor4")

    dtto=sim.getObjectHandle("Maledyn001")
    for i=1,2,1 do
        femaleMotor[i]=sim.getObjectHandle("Female_joint" .. (i))
    end

    for i=1,2,1 do
        maleMotor[i]=sim.getObjectHandle("Male_joint" .. (i))
    end

    --Control Parameters:
    speed = 2
    amplitude = {}
    phase = {}
    for i=1,4,1 do
        amplitude[i] = 0
        phase[i] = 0
    end 
    
    AMP = {} --amp. in radian
    PHA = {} --phase in radian
    for i=1,4,1 do
        AMP[i] = amplitude[i]*math.pi/180
        PHA[i] = phase[i]*math.pi/180
    end

    --target position: Cuboid1 (last stair)
    target_x = 0.21
    target_z = 0.045
end 

if (sim_call_type==sim.syscb_cleanup) then 

end 

if (sim_call_type==sim.syscb_actuation) then 

    position = sim.getObjectPosition(dtto, -1)
    pos_x = position[1]
    pos_z = position[3]

    dist = ((pos_x-target_x)^2 + (pos_z-target_z)^2)^(1/2)
    mindist = 1000
    if(dist<mindist) then mindist = dist end
    
    wgt={}
    
    if(sim.getSimulationTime()%100 == 5) then   
        for i = 1,32,1 do
            wgt[i] = sim.getFloatSignal("wgt1_" .. tostring(i))
        end
        --    Amp.      |     Phase 
        --wgt[1,5,9,13] | [17,21,25,29] connected to maleMotor[1]
        --wgt[2,6,10,14]| [18,22,26,30] connected to femaleMotor[1]
        --wgt[3,7,11,15]| [19,23,27,31] connected to maleMotor[2]
        --wgt[4,8,12,16]| [20,24,28,32] connected to femaleMotor[2]
    end
    INPUT = {}
    for i = 1,4,1 do
        INPUT[i] = 0.6 + get_force(i) --modified sensor input
        --if(i<4) then
            --sim.addStatusbarMessage(INPUT[i]..',')
            --else
            --sim.addStatusbarMessage(INPUT[i]..'\n')
        --end
    end

    for i = 1,4,1 do
        amplitude[i] = wgt[i]*INPUT[1] + wgt[i+4]*INPUT[2] + wgt[i+8]*INPUT[3] + wgt[i+12]*INPUT[4]
        phase[i] = wgt[i+16]*INPUT[1] + wgt[i+20]*INPUT[2] + wgt[i+24]*INPUT[3] + wgt[i+28]*INPUT[4]
    end

    for i = 1,4,1 do
        AMP[i] = amplitude[i]*math.pi/180
        PHA[i] = phase[i]*math.pi/180
    end


    posz=position[3]
    if (posz>poszmax) then
        poszmax=posz
    end

    if(sim.getSimulationTime()%100 > 95) then -- reset all the parameters every 95 sec
        for i = 1, 2, 1 do
            AMP[i] = 0
            PHV[i] = 0
        end
        
        endPos_x = pos_X
        endPos_z = pos_z
        per = ((target_x - pos_x)^2 + (target_z - pos_z)^2)^(1/2)
        sim.setFloatSignal('per1', mindist)
        sim.addStatusbarMessage("r1 distance to target: "..tostring(mindist))


        robotObjects = sim.getObjectsInTree(dtto, sim.handle_all, 0)
        
        for i = 1,29,1 do
            sim.resetDynamicObject(robotObjects[i])
        end
        
        sim.setConfigurationTree(config)
        sim.setObjectPosition(dtto, -1, initpos)
    end
    
    for i=1,2,1 do 
        sim.setJointTargetPosition(maleMotor[i],(-AMP[i])*math.sin(sim.getSimulationTime()*(speed)+i*(PHA)+(PHA/2)))
        sim.setJointTargetPosition(femaleMotor[i],(AMP[i+1])*math.sin(sim.getSimulationTime()*(speed)+i*(PHA)))
    end
    
end 