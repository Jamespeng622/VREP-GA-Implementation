-- For an example of snake controlled distributively, have a look at the ACM-R5 model!

if (sim_call_type==sim.syscb_init) then 
    femaleMotor={-1,-1}
    maleMotor={-1,-1}

    dtto = sim.getObjectHandle("Maledyn001")
    initpos = sim.getObjectPosition(dtto, -1)
    config = sim.getConfigurationTree(dtto)

    for i=1,4,1 do
        femaleMotor[i]=sim.getObjectHandle("Female_joint"..(i))
    end

    for i=1,4,1 do
        maleMotor[i]=sim.getObjectHandle("Male_joint"..(i))
    end
    
    t=0
    -- Control Parameters:
    speed = 1.5

    --four sets, one for each joint
    amplitude_h = {}
    amplitude_v = {}
    phase_h = {}
    phase_v = {}
    A_H = {}
    A_V = {}
    P_H = {}
    P_V = {}

    --initialize four sets
    for i = 1, 4, 1 do
        amplitude_h[i] = 0
        amplitude_v[i] = 0
        phase_h[i] = 0
        phase_v[i] = 0
    end

    --initialize for robot control(always call when changed)
    for i = 1, 4, 1 do
        A_H[i] = amplitude_h[i]*math.pi/180
        A_V[i] = amplitude_v[i]*math.pi/180
        P_H[i] = phase_h[i]*math.pi/180
        P_V[i] = phase_v[i]*math.pi/180
    end

    phase_cam={180,180}
    P_C={phase_cam[1]*math.pi/180,phase_cam[2]*math.pi/180}
end 

if (sim_call_type==sim.syscb_cleanup) then 

end 

