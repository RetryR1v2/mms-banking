local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local FeatherMenu =  exports['feather-menu'].initiate()

local getsendbills = 0
local getrecivedbills = 0

local CreatedBlips2 = {}
local CreatedNpcs2 = {}

RegisterCommand(Config.BillsCommand, function()
	Bills:Open({
        startupPage = BillsPage1,
    })
end)

Citizen.CreateThread(function ()
    Bills = FeatherMenu:RegisterMenu('billsmenu', {
        top = '50%',
        left = '50%',
        ['720width'] = '500px',
        ['1080width'] = '700px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
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
    --canclose = false
}, {
    opened = function()
        --print("MENU OPENED!")
    end,
    closed = function()
        --print("MENU CLOSED!")
    end,
    topage = function(data)
        --print("PAGE CHANGED ", data.pageid)
    end
})
    BillsPage1 = Bills:RegisterPage('seite1')
    BillsPage1:RegisterElement('header', {
        value = _U('BillsBoardHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    BillsPage1:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    local billamount = ''
    BillsPage1:RegisterElement('input', {
    label = _U('BillAmount'),
    placeholder = "",
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    },
}, function(data)
    billamount = data.value
end)
local billreason = ''
    BillsPage1:RegisterElement('input', {
    label = _U('BillReason'),
    placeholder = "",
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    },
}, function(data)
    billreason = data.value
end)
    BillsPage1:RegisterElement('button', {
        label = _U('CreateBill'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        local br = billreason
        local ba = tonumber(billamount)
        Bills:Close({ 
        })
        TriggerEvent('mms-banking:client:createbill',ba,br)
    end)
    BillsPage1:RegisterElement('button', {
        label = _U('MyCreatedBills'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-banking:client:getsendbills')
    end)
    BillsPage1:RegisterElement('button', {
        label = _U('MyRecievedBills'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-banking:client:getrecivedbills')
    end)
    BillsPage1:RegisterElement('button', {
        label =  _U('CloseBoardBills'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Bills:Close({ 
        })
    end)
    BillsPage1:RegisterElement('subheader', {
        value = _U('BoardHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    BillsPage1:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
end)

Citizen.CreateThread(function()
local BankingPrompt = BccUtils.Prompts:SetupPromptGroup()
    local traderprompt = BankingPrompt:RegisterPrompt(_U('PromptName'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'})
    if Config.BankingBlips then
        for h,v in pairs(Config.BankPositions) do
        local bankingblip = BccUtils.Blips:SetBlip(_U('BankBlipName'), Config.BlipSprite, 0.2, v.coords.x,v.coords.y,v.coords.z)
        CreatedBlips2[#CreatedBlips2 + 1] = bankingblip
        end
    end
    if Config.CreateNPC then
        for h,v in pairs(Config.BankPositions) do
        local bankingped = BccUtils.Ped:Create('u_f_m_tumgeneralstoreowner_01', v.coords.x, v.coords.y, v.coords.z -1, 0, 'world', false)
        CreatedNpcs2[#CreatedNpcs2 + 1] = bankingped
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
        ['4kwidth'] = '800px',
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
    --canclose = false
}, {
    opened = function()
        --print("MENU OPENED!")
    end,
    closed = function()
        --print("MENU CLOSED!")
    end,
    topage = function(data)
        --print("PAGE CHANGED ", data.pageid)
    end
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
    Kontonummer = BankingPage1:RegisterElement('textdisplay', {
        value = _U('BankId'),
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
        label = _U('Transfer'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        BankingPage2:RouteTo()
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



    --- Seite 2 

    BankingPage2 = Banking:RegisterPage('seite2')
    BankingPage2:RegisterElement('header', {
        value = _U('BoardHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    BankingPage2:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
local transferid = ''
    BankingPage2:RegisterElement('input', {
    label = _U('EnterId'),
    placeholder = "",
    persist = false,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function(data)
    transferid = data.value
end)
BankingPage2:RegisterElement('button', {
    label =  _U('TransferMoney'),
    style = {
    ['background-color'] = '#FF8C00',
    ['color'] = 'orange',
    ['border-radius'] = '6px'
    },
}, function()
    Banking:Close({ 
    })
    local tfid = tonumber(transferid)
    TriggerEvent('mms-banking:client:transfer',tfid)
end)
BankingPage2:RegisterElement('button', {
    label =  _U('BackMenu'),
    style = {
    ['background-color'] = '#FF8C00',
    ['color'] = 'orange',
    ['border-radius'] = '6px'
    },
}, function()
    BankingPage1:RouteTo()
end)
    BankingPage2:RegisterElement('button', {
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
    BankingPage2:RegisterElement('subheader', {
        value = _U('BoardHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    BankingPage2:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
end)

--- Create Bills


RegisterNetEvent('mms-banking:client:createbill')
AddEventHandler('mms-banking:client:createbill',function(ba,br)
    TriggerServerEvent('mms-banking:server:createbill',ba,br)
end)

--- GET SEND BILLS

RegisterNetEvent('mms-banking:client:getsendbills',function()
    TriggerServerEvent('mms-banking:server:getsendbills')
end)

RegisterNetEvent('mms-banking:client:recivesendbills',function(eintraege)
    if getsendbills == 0 then
        BillsPage2 = Bills:RegisterPage('seite2')
        BillsPage2:RegisterElement('header', {
            value = _U('BillsBoardHeader'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage2:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for _, sbill in ipairs(eintraege) do
            local buttonLabel = 'Rechnung an:  '.. sbill.tofirstname ..' '.. sbill.tolastname .. _U('BillSendAmount') .. sbill.amount .. '$ ' .. _U('Reason') .. sbill.reason
            BillsPage2:RegisterElement('button', {
                label = buttonLabel,
                style = {
                    ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
                }
            }, function()
                
            end)
        end
        BillsPage2:RegisterElement('button', {
            label = _U('BackMenu'),
            style = {
                ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            BillsPage1:RouteTo()
        end)
        BillsPage2:RegisterElement('button', {
            label =  _U('CloseBoardBills'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Bills:Close({ 
            })
        end)
        BillsPage2:RegisterElement('subheader', {
            value = _U('BoardHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage2:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage2:RouteTo()
        getsendbills = 1
    elseif getsendbills == 1 then
        BillsPage2:UnRegister()
        BillsPage2 = Bills:RegisterPage('seite2')
        BillsPage2:RegisterElement('header', {
            value = _U('BillsBoardHeader'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage2:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for _, sbill in ipairs(eintraege) do
            local buttonLabel = 'Rechnung an:  '.. sbill.tofirstname ..' '.. sbill.tolastname .. _U('BillSendAmount') .. sbill.amount .. '$'.. _U('Reason') .. sbill.reason
            BillsPage2:RegisterElement('button', {
                label = buttonLabel,
                style = {
                    ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
                }
            }, function()
                
            end)
        end
        BillsPage2:RegisterElement('button', {
            label = _U('BackMenu'),
            style = {
                ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            BillsPage1:RouteTo()
        end)
        BillsPage2:RegisterElement('button', {
            label =  _U('CloseBoardBills'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Bills:Close({ 
            })
        end)
        BillsPage2:RegisterElement('subheader', {
            value = _U('BoardHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage2:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage2:RouteTo()
    end

end)

--- GET Recived BILLS

RegisterNetEvent('mms-banking:client:getrecivedbills',function()
    TriggerServerEvent('mms-banking:server:getrecivedbills')
end)

RegisterNetEvent('mms-banking:client:recivegotbills',function(eintraege)
    if getrecivedbills == 0 then
        BillsPage3 = Bills:RegisterPage('seite2')
        BillsPage3:RegisterElement('header', {
            value = _U('BillsBoardHeader'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage3:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for _, rbill in ipairs(eintraege) do
            local buttonLabel = 'Rechnung von:  '.. rbill.fromfirstname ..' '.. rbill.fromlastname .. _U('BillSendAmount') .. rbill.amount .. '$'.. _U('Reason') .. rbill.reason
            local payamount = rbill.amount
            local tocharid = rbill.fromcharidentifier
            local billid = rbill.id
            BillsPage3:RegisterElement('button', {
                label = buttonLabel,
                style = {
                    ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
                }
            }, function()
                Bills:Close()
                TriggerEvent('mms-banking:client:paybill',payamount,tocharid,billid)
            end)
        end
        BillsPage3:RegisterElement('button', {
            label = _U('BackMenu'),
            style = {
                ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            BillsPage1:RouteTo()
        end)
        BillsPage3:RegisterElement('button', {
            label =  _U('CloseBoardBills'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Bills:Close({ 
            })
        end)
        BillsPage3:RegisterElement('subheader', {
            value = _U('BoardHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage3:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage3:RouteTo()
        getrecivedbills = 1
    elseif getrecivedbills == 1 then
        BillsPage3:UnRegister()
        BillsPage3 = Bills:RegisterPage('seite2')
        BillsPage3:RegisterElement('header', {
            value = _U('BillsBoardHeader'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage3:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for _, rbill in ipairs(eintraege) do
            local buttonLabel = 'Rechnung von:  '.. rbill.fromfirstname ..' '.. rbill.fromlastname .. _U('BillSendAmount') .. rbill.amount .. '$'.. _U('Reason') .. rbill.reason
            local payamount = rbill.amount
            local tocharid = rbill.fromcharidentifier
            local billid = rbill.id
            BillsPage3:RegisterElement('button', {
                label = buttonLabel,
                style = {
                    ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
                }
            }, function()
                Bills:Close()
                TriggerEvent('mms-banking:client:paybill',payamount,tocharid,billid)
            end)
        end
        BillsPage3:RegisterElement('button', {
            label = _U('BackMenu'),
            style = {
                ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            BillsPage1:RouteTo()
        end)
        BillsPage3:RegisterElement('button', {
            label =  _U('CloseBoardBills'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            Bills:Close({ 
            })
        end)
        BillsPage3:RegisterElement('subheader', {
            value = _U('BoardHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage3:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BillsPage3:RouteTo()
    end

end)

--- PayBill

RegisterNetEvent('mms-banking:client:paybill',function(payamount,tocharid,billid)
    TriggerServerEvent('mms-banking:server:paybill',payamount,tocharid,billid)
end)

--- Transfer Money

RegisterNetEvent('mms-banking:client:transfer')
AddEventHandler('mms-banking:client:transfer',function(tfid)
    local TransferInput = {
        type = "enableinput",
        inputType = "input",
        button = _U('Confirm'),
        placeholder = "$",
        style = "block",
        attributes = {
            inputHeader = _U('EnterValue'),
            type = "text",
            pattern = "[0-9]+",
            title = _U('NumbersOnly'),
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }
    TriggerEvent("vorpinputs:advancedInput", json.encode(TransferInput), function(result)
        
        if result ~= "" and result then 
            local tfamount = tonumber(result)
            TriggerServerEvent('mms-banking:server:transfermoney',tfamount,tfid)
        else
            print(_U('NoEntry')) 
        end
    end)
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
            type = "text",
            pattern = "[0-9]+",
            title = _U('NumbersOnly'),
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }
    TriggerEvent("vorpinputs:advancedInput", json.encode(DepositInput), function(result)
        
        if result ~= "" and result then 
            local depositamount = tonumber(result)
            local Money =  VORPcore.Callback.TriggerAwait('mms-banking:callback:getplayermoney')
            if Money >= depositamount then
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
            type = "text",
            pattern = "[0-9]+",
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
    local VaultId = math.random(100000,999999)
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
    local Money =  VORPcore.Callback.TriggerAwait('mms-banking:callback:getplayermoney')
    if Money >= Config.UpgradeCosts then
        TriggerServerEvent('mms-banking:server:upgradevault')
    else
        VORPcore.NotifyTip(_U('NotEnoghMoney'),  5000)
    end
end)
--- updatebalance

RegisterNetEvent('mms-banking:client:updatebalance')
AddEventHandler('mms-banking:client:updatebalance',function()
    TriggerServerEvent('mms-banking:server:updatebalance')
end)

RegisterNetEvent('mms-banking:client:reciveupdatebalance')
AddEventHandler('mms-banking:client:reciveupdatebalance',function(balance,kontoid)
    Kontostand:update({
        value = _U('BankValue') .. balance .. ' $',
        style = {}
    })
    Kontonummer:update({
        value = _U('BankId') .. kontoid,
        style = {}
    })
end)


--- Get Feather Menu Events OPEN/CLOSE Menu

RegisterNetEvent('FeatherMenu:opened', function(menudata)
    if menudata.menuid == 'bankingmenu' then
        TriggerServerEvent('mms-banking:server:updatebalance')
    end
end)

RegisterNetEvent('FeatherMenu:closed', function(menudata)
    if menudata.menuid == 'bankingmenu' then
    end
end)

---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
    for _, npcs in ipairs(CreatedNpcs2) do
        npcs:Remove()
	end
    for _, blips in ipairs(CreatedBlips2) do
        blips:Remove()
	end
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