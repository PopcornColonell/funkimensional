local reload = false
local hell = false

function onMoveCamera(char)
    if reload == true then
        setProperty('defaultCamZoom', 2)   
    end
    if hell == false then
        if reload == false then
            if char == 'dad' then
                setProperty('defaultCamZoom', 0.55)   
            else
                setProperty('defaultCamZoom', 0.475)
            end
        end
    end
    if hell == true then
        if reload == false then
            if char == 'dad' then
                setProperty('defaultCamZoom', 0.5)   
            else
                setProperty('defaultCamZoom', 0.85)
            end
        end
    end
end

function onCreate()
    setProperty('camZooming', true)
    makeVideoSprite("tag", "cutesenahellclown", 0, 0, "camHUD")
end

function onBeatHit()
    if curBeat == 576 then              
        reload = true
    end
    if curBeat == 588 then              
        hell = true
        reload = false
    end
end