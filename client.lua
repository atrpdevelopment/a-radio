ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local radioMenu = false
local onRadio = false
local RadioChannel = 0
local RadioVolume = 50
local hasRadio = false
local radioProp = nil

--Function
local function LoadAnimDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[#t+1] = str
    end
    return t
end

local function connecttoradio(channel)
    RadioChannel = channel
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        onRadio = true
    end
    exports["pma-voice"]:setRadioChannel(channel)
    if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(channel), ".")[2] ~= "" then
        exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
		exports['mythic_notify']:DoCustomHudText ('inform', Config.messages['joined_to_radio'] ..channel.. ' MHz', 5000)
    else
        exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
		exports['mythic_notify']:DoCustomHudText ('inform', Config.messages['joined_to_radio'] ..channel.. '.00 MHz', 5000) 
    end
end

local function closeEvent()
	TriggerEvent("InteractSound_CL:PlayOnOne","click",0.6)
end

local function leaveradio()
    closeEvent()
    RadioChannel = nil
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:SetMumbleProperty("radioEnabled", false)
	SendNUIMessage({type = "update", putanginamo = ""})
	exports['mythic_notify']:DoCustomHudText ('error', Config.messages['you_leave'], 5000) 
end

local function toggleRadioAnimation(pState)
	LoadAnimDic("cellphone@")
	if pState then
		TriggerEvent("attachItemRadio","radio01")
		TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPedId())
		if radioProp ~= 0 then
			DeleteObject(radioProp)
			radioProp = 0
		end
	end
end

local function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    if radioMenu then
        toggleRadioAnimation(true)
        SendNUIMessage({type = "open"})
    else
        toggleRadioAnimation(false)
        SendNUIMessage({type = "close"})
    end
end

local function IsRadioOn()
    return onRadio
end

RegisterNetEvent('atrp_inventory:itemCheck')
AddEventHandler('atrp_inventory:itemCheck', function (item, state, quantity)
    if item ~= "radio"then return end
    if state or quantity > 0 then return end
	if RadioChannel ~= nil then
		leaveradio()
	end
end)

--Exports
exports("IsRadioOn", IsRadioOn)

RegisterNetEvent('a-radio:getCurrentFrequency')
AddEventHandler('a-radio:getCurrentFrequency', function(to)
	TriggerServerEvent('a-radio:transferFrequency', to, RadioChannel)
end)

RegisterNetEvent('a-radio:setFrequency')
AddEventHandler('a-radio:setFrequency', function(frequency)
	if frequency ~= nil then
		if RadioChannel == nil then
			exports["pma-voice"]:setRadioChannel(frequency)
			RadioChannel = frequency
			SendNUIMessage({type = "update", putanginamo = RadioChannel})
            exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
			exports['mythic_notify']:DoCustomHudText ('inform', Config.messages['joined_to_radio'] ..frequency.. ' MHz', 5000)			
		elseif RadioChannel ~= nil then
			closeEvent()
			exports["pma-voice"]:setRadioChannel(frequency)
			RadioChannel = frequency
			SendNUIMessage({type = "update", putanginamo = RadioChannel})
            exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
			exports['mythic_notify']:DoCustomHudText ('inform', Config.messages['joined_to_radio'] ..frequency.. ' MHz', 5000)
		end
	end

end)

RegisterNetEvent('a-radio:removeRadio')
AddEventHandler('a-radio:removeRadio', function()

	if RadioChannel ~= nil then
		leaveradio()
	end

end)

RegisterNetEvent('a-radio:encryptRadio')
AddEventHandler('a-radio:encryptRadio', function(targetChannel)

  if RadioChannel == targetChannel then
    closeEvent()
    RadioChannel = nil
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:SetMumbleProperty("radioEnabled", false)
    exports['mythic_notify']:DoCustomHudText ('inform', 'Your current frequency has been encrypted.', 5000)
    Citizen.Wait(2000)
    exports['mythic_notify']:DoCustomHudText ('inform', 'You can try connecting to it again.', 5000)
  end

end)

RegisterNetEvent('a-radio:getDecryptedRadio')
AddEventHandler('a-radio:getDecryptedRadio', function()

  if RadioChannel ~= nil then
    TriggerEvent("v-progressbar:client:progress", {
        name = "unique_action_name",
        duration = 30000,
        label = "Encrypting radio frequency...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "anim@heists@ornate_bank@hack",
            anim = "hack_loop",
        }
    }, function(status)
        if not status then
          local destroy = math.random(1, 100)
          if destroy < 80 then
            TriggerServerEvent('a-radio:sendDecryptedRadio', RadioChannel)
          else
            exports['mythic_notify']:DoCustomHudText ('error', 'Your encryptor has been blocked.', 5000)
            TriggerServerEvent("a-radio:removeEncryptor")
          end
        end
    end)     
  else
    exports['mythic_notify']:DoCustomHudText ('error', 'You are not in any radio frequency.', 5000)
  end

