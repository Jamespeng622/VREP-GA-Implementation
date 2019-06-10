-- For an example of snake controlled distributively, have a look at the ACM-R5 model!

-- get bumper value 
function get_force(index) 
    result,force,torque=sim.readForceSensor( bumper[index] )
    if (result>0) then
        return force[3] --force along z-axis
    else return 0
    end   
end

if (sim_call_type==sim.syscb_init) then 
    femaleMotor={-1,-1}
    maleMotor={-1,-1}
    poszmax=0
    --file init (change here)
    file = io.open('C:/Users/Administrator/Desktop/test_force_output.txt', 'w')
    file:write('')
    file:close()
    --file close
    bumper={}
    bumper[1]=sim.getObjectHandle("Force_sensor1")
    bumper[2]=sim.getObjectHandle("Force_sensor2")
    bumper[3]=sim.getObjectHandle("Force_sensor3")
    bumper[4]=sim.getObjectHandle("Force_sensor4")
    dtto=sim.getObjectHandle("Maledyn001")
    for i=1,2,1 do
        femaleMotor[i]=sim.getObjectHandle("Female_joint"..(i))
    end

    for i=1,2,1 do
        maleMotor[i]=sim.getObjectHandle("Male_joint"..(i))
    end
    t=0
    -- 2 sets of control Parameters:
    speed={2,2} --velocidad
    --ampitude_h={40,0} -- max90
    ampitude_v={40,0}
    phase_v={180,0}
    --phase_h={90,0}
    --phase_cam={180,180}
    --Inputs for the function control (in radians) (also 2 sets)
    --A_H={ampitude_h[1]*math.pi/180,ampitude_h[2]*math.pi/180}
    A_V={ampitude_v[1]*math.pi/180,ampitude_v[2]*math.pi/180}
    P_V={phase_v[1]*math.pi/180,phase_v[2]*math.pi/180}
    --P_H={phase_h[1]*math.pi/180,phase_h[2]*math.pi/180}
    --P_C={phase_cam[1]*math.pi/180,phase_cam[2]*math.pi/180}
    s=0 -- if s=0 we use the first set of parameters, if s=1 we use the second set of parameters

end 

if (sim_call_type==sim.syscb_cleanup) then 

end 

if (sim_call_type==sim.syscb_actuation) then 
    t=t+sim.getSimulationTimeStep()
    position=sim.getObjectPosition(dtto, -1)
    pos=position[1]
    for i= 1,4,1 do
        a = 0.6+get_force(i) --offset
        --output to file (change here)
        file = io.open('C:/Users/Administrator/Desktop/test_force_output.txt', 'a') --change path
        --output format
        if(i<4) then
            file:write(a..',')
            else
            file:write(a..'\n')
        end
        file:close()
        --sim.addStatusbarMessage('force'..i..'='..a)
    end
    posz=position[3]
    if (posz>poszmax) then
        poszmax=posz
    end
    
    for i=1,2,1 do 
        sim.setJointTargetPosition(femaleMotor[i],(A_V[1])*math.sin(t*(speed[1])+i*(P_V[1])))
        sim.setJointTargetPosition(maleMotor[i],(-A_V[1])*math.sin(t*(speed[1])+i*(P_V[1])+(P_V[1]/2)))
    end

    sim.addStatusbarMessage('t='..t)
    sim.addStatusbarMessage('pos='..pos)
    sim.addStatusbarMessage('poszmax='..poszmax)
end 