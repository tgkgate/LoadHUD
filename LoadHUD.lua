-- Load HUD for FS22
--
-- Small HUD which shows current engine load in percent. The shown value is the average of the last 60 frames.
--
-- Author: StingerTopGun

LoadHUD = {}
LoadHUD.eventName = {}
LoadHUD.ModName = g_currentModName
LoadHUD.ModDirectory = g_currentModDirectory
LoadHUD.Version = "1.0.0.0"			

LoadHUD.loopcnt = 0
LoadHUD.average_cnt = 60
LoadHUD.values = {}

function LoadHUD:draw()
	if g_client ~= nil and g_currentMission.hud.isVisible and g_currentMission.controlledVehicle ~= nil then

        -- calculate position and size
        local posX = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterX
        local posY = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterY - (g_currentMission.inGameMenu.hud.speedMeter.speedIndicatorRadiusY * 1)
        local size = 0.013 * g_gameSettings.uiScale

        -- add current load to table
        LoadHUD.values[LoadHUD.loopcnt] = g_currentMission.controlledVehicle.rootVehicle:getMotorLoadPercentage()

        if LoadHUD.loopcnt < LoadHUD.average_cnt then
            LoadHUD.loopcnt = LoadHUD.loopcnt + 1
        else
            LoadHUD.loopcnt = 0
        end

        local load_text = string.format("%.0f", LoadHUD.mean(LoadHUD.values) * 100) .. " %"

        -- render
        setTextColor(1,1,1,1)
        setTextAlignment(RenderText.ALIGN_CENTER)
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)
        setTextBold(false)
        renderText(posX, posY, size, load_text)
        
        -- Back to defaults
        setTextColor(1,1,1,1)
        setTextAlignment(RenderText.ALIGN_LEFT)
        setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
        setTextBold(false)

	end
end

-- Get the mean value of a table
function LoadHUD.mean( t )
    local sum = 0
    local count= 0

    for k,v in pairs(t) do
        if type(v) == 'number' then
            sum = sum + v
            count = count + 1
        end
    end

    return (sum / count)
end

addModEventListener(LoadHUD)