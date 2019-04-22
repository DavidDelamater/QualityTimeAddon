local in_combat = false
local refresh_rate_hz = 5
local time_till_refresh = (1 / refresh_rate_hz)

--[[ Create the main frame ]]--
local main_frame = CreateFrame("Frame", "MainFrame", UIParent)
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED")
main_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local function MainFrame_Initialize(self)
    print("Loaded")
end

local function MainFrame_OnEvent(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        MainFrame_Initialize()
    elseif (event == "PLAYER_REGEN_ENABLED") then
        in_combat = false
    elseif (event == "PLAYER_REGEN_DISABLED") then
        in_combat = true
    elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    end
end

local function MainFrame_OnUpdate(self, elapsed)
    time_till_refresh = time_till_refresh - elapsed
    if (time_till_refresh < 0 ) then
    else
        
    end
end

main_frame:SetScript("OnEvent", MainFrame_OnEvent)
main_frame:SetScript("OnUpdate", MainFrame_OnUpdate)