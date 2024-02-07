local VORPcore = exports.vorp_core:GetCore()
local amount = -1

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-banking/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end


VORPcore.Callback.Register('mms-banking:callback:updatebalance', function(source,cb)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE identifier=@identifier", { ["identifier"] = identifier})
        if #result > 0 then 
            amount = result[1].balance
        else
            amount = 0
        end
    Citizen.Wait(500)
    cb (amount)
end)

RegisterServerEvent('mms-banking:server:buyvault', function(VaultName,VaultId,VaultStorage,VaultLevel)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_bankingvaults WHERE identifier=@identifier", { ["identifier"] = identifier})
    if #result > 0 then
        VORPcore.NotifyTip(src, _U('YouAlreadyGotVault'), 5000)
    else
        MySQL.insert('INSERT INTO `mms_bankingvaults` (identifier, vaultid,vaultname,storage,level) VALUES (?,?,?,?,?)', 
        {identifier,VaultId,VaultName,VaultStorage,VaultLevel}, function()end)
        Character.removeCurrency(0, Config.VaultPrice)
        VORPcore.NotifyTip(src, _U('YouBoughtVault'), 5000)
        if Config.EnableWebHook == true then
            VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Bought a Vault', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
        end
        
    end
end)


RegisterServerEvent('mms-banking:server:openvault', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local result = MySQL.query.await("SELECT * FROM mms_bankingvaults WHERE identifier=@identifier", { ["identifier"] = identifier})
    if #result > 0 then
        VaultName = result[1].vaultname
        VaultId = result[1].vaultid
        VaultStorage = result[1].storage
        VaultLevel = result[1].level
    local isregistred = exports.vorp_inventory:isCustomInventoryRegistered(VaultId)
    if isregistred == true then
    exports.vorp_inventory:closeInventory(src, VaultId)
    exports.vorp_inventory:removeInventory(VaultId)
    end
    exports.vorp_inventory:registerInventory(
        {
            id = VaultId,
            name = VaultName,
            limit = VaultStorage,
            acceptWeapons = true,
            shared = false,
            ignoreItemStackLimit = true,

        }
    )
    local isregistred = exports.vorp_inventory:isCustomInventoryRegistered(VaultId)
        if isregistred == true then
         exports.vorp_inventory:openInventory(src, VaultId)
        end
    else
        VORPcore.NotifyTip(src, _U('YouGotNoVault'), 5000)
end
end)

RegisterServerEvent('mms-banking:server:upgradevault', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_bankingvaults WHERE identifier=@identifier", { ["identifier"] = identifier})
    if #result > 0 then
        VaultLevel = result[1].level
        VaultSotrage = result[1].storage
        if VaultLevel < Config.Maxlevel then
            if VaultLevel == 1 then
                local newlevel = VaultLevel + 1
                MySQL.update('UPDATE `mms_bankingvaults` SET level = ? WHERE identifier = ?',{newlevel, identifier})
                local newstorage = VaultSotrage + Config.Level2
                MySQL.update('UPDATE `mms_bankingvaults` SET storage = ? WHERE identifier = ?',{newstorage, identifier})
                Character.removeCurrency(0, Config.UpgradeCosts)
                VORPcore.NotifyTip(src, _U('VaultUpgraded'), 5000)
                if Config.EnableWebHook == true then
                    VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Upgraded Vault to Level ' .. newlevel, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                end
            elseif VaultLevel == 2 then
                local newlevel = VaultLevel + 1
                MySQL.update('UPDATE `mms_bankingvaults` SET level = ? WHERE identifier = ?',{newlevel, identifier})
                local newstorage = VaultSotrage + Config.Level3
                MySQL.update('UPDATE `mms_bankingvaults` SET storage = ? WHERE identifier = ?',{newstorage, identifier})
                Character.removeCurrency(0, Config.UpgradeCosts)
                VORPcore.NotifyTip(src, _U('VaultUpgraded'), 5000)
                if Config.EnableWebHook == true then
                    VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Upgraded Vault to Level ' .. newlevel, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                end
            elseif VaultLevel == 3 then
                local newlevel = VaultLevel + 1
                MySQL.update('UPDATE `mms_bankingvaults` SET level = ? WHERE identifier = ?',{newlevel, identifier})
                local newstorage = VaultSotrage + Config.Level4
                MySQL.update('UPDATE `mms_bankingvaults` SET storage = ? WHERE identifier = ?',{newstorage, identifier})
                Character.removeCurrency(0, Config.UpgradeCosts)
                VORPcore.NotifyTip(src, _U('VaultUpgraded'), 5000)
                if Config.EnableWebHook == true then
                    VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Upgraded Vault to Level ' .. newlevel, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                end
            elseif VaultLevel == 4 then
                local newlevel = VaultLevel + 1
                MySQL.update('UPDATE `mms_bankingvaults` SET level = ? WHERE identifier = ?',{newlevel, identifier})
                local newstorage = VaultSotrage + Config.Level5
                MySQL.update('UPDATE `mms_bankingvaults` SET storage = ? WHERE identifier = ?',{newstorage, identifier})
                Character.removeCurrency(0, Config.UpgradeCosts)
                VORPcore.NotifyTip(src, _U('VaultUpgraded'), 5000)
                if Config.EnableWebHook == true then
                    VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Upgraded Vault to Level ' .. newlevel, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                end
            end
        else
            VORPcore.NotifyTip(src, _U('MaxVaultLevel'), 5000)
        end
    else
        VORPcore.NotifyTip(src, _U('YouGotNoVault'), 5000)
end
end)

RegisterServerEvent('mms-banking:server:depositmoney',function(depositamount)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE identifier=@identifier", { ["identifier"] = identifier})
        if #result > 0 then 
            local newbalance = result[1].balance + depositamount
            MySQL.update('UPDATE `mms_banking` SET balance = ? WHERE identifier = ?',{newbalance, identifier})
            Character.removeCurrency(0, depositamount)
            VORPcore.NotifyTip(src, depositamount.._U('Deposited'), 5000)
            TriggerClientEvent('mms-banking:client:updatebalance',src)
            if Config.EnableWebHook == true then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Deposited ' .. depositamount .. ' $', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        else
            MySQL.insert('INSERT INTO `mms_banking` (identifier, balance) VALUES (?, ?)', {identifier,depositamount}, function()end)
            Character.removeCurrency(0, depositamount)
            VORPcore.NotifyTip(src, depositamount.._U('Deposited'), 5000)
            TriggerClientEvent('mms-banking:client:updatebalance',src)
            if Config.EnableWebHook == true then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Deposited ' .. depositamount .. ' $', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        end
end)

RegisterServerEvent('mms-banking:server:withdrawmoney',function(withdrawmount)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE identifier=@identifier", { ["identifier"] = identifier})
        if #result > 0 then
            local newbalance = result[1].balance - withdrawmount
            MySQL.update('UPDATE `mms_banking` SET balance = ? WHERE identifier = ?',{newbalance, identifier})
            Character.addCurrency(0, withdrawmount)
            VORPcore.NotifyTip(src, withdrawmount.._U('Withdrawn'), 5000)
            TriggerClientEvent('mms-banking:client:updatebalance',src)
            if Config.EnableWebHook == true then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Withdrawn ' .. withdrawmount .. ' $', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        end
end)

--- RegisterCallback Get Money

VORPcore.Callback.Register('mms-banking:callback:getplayermoney', function(source,cb)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Money = Character.money
    cb(Money)
end)
--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()