local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local FeatherMenu =  exports['feather-menu'].initiate()


local CreatedBlips = {}
local CreatedNpcs = {}


Citizen.CreateThread(function()
local BankingPrompt = BccUtils.Prompts:SetupPromptGroup()
    local traderprompt = BankingPrompt:RegisterPrompt(_U('PromptName'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'})
    if Config.BankingBlips then
        for h,v in pairs(Config.BankPositions) do
        local bankingblip = BccUtils.Blips:SetBlip(_U('BoardblipName'), Config.BlipSprite, 0.2, v.coords.x,v.coords.y,v.coords.z)
        CreatedBlips[#CreatedBlips + 1] = bankingblip
        end
    end
    if Config.CreateNPC then
        for h,v in pairs(Config.BankPositions) do
        local bankingped = BccUtils.Ped:Create('u_f_m_tumgeneralstoreowner_01', v.coords.x, v.coords.y, v.coords.z -1, 0, 'world', false)
        CreatedNpcs[#CreatedNpcs + 1] = bankingped
        bankingped:Freeze()
        bankingped:SetHeading(v.NpcHeading)
        bankingped:Invincible()
        end
    end
    while true do
        Wait(1)
        for h,v in pairs(Config.BankPositions) do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local dist = #(playerCoords - v.coords)
        if dist < 4 then
            BankingPrompt:ShowGroup(_U('PromptName'))

            if traderprompt:HasCompleted() then
                TriggerEvent('mms-banking:client:openbank') break
            end
        end
    end
    end
end)

RegisterNetEvent('mms-banking:client:openbank')
AddEventHandler('mms-banking:client:openbank',function()
    Banking:Open({
        startupPage = BankingPage1,
    })
end)


---------------------------------------------------------------------------------------------------------
--------------------------------------- SEITE  1 Hauptmenü------------------------------------------------
---------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function ()
    Banking = FeatherMenu:RegisterMenu('bankingmenu', {
        top = '50%',
        left = '50%',
        ['720width'] = '500px',
        ['1080width'] = '700px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '8000px',
        style = {
            ['border'] = '5px solid orange',
            -- ['background-image'] = 'none',
            ['background-color'] = '#FF8C00'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '250px'
            }
        },
        draggable = true,
    })
    BankingPage1 = Banking:RegisterPage('seite1')
    BankingPage1:RegisterElement('header', {
        value = _U('BoardHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    BankingPage1:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    Kontostand = BankingPage1:RegisterElement('textdisplay', {
        value = _U('BankValue'),
        style = {}
    })
    BankingPage1:RegisterElement('button', {
        label = _U('Deposit'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-banking:client:deposit')
    end)
    BankingPage1:RegisterElement('button', {
        label = _U('Withdraw'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-banking:client:withdraw')
    end)
    BankingPage1:RegisterElement('button', {
        label = _U('OpenVault'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-banking:client:openvault')
    end)
    BankingPage1:RegisterElement('button', {
        label = _U('BuyVault') .. Config.VaultPrice .. ' $',
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-banking:client:buyvault')
    end)
    BankingPage1:RegisterElement('button', {
        label = _U('UpgradeVault') .. Config.UpgradeCosts .. ' $',
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-banking:client:upgradevault')
    end)
    BankingPage1:RegisterElement('button', {
        label =  _U('CloseBoard'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Banking:Close({ 
        })
    end)
    BankingPage1:RegisterElement('subheader', {
        value = _U('BoardHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    BankingPage1:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
end)

--- Deposit Money

RegisterNetEvent('mms-banking:client:deposit')
AddEventHandler('mms-banking:client:deposit',function()
    local DepositInput = {
        type = "enableinput",
        inputType = "input",
        button = _U('Confirm'),
        placeholder = "$",
        style = "block",
        attributes = {
            inputHeader = _U('EnterValue'),
            type = "number",
            pattern = "[1-999999999]",
            title = _U('NumbersOnly'),
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }
    TriggerEvent("vorpinputs:advancedInput", json.encode(DepositInput), function(result)
        
        if result ~= "" and result then 
            local depositamount = tonumber(result)
            if LocalPlayer.state.Character.Money >= depositamount then
                TriggerServerEvent('mms-banking:server:depositmoney',depositamount)
            else
                VORPcore.NotifyTip(_U('NotEnoghMoney'),  5000)
            end

        else
            print(_U('NoEntry')) --notify
        end
    end)
end)

--- Withdraw Money

RegisterNetEvent('mms-banking:client:withdraw')
AddEventHandler('mms-banking:client:withdraw',function()
    local WithdrawInput = {
        type = "enableinput",
        inputType = "input",
        button = _U('Confirm'),
        placeholder = "$",
        style = "block",
        attributes = {
            inputHeader = _U('EnterValue'),
            type = "number",
            pattern = "[1-999999999]",
            title = _U('NumbersOnly'),
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }
    TriggerEvent("vorpinputs:advancedInput", json.encode(WithdrawInput), function(result)
        
        if result ~= "" and result then 
            local withdrawmount = tonumber(result)
            local balanceresult = VORPcore.Callback.TriggerAwait('mms-banking:callback:updatebalance')
            if balanceresult >= withdrawmount then
                TriggerServerEvent('mms-banking:server:withdrawmoney',withdrawmount)
            else
                VORPcore.NotifyTip(_U('NotEnoghBalance'),  5000)
            end

        else
            print(_U('NoEntry')) --notify
        end
    end)
end)

--- Open Vault

RegisterNetEvent('mms-banking:client:openvault')
AddEventHandler('mms-banking:client:openvault',function()
    TriggerServerEvent('mms-banking:server:openvault')
end)

RegisterNetEvent('mms-banking:client:buyvault')
AddEventHandler('mms-banking:client:buyvault',function()
    local VaultId = math.random(1000,9999)
    local VaultStorage = Config.Level1
    local VaultLevel = 1
    local VaultNameInput = {
        type = "enableinput",
        inputType = "input",
        button = _U('Confirm'),
        placeholder = "",
        style = "block",
        attributes = {
            inputHeader = _U('EnterName'),
            type = "text",
            pattern = "[A-Za-z]+",
            title = _U('TextOnly'),
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }
    TriggerEvent("vorpinputs:advancedInput", json.encode(VaultNameInput), function(result)
        
        if result ~= "" and result then
            local VaultName = result

            TriggerServerEvent('mms-banking:server:buyvault',VaultName,VaultId,VaultStorage,VaultLevel)
        else
            print(_U('NoEntry')) 
        end
    end)

end)


RegisterNetEvent('mms-banking:client:upgradevault')
AddEventHandler('mms-banking:client:upgradevault',function()
    if LocalPlayer.state.Character.Money >= Config.UpgradeCosts then
        TriggerServerEvent('mms-banking:server:upgradevault')
    else
        VORPcore.NotifyTip(_U('NotEnoghMoney'),  5000)
    end
end)
--- updatebalance

RegisterNetEvent('mms-banking:client:updatebalance')
AddEventHandler('mms-banking:client:updatebalance',function()
    local result = VORPcore.Callback.TriggerAwait('mms-banking:callback:updatebalance')
    Kontostand:update({
        value = _U('BankValue') .. result .. ' $',
        style = {}
    })
end)

--- Get Feather Menu Events OPEN/CLOSE Menu

RegisterNetEvent('FeatherMenu:opened', function(menudata)
    if menudata.menuid == 'bankingmenu' then
        TriggerEvent('mms-banking:client:updatebalance')
    end
end)

RegisterNetEvent('FeatherMenu:closed', function(menudata)
    if menudata.menuid == 'bankingmenu' then
    end
end)

---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function()
    for _, npcs in ipairs(CreatedNpcs) do
        npcs:Remove()
	end
    for _, blips in ipairs(CreatedBlips) do
        blips:Remove()
	end
end)

-- open doors
CreateThread(function()
    for door, state in pairs(Config.Doors) do
        if not IsDoorRegisteredWithSystem(door) then
            Citizen.InvokeNative(0xD99229FE93B46286, door, 1, 1, 0, 0, 0, 0)
        end
        DoorSystemSetDoorState(door, state)
    end
end)