if (sim_call_type==sim.syscb_actuation) then 
    --t=t+sim.getSimulationTimeStep()
    
    position = sim.getObjectPosition(dtto, -1)
    pos_x = position[1]
    pos_z = position[3]
    --Change this part
    --You can copy and paste this part to change value at different times
    --Use sim.getSimulationTime() == x for absolute time
    --Use sim.getSimulationTime() % cycle == x for cycle time
    --Good luck!
    if(sim.getSimulationTime() == 0) then
        amplitude_h[1] = 70;
        amplitude_v[1] = 70;
        phase_h[1] = 150;
        phase_v[1] = 150;

        amplitude_h[2] = amplitude_h[1];
        amplitude_v[2] = amplitude_v[1];
        phase_h[2] = phase_h[1];
        phase_v[2] = phase_v[1];

        amplitude_h[3] = 50;
        amplitude_v[3] = 50;
        phase_h[3] = 150;
        phase_v[3] = 150;

        amplitude_h[4] = amplitude_h[3];
        amplitude_v[4] = amplitude_v[3];
        phase_h[4] = phase_h[3];
        phase_v[4] = phase_v[3];
        

        --For robot control(always call when changed)
        --Don't change this part!
        for i = 1, 4, 1 do
            A_H[i] = amplitude_h[i]*math.pi/180
            A_V[i] = amplitude_v[i]*math.pi/180
            P_H[i] = phase_h[i]*math.pi/180
            P_V[i] = phase_v[i]*math.pi/180
        end
    end
    --End of the part you want to copy

    if(sim.getSimulationTime() > 38) then
        amplitude_h[1] = 50;
        amplitude_v[1] = 50;
        phase_h[1] = 150;
        phase_v[1] = 150;

        amplitude_h[2] = amplitude_h[1];
        amplitude_v[2] = amplitude_v[1];
        phase_h[2] = phase_h[1];
        phase_v[2] = phase_v[1];

        amplitude_h[3] = 90;
        amplitude_v[3] = 0;
        phase_h[3] = 150;
        phase_v[3] = 150;

        amplitude_h[4] = amplitude_h[3];
        amplitude_v[4] = amplitude_v[3];
        phase_h[4] = phase_h[3];
        phase_v[4] = phase_v[3];
        

        --For robot control(always call when changed)
        --Don't change this part!
        for i = 1, 4, 1 do
            A_H[i] = amplitude_h[i]*math.pi/180
            A_V[i] = amplitude_v[i]*math.pi/180
            P_H[i] = phase_h[i]*math.pi/180
            P_V[i] = phase_v[i]*math.pi/180
        end
    end

    if(sim.getSimulationTime() > 56) then
        amplitude_h[1] = 70;
        amplitude_v[1] = 70;
        phase_h[1] = 150;
        phase_v[1] = 150;

        amplitude_h[2] = amplitude_h[1];
        amplitude_v[2] = amplitude_v[1];
        phase_h[2] = phase_h[1];
        phase_v[2] = phase_v[1];

        amplitude_h[3] = 50;
        amplitude_v[3] = 50;
        phase_h[3] = 150;
        phase_v[3] = 150;

        amplitude_h[4] = amplitude_h[3];
        amplitude_v[4] = amplitude_v[3];
        phase_h[4] = phase_h[3];
        phase_v[4] = phase_v[3];
        

        --For robot control(always call when changed)
        --Don't change this part!
        for i = 1, 4, 1 do
            A_H[i] = amplitude_h[i]*math.pi/180
            A_V[i] = amplitude_v[i]*math.pi/180
            P_H[i] = phase_h[i]*math.pi/180
            P_V[i] = phase_v[i]*math.pi/180
        end
    end

    if(sim.getSimulationTime() > 65) then
        amplitude_h[1] = 70;
        amplitude_v[1] = 70;
        phase_h[1] = 150;
        phase_v[1] = 150;

        amplitude_h[2] = amplitude_h[1];
        amplitude_v[2] = amplitude_v[1];
        phase_h[2] = phase_h[1];
        phase_v[2] = phase_v[1];

        amplitude_h[3] = 90;
        amplitude_v[3] = 0;
        phase_h[3] = 150;
        phase_v[3] = 150;

        amplitude_h[4] = amplitude_h[3];
        amplitude_v[4] = amplitude_v[3];
        phase_h[4] = phase_h[3];
        phase_v[4] = phase_v[3];
        

        --For robot control(always call when changed)
        --Don't change this part!
        for i = 1, 4, 1 do
            A_H[i] = amplitude_h[i]*math.pi/180
            A_V[i] = amplitude_v[i]*math.pi/180
            P_H[i] = phase_h[i]*math.pi/180
            P_V[i] = phase_v[i]*math.pi/180
        end
    end

    if(sim.getSimulationTime() > 100) then
        amplitude_h[1] = 0;
        amplitude_v[1] = 0;
        phase_h[1] = 150;
        phase_v[1] = 150;

        amplitude_h[2] = amplitude_h[1];
        amplitude_v[2] = amplitude_v[1];
        phase_h[2] = phase_h[1];
        phase_v[2] = phase_v[1];

        amplitude_h[3] = 50;
        amplitude_v[3] = 50;
        phase_h[3] = 150;
        phase_v[3] = 150;

        amplitude_h[4] = amplitude_h[3];
        amplitude_v[4] = amplitude_v[3];
        phase_h[4] = phase_h[3];
        phase_v[4] = phase_v[3];
        

        --For robot control(always call when changed)
        --Don't change this part!
        for i = 1, 4, 1 do
            A_H[i] = amplitude_h[i]*math.pi/180
            A_V[i] = amplitude_v[i]*math.pi/180
            P_H[i] = phase_h[i]*math.pi/180
            P_V[i] = phase_v[i]*math.pi/180
        end
    end

    if(sim.getSimulationTime() > 120) then
        amplitude_h[1] = 50;
        amplitude_v[1] = 50;
        phase_h[1] = 150;
        phase_v[1] = 150;

        amplitude_h[2] = amplitude_h[1];
        amplitude_v[2] = amplitude_v[1];
        phase_h[2] = phase_h[1];
        phase_v[2] = phase_v[1];

        amplitude_h[3] = 50;
        amplitude_v[3] = 50;
        phase_h[3] = 150;
        phase_v[3] = 150;

        amplitude_h[4] = 0;
        amplitude_v[4] = 0;
        phase_h[4] = phase_h[3];
        phase_v[4] = phase_v[3];
        

        --For robot control(always call when changed)
        --Don't change this part!
        for i = 1, 4, 1 do
            A_H[i] = amplitude_h[i]*math.pi/180
            A_V[i] = amplitude_v[i]*math.pi/180
            P_H[i] = phase_h[i]*math.pi/180
            P_V[i] = phase_v[i]*math.pi/180
        end
    end

    if(sim.getSimulationTime() > 140) then
        amplitude_h[1] = 0;
        amplitude_v[1] = 0;
        phase_h[1] = 150;
        phase_v[1] = 150;

        amplitude_h[2] = amplitude_h[1];
        amplitude_v[2] = amplitude_v[1];
        phase_h[2] = phase_h[1];
        phase_v[2] = phase_v[1];

        amplitude_h[3] = 50;
        amplitude_v[3] = 50;
        phase_h[3] = 150;
        phase_v[3] = 150;

        amplitude_h[4] = 50;
        amplitude_v[4] = 50;
        phase_h[4] = phase_h[3];
        phase_v[4] = phase_v[3];
        

        --For robot control(always call when changed)
        --Don't change this part!
        for i = 1, 4, 1 do
            A_H[i] = amplitude_h[i]*math.pi/180
            A_V[i] = amplitude_v[i]*math.pi/180
            P_H[i] = phase_h[i]*math.pi/180
            P_V[i] = phase_v[i]*math.pi/180
        end
    end

    if(sim.getSimulationTime() > 150) then
        amplitude_h[1] = 50;
        amplitude_v[1] = 50;
        phase_h[1] = 150;
        phase_v[1] = 150;

        amplitude_h[2] = amplitude_h[1];
        amplitude_v[2] = amplitude_v[1];
        phase_h[2] = phase_h[1];
        phase_v[2] = phase_v[1];

        amplitude_h[3] = 50;
        amplitude_v[3] = 50;
        phase_h[3] = 150;
        phase_v[3] = 150;

        amplitude_h[4] = 0;
        amplitude_v[4] = 0;
        phase_h[4] = phase_h[3];
        phase_v[4] = phase_v[3];
        
        --For robot control(always call when changed)
        --Don't change this part!
        for i = 1, 4, 1 do
            A_H[i] = amplitude_h[i]*math.pi/180
            A_V[i] = amplitude_v[i]*math.pi/180
            P_H[i] = phase_h[i]*math.pi/180
            P_V[i] = phase_v[i]*math.pi/180
        end
    end

    --Reset robot here with resetTime
    resetTime = 1000
    if(sim.getSimulationTime()%resetTime == 0) then
        robotObjects = sim.getObjectsInTree(dtto, sim.handle_all, 0)
        
        for i=1, 43, 1 do
            sim.resetDynamicObject(robotObjects[i])
        end
        
        sim.setConfigurationTree(config)
        sim.setObjectPosition(dtto, -1, initpos)
    end
    --end of reset code

    for i=1,4,1 do 
        sim.setJointTargetPosition(maleMotor[i], A_V[i] * math.sin(sim.getSimulationTime()*speed + i*P_V[i]))
        sim.setJointTargetPosition(femaleMotor[i], A_H[i] * math.cos(sim.getSimulationTime()*speed + i*P_H[i]))
    end
    --sim.addStatusbarMessage('t='..t)
end 
