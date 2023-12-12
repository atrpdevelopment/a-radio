ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('a-radio:transferFrequency')
AddEventHandler('a-radio:transferFrequency', function(targetId, currentFreq)
	if currentFreq == nil then return end
	
	TriggerClientEvent('a-radio:setFrequency', targetId, currentFreq)
end)

RegisterServerEvent('a-radio:sendDecryptedRadio')
AddEventHandler('a-radio:sendDecryptedRadio', function(currentFreq)	
	if currentFreq == nil then return end
	
	TriggerClientEvent('a-radio:encryptRadio', -1, currentFreq)
end)

RegisterServerEvent('a-radio:removeEncryptor')
AddEventHandler('a-radio:removeEncryptor', function()	
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police'	then
		
	else
		TriggerClientEvent("inventory:removeItem", xPlayer.source, 'encryptor', 1)	
	end
end)

RegisterServerEvent('a-radio:sv_megaphone:server:syncmegaphone')
AddEventHandler('a-radio:sv_megaphone:server:syncmegaphone', function(source, status)
    TriggerClientEvent('a-radio:cl_megaphone:client:syncmegaphone', -1, source, status)
    TriggerClientEvent('a-radio:client:MegaphoneStatus', source, status)
end)