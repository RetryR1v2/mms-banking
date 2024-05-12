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
    local charidentifier = Character.charIdentifier
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
        if #result > 0 then
            amount = result[1].balance
        else
            amount = 0
        end
    Citizen.Wait(500)
    cb (amount)
end)

RegisterServerEvent('mms-banking:server:updatebalance', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
        if #result > 0 then 
            local balance = result[1].balance
            local kontoid = result[1].bankid
            TriggerClientEvent('mms-banking:client:reciveupdatebalance',src,balance,kontoid)
        end
end)


RegisterServerEvent('mms-banking:server:buyvault', function(VaultName,VaultId,VaultStorage,VaultLevel)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_bankingvaults WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
    if #result > 0 then
        VORPcore.NotifyTip(src, _U('YouAlreadyGotVault'), 5000)
    else
        MySQL.insert('INSERT INTO `mms_bankingvaults` (identifier,charidentifier, vaultid,vaultname,storage,level) VALUES (?,?,?,?,?,?)', 
        {identifier,charidentifier,VaultId,VaultName,VaultStorage,VaultLevel}, function()end)
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
    local charidentifier = Character.charIdentifier
    local result = MySQL.query.await("SELECT * FROM mms_bankingvaults WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
    if #result > 0 then
        VaultName = result[1].vaultname
        VaultId = result[1].vaultid
        VaultStorage = result[1].storage
        VaultLevel = result[1].level
        local isregistred = exports.vorp_inventory:isCustomInventoryRegistered(VaultId)
        if isregistred == true then
            exports.vorp_inventory:closeInventory(src, VaultId)
            exports.vorp_inventory:openInventory(src, VaultId)
        else
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
            exports.vorp_inventory:openInventory(src, VaultId)
            isregistred = exports.vorp_inventory:isCustomInventoryRegistered(VaultId)
        end
    else
        VORPcore.NotifyTip(src, _U('YouGotNoVault'), 5000)
end
end)

RegisterServerEvent('mms-banking:server:upgradevault', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_bankingvaults WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
    if #result > 0 then
        VaultLevel = result[1].level
        VaultSotrage = result[1].storage
        if VaultLevel < Config.Maxlevel then
            if VaultLevel == 1 then
                local newlevel = VaultLevel + 1
                MySQL.update('UPDATE `mms_bankingvaults` SET level = ? WHERE charidentifier = ?',{newlevel, charidentifier})
                local newstorage = VaultSotrage + Config.Level2
                MySQL.update('UPDATE `mms_bankingvaults` SET storage = ? WHERE charidentifier = ?',{newstorage, charidentifier})
                Character.removeCurrency(0, Config.UpgradeCosts)
                VORPcore.NotifyTip(src, _U('VaultUpgraded'), 5000)
                if Config.EnableWebHook == true then
                    VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Upgraded Vault to Level ' .. newlevel, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                end
            elseif VaultLevel == 2 then
                local newlevel = VaultLevel + 1
                MySQL.update('UPDATE `mms_bankingvaults` SET level = ? WHERE charidentifier = ?',{newlevel, charidentifier})
                local newstorage = VaultSotrage + Config.Level3
                MySQL.update('UPDATE `mms_bankingvaults` SET storage = ? WHERE charidentifier = ?',{newstorage, charidentifier})
                Character.removeCurrency(0, Config.UpgradeCosts)
                VORPcore.NotifyTip(src, _U('VaultUpgraded'), 5000)
                if Config.EnableWebHook == true then
                    VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Upgraded Vault to Level ' .. newlevel, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                end
            elseif VaultLevel == 3 then
                local newlevel = VaultLevel + 1
                MySQL.update('UPDATE `mms_bankingvaults` SET level = ? WHERE charidentifier = ?',{newlevel, charidentifier})
                local newstorage = VaultSotrage + Config.Level4
                MySQL.update('UPDATE `mms_bankingvaults` SET storage = ? WHERE charidentifier = ?',{newstorage, charidentifier})
                Character.removeCurrency(0, Config.UpgradeCosts)
                VORPcore.NotifyTip(src, _U('VaultUpgraded'), 5000)
                if Config.EnableWebHook == true then
                    VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Upgraded Vault to Level ' .. newlevel, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                end
            elseif VaultLevel == 4 then
                local newlevel = VaultLevel + 1
                MySQL.update('UPDATE `mms_bankingvaults` SET level = ? WHERE charidentifier = ?',{newlevel, charidentifier})
                local newstorage = VaultSotrage + Config.Level5
                MySQL.update('UPDATE `mms_bankingvaults` SET storage = ? WHERE charidentifier = ?',{newstorage, charidentifier})
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
    local charidentifier = Character.charIdentifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local bankid = math.random(1000,99999)
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
        if #result > 0 then 
            local newbalance = result[1].balance + depositamount
            MySQL.update('UPDATE `mms_banking` SET balance = ? WHERE charidentifier = ?',{newbalance, charidentifier})
            Character.removeCurrency(0, depositamount)
            VORPcore.NotifyTip(src, depositamount.._U('Deposited'), 5000)
            TriggerClientEvent('mms-banking:client:updatebalance',src)
            if Config.EnableWebHook == true then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Deposited ' .. depositamount .. ' $', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        else
            MySQL.insert('INSERT INTO `mms_banking` (identifier, charidentifier, bankid, balance) VALUES (?, ?, ?, ?)', {identifier,charidentifier,bankid,depositamount}, function()end)
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
    local charidentifier = Character.charIdentifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
        if #result > 0 then
            local newbalance = result[1].balance - withdrawmount
            MySQL.update('UPDATE `mms_banking` SET balance = ? WHERE charidentifier = ?',{newbalance, charidentifier})
            Character.addCurrency(0, withdrawmount)
            VORPcore.NotifyTip(src, withdrawmount.._U('Withdrawn'), 5000)
            TriggerClientEvent('mms-banking:client:updatebalance',src)
            if Config.EnableWebHook == true then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Withdrawn ' .. withdrawmount .. ' $', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        end
end)


--- Transfer Money

RegisterServerEvent('mms-banking:server:transfermoney',function(tfamount,tfid)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE bankid=@bankid", { ["bankid"] = tfid})
        if #result > 0 then
            local result2 = MySQL.query.await("SELECT * FROM mms_banking WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
            local oldbalance = result[1].balance
            if #result2 > 0 then
                local balance = result2[1].balance
                if balance >= tfamount then
                    local newbalance1 = balance - tfamount
                    local newbalance2 = oldbalance + tfamount
                    MySQL.update('UPDATE `mms_banking` SET balance = ? WHERE charidentifier = ?',{newbalance1, charidentifier})
                    MySQL.update('UPDATE `mms_banking` SET balance = ? WHERE bankid = ?',{newbalance2, tfid})
                        VORPcore.NotifyTip(src, tfamount .. ' $ ' .. _U('TO') .. tfid .. _U('Transfered'), 5000)
                    if Config.EnableWebHook == true then
                        VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' Überweißt ' .. tfamount .. '$ an Kontonummer: ' .. tfid, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                    end
                else
                    VORPcore.NotifyTip(src, _U('NotEnoghMoneyInBank'), 5000)
                end

        end
    else
        VORPcore.NotifyTip(src, _U('IdNotFound'), 5000)
    end
end)

--- CreateBill

RegisterServerEvent('mms-banking:server:createbill',function (ba)
    local src = source
    local MyPedId = GetPlayerPed(src)
    local MyCoords =  GetEntityCoords(MyPedId)
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    for _, player in ipairs(GetPlayers()) do
        local ClosestCharacter = VORPcore.getUser(player).getUsedCharacter
        local PlayerPedId = GetPlayerPed(player)
        local PlayerCoords =  GetEntityCoords(PlayerPedId)
        local Dist = #(MyCoords - PlayerCoords)
        local closestfirstname = ClosestCharacter.firstname
        local closestlastname = ClosestCharacter.lastname
        local closestidentifier = ClosestCharacter.identifier
        local closestcharidentifier = ClosestCharacter.charIdentifier
        if Dist > 0.3 and Dist < 1.5 then
            VORPcore.NotifyTip(src, _U('BillCreated') .. closestfirstname .. ' ' .. closestlastname .. '!',  5000)
            VORPcore.NotifyTip(player, _U('BillRecived') .. firstname .. ' ' .. lastname .. '!',  5000)
            MySQL.insert('INSERT INTO `mms_bankingbills` (fromidentifier, fromcharidentifier, fromfirstname, fromlastname,toidentifier, tocharidentifier, tofirstname, tolastname, amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            {identifier,charidentifier,firstname,lastname,closestidentifier,closestcharidentifier,closestfirstname,closestlastname,ba}, function()end)
            if Config.EnableWebHook == true then
                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, firstname .. ' ' .. lastname .. ' stellt ' .. closestfirstname .. ' ' .. closestlastname .. ' eine Rechnung aus Betrag: ' .. ba .. '$', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            end
        else
            --VORPcore.NotifyTip(src, _U('NoNearbyPlayer'),  5000)
        end
    end
end)


RegisterServerEvent('mms-banking:server:getsendbills', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
            exports.oxmysql:execute('SELECT * FROM mms_bankingbills WHERE fromcharidentifier = ?', {charidentifier}, function(sentbills)
                if sentbills and #sentbills > 0 then
                    local eintraege = {}

                    for _, sbill in ipairs(sentbills) do
                        table.insert(eintraege, sbill)
                        
                    end
                    TriggerClientEvent('mms-banking:client:recivesendbills', src, eintraege)
                else
                    VORPcore.NotifyTip(src, _U('NoBillsCreated'),  5000)
            end
        end)
end)

RegisterServerEvent('mms-banking:server:getrecivedbills', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
            exports.oxmysql:execute('SELECT * FROM mms_bankingbills WHERE tocharidentifier = ?', {charidentifier}, function(gotbills)
                if gotbills and #gotbills > 0 then
                    local eintraege = {}

                    for _, rbill in ipairs(gotbills) do
                        table.insert(eintraege, rbill)
                    end

                    TriggerClientEvent('mms-banking:client:recivegotbills', src, eintraege)
                else
                    VORPcore.NotifyTip(src, _U('NoBillsRecived'),  5000)
            end
        end)
end)
RegisterServerEvent('mms-banking:server:paybill',function(payamount,tocharid,billid)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local result = MySQL.query.await("SELECT * FROM mms_banking WHERE charidentifier=@charidentifier", { ["charidentifier"] = tocharid})
    if #result > 0 then
        local oldbalance = result[1].balance
        local result2 = MySQL.query.await("SELECT * FROM mms_banking WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
        if #result2 > 0 then
            local balance = result2[1].balance
            if balance >= payamount then
                local newbalance1 = balance - payamount
                local newbalance2 = oldbalance + payamount
                MySQL.update('UPDATE `mms_banking` SET balance = ? WHERE charidentifier = ?',{newbalance1, charidentifier})
                MySQL.update('UPDATE `mms_banking` SET balance = ? WHERE charidentifier = ?',{newbalance2, tocharid})
                    VORPcore.NotifyTip(src, _U('YouPayedBillFrom'), 5000)
                MySQL.execute('DELETE FROM mms_bankingbills WHERE id = ?', { billid }, function()end)
                if Config.EnableWebHook == true then
                    VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, charidentifier .. _U('PayedBillFrom') .. tocharid .. _U('BillAmount') .. ' ' .. payamount .. ' $', Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                end
            else
                VORPcore.NotifyTip(src, _U('NotEnoghMoneyInBank'), 5000)
            end

    end
else
    VORPcore.NotifyTip(src, _U('BillNotFound'), 5000)
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