end)

RegisterNetEvent('a-radio:use', function()
    toggleRadio(not radioMenu)
end)

-- NUI
RegisterNUICallback('joinRadio', function(data, cb)
	local frequency = tonumber(data.channel)
	
	if frequency <= Config.MaxFrequency then
		if frequency < 1 and frequency ~= 0 then
			return
		end
		
		if frequency >= 1 and frequency <= 5 then
			if ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'lawyer' and ESX.PlayerData.job.name ~= 'judge' and ESX.PlayerData.job.name ~= 'ambulance' and ESX.PlayerData.job.name ~= 'governor' and ESX.PlayerData.job.name ~= 'mechanic' then
                exports['mythic_notify']:DoCustomHudText ('error', 'This frequency is encrypted.', 5000)
                return
            end
		end
	
		--Broadcasting
		if frequency == 19.19 then
			 exports['mythic_notify']:DoCustomHudText ('error', 'This frequency is restricted.', 5000)
			 return
		end
		
		if frequency == 69.69 then
			 exports['mythic_notify']:DoCustomHudText ('error', 'This frequency is restricted.', 5000)
			 return
		end
		
		if frequency ~= 0 then
			if frequency ~= RadioChannel then
				exports["pma-voice"]:setRadioChannel(frequency)
				RadioChannel = frequency
				exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
				if SplitStr(tostring(frequency), ".")[2] ~= nil and SplitStr(tostring(frequency), ".")[2] ~= "" then
					exports['mythic_notify']:DoCustomHudText ('inform', Config.messages['joined_to_radio'] ..frequency.. ' MHz', 5000)
				else
					exports['mythic_notify']:DoCustomHudText ('inform', Config.messages['joined_to_radio'] ..frequency.. '.00 MHz', 5000) 
				end				
			end
		elseif frequency == 0 and RadioChannel ~= nil then
			RadioChannel = nil
			exports['mythic_notify']:DoCustomHudText ('error', 'You have turned off the radio.', 5000)  
		end
	else
		exports['mythic_notify']:DoHudText('error', 'This frequency is not available.')
	end
    cb("ok")
end)

RegisterNUICallback('leaveRadio', function(_, cb)
    if RadioChannel == nil then
		exports['mythic_notify']:DoCustomHudText ('error', Config.messages['not_on_radio'], 5000) 
    else
        leaveradio()
    end
    cb("ok")
end)

RegisterNUICallback("volumeUp", function(_, cb)
    local RadioVolume = exports["pma-voice"]:getRadioVolume()
	if RadioVolume <= 0.9 then
		RadioVolume = RadioVolume + 0.1
		exports['mythic_notify']:DoCustomHudText ('success', 'New volume ' .. RadioVolume, 5000) 
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
		exports['mythic_notify']:DoCustomHudText ('success', 'The radio is already set to maximum volume', 5000) 
	end
    cb('ok')
end)

RegisterNUICallback("volumeDown", function(_, cb)
    local RadioVolume = exports["pma-voice"]:getRadioVolume()
	if RadioVolume >= 0.2 then
		RadioVolume = RadioVolume - 0.1
		exports['mythic_notify']:DoCustomHudText ('success', Config.messages["volume_radio"] .. RadioVolume, 5000) 
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
		exports['mythic_notify']:DoCustomHudText ('success', Config.messages["increase_radio_volume"], 5000) 
	end
    cb('ok')
end)

RegisterNUICallback("increaseradiochannel", function(_, cb)
    local newChannel = RadioChannel + 1
    exports["pma-voice"]:setRadioChannel(newChannel)
	exports['mythic_notify']:DoCustomHudText ('success', Config.messages["increase_decrease_radio_channel"] .. newChannel, 5000) 
    cb("ok")
end)

RegisterNUICallback("decreaseradiochannel", function(_, cb)
    local newChannel = RadioChannel - 1
    if newChannel >= 1 then
        exports["pma-voice"]:setRadioChannel(newChannel)
		exports['mythic_notify']:DoCustomHudText ('success', Config.messages["increase_decrease_radio_channel"] .. newChannel, 5000) 
        cb("ok")
    end
end)

RegisterNUICallback('poweredOff', function(_, cb)
    leaveradio()
    cb("ok")
end)

RegisterNUICallback('escape', function(_, cb)
    toggleRadio(false)
    cb("ok")
end)

Citizen.CreateThread(function()
    while true do
      local playerPed = GetPlayerPed(-1)
        if IsEntityDead(playerPed) then
            TriggerEvent('a-radio:removeRadio')
        elseif not exports["atrp_inventory"]:hasEnoughOfItem('radio', 1) then
            TriggerEvent('a-radio:removeRadio')
        end
        Citizen.Wait(100)
    end
end)