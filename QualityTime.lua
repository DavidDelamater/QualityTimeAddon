
--[[ Declare the typical addon variables ]]--
local refresh_rate_hz = 4
local def_time_till_refresh = (1 / refresh_rate_hz)
local time_till_refresh = def_time_till_refresh
local def_time_till_refresh_loc = 1
local time_till_refresh_loc = def_time_till_refresh_loc
local default_settings = {
    x_pos = 0,
    y_pos = 0,
    height = 100,
    width = 100
}

--[[ Declare all of the variables used for tracking the state ]]--
local state_variables = {
    class = "MAGE",
    prev_zone = "Westfall",
    in_combat = false,
    full_resources = false,
    moved_far = false,
    mounted = false,
    state = "Idle"
}
local locations = {{1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}}

--[[ Create the main frame ]]--
local main_frame = CreateFrame("Frame", "MainFrame", UIParent, "OptionsBoxTemplate")
main_frame.title_frame = CreateFrame("Frame", "MainTitleFrame", main_frame)
main_frame.title_frame.text = main_frame.title_frame:CreateFontString(nil, "ARTWORK")
main_frame.name_text = main_frame:CreateFontString(nil, "ARTWORK")
main_frame.value_text = main_frame:CreateFontString(nil, "ARTWORK")
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED")
main_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local function UpdateMovedFar()
    -- SetMapToCurrentZone()
    -- Move the array of positions over one
    for i = #locations, 2, -1 do
        locations[i][1] = locations[i-1][1]
        locations[i][2] = locations[i-1][2]
    end
    -- Added the most recent location to the array
    loc_y, loc_x, _, _ = UnitPosition("player")
    locations[1][1] = loc_x
    locations[1][2] = loc_y
    -- Add up the differences between the points and average them
    avg_dist = 0
    for i = 1, #locations - 1, 1 do
        loc_x_1 = locations[i][1]
        loc_y_1 = locations[i][2]
        loc_x_2 = locations[i + 1][1]
        loc_y_2 = locations[i + 1][2]
        dist = math.sqrt(((loc_x_1 - loc_x_2)^2) + ((loc_y_1 - loc_y_2)^2))
        avg_dist = avg_dist + dist
    end
    avg_dist = avg_dist / (#locations - 1)
    -- If the difference is significant then we have moved far
    if (avg_dist > 5) then
        state_variables.moved_far = true
    else
        state_variables.moved_far = false
    end
end

local function UpdateFullResources()
    local health_perc = UnitHealth("player") / UnitHealthMax("player")
    local power_perc = UnitPower("player") / UnitPowerMax("player")
    state_variables.full_resources = true
    if (health_perc > 0.99) then
        if (state_variables.class ~= "WARRIOR") then
            if (power_perc < 0.99) then
                state_variables.full_resources = false
            end
        end
    else
        state_variables.full_resources = false
    end
end

local function UpdateMounted()
    state_variables.mounted = IsMounted()
end

local function UpdateState()
    if (state_variables.mounted == true) then
        state_variables.state = "Traveling"
    else
        if (state_variables.in_combat == true) then
            state_variables.state = "Combat"
        else
            if (state_variables.full_resources == false) then
                state_variables.state = "Regenerating"
            else
                if (state_variables.moved_far == true) then
                    state_variables.state = "Traveling"
                else
                    state_variables.state = "Idle"
                end
            end
        end
    end
end

local function UpdateMainFrameText()
    final_name_text = "State:\n\n" ..
                      "In Combat:\n" ..
                      "Full Resources:\n" ..
                      "Moved Far:\n" ..
                      "Mounted:"
    final_value_text = tostring(state_variables.state) .. "\n\n" ..
                       tostring(state_variables.in_combat) .. "\n" ..
                       tostring(state_variables.full_resources) .. "\n" ..
                       tostring(state_variables.moved_far) .. "\n" ..
                       tostring(state_variables.mounted)
    main_frame.name_text:SetText(final_name_text)
    main_frame.value_text:SetText(final_value_text)
end

local function MainFrame_Initialize(self)
    main_frame:SetWidth(200)
    main_frame:SetHeight(100)
    main_frame:SetPoint("CENTER", 0, 0)
    --[[
    main_frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4}
    })
    main_frame:SetBackdropColor(0,0,0,1)
    ]]--
    
    main_frame.title_frame:SetWidth(main_frame:GetWidth())
    main_frame.title_frame:SetHeight(25)
    main_frame.title_frame:SetPoint("TOP", 0, 0)
    main_frame.title_frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4}
    })
    main_frame.title_frame:SetBackdropColor(0,0,0,1)
    
    main_frame.name_text:SetFont("Interface\\Addons\\QualityTime\\Fonts\\Inconsolata-Regular.ttf", 14)
    main_frame.name_text:SetJustifyH("LEFT")
	main_frame.name_text:SetJustifyV("TOP")
    main_frame.name_text:SetPoint("TOPLEFT",10,-10)
    
    main_frame.value_text:SetFont("Interface\\Addons\\QualityTime\\Fonts\\Inconsolata-Regular.ttf", 14)
    main_frame.value_text:SetJustifyH("RIGHT")
	main_frame.value_text:SetJustifyV("TOP")
    main_frame.value_text:SetPoint("TOPRIGHT",-10, -10)
    
    main_frame.title_frame.text:SetFont("Interface\\Addons\\QualityTime\\Fonts\\Inconsolata-Regular.ttf", 14)
    main_frame.title_frame.text:SetJustifyH("LEFT")
	main_frame.title_frame.text:SetJustifyV("CENTER")
    main_frame.title_frame.text:SetText("QualityTime")
    main_frame.title_frame.text:SetPoint("LEFT",10, 0)
    
    main_frame:SetMovable(true)
    main_frame:EnableMouse(true)
    main_frame:RegisterForDrag("LeftButton")
    main_frame:Show()
end

local function MainFrame_OnEvent(self, event, ...)
    if (event == "PLAYER_ENTERING_WORLD") then
        MainFrame_Initialize()
        _, state_variables.class, _ = UnitClass("player")
    elseif (event == "PLAYER_REGEN_ENABLED") then
        state_variables.in_combat = false
    elseif (event == "PLAYER_REGEN_DISABLED") then
        state_variables.in_combat = true
    elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    end
end

local function MainFrame_OnUpdate(self, elapsed)
    time_till_refresh = time_till_refresh - elapsed
    time_till_refresh_loc = time_till_refresh_loc - elapsed
    if (time_till_refresh_loc < 0) then
        UpdateMovedFar()
        time_till_refresh_loc = def_time_till_refresh_loc
    end
    if (time_till_refresh < 0 ) then
        UpdateFullResources()
        UpdateMounted()
        UpdateState()
        UpdateMainFrameText()
        time_till_refresh = def_time_till_refresh
    else
        
    end
    
end

main_frame:SetScript("OnEvent", MainFrame_OnEvent)
main_frame:SetScript("OnUpdate", MainFrame_OnUpdate)
main_frame:SetScript("OnDragStart", main_frame.StartMoving)
main_frame:SetScript("OnDragStop", main_frame.StopMovingOrSizing)