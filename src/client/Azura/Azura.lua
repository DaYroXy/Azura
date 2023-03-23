local Azura = {}
Azura.__index = Azura

local Element = require(script.parent.Element)
local elementsList = {
    "TextButton",
    "Frame",
    "ImageLabel",
    "TextLabel",
    "ScreenGui",
}

function Azura:init()
    local self = setmetatable({}, Azura)
    return self
end

function Azura:createWindow(data, screenChilderns) 
    local window = {}
    
    local Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local Name = "Azura Window"
    
    if (data) then
        Parent = data["parent"] or Parent
        Name = data["name"] or Name
    end

    window.Instance = Instance.new("ScreenGui", Parent)
    window.Instance.Name = Name

    -- Auto Load Elements
    for index, type in pairs(elementsList) do
        window["create" .. type] = function(self , appliedProperties, childerns, ...)
            local newElement = Element.init(type, window.Instance, window.Instance, appliedProperties, ...)
            newElement:create(appliedProperties)
            if(childerns) then
                for ChildId, CurrentChild in pairs(childerns) do
                    CurrentChild:setParent(newElement)
                end
            end
            return newElement
        end
    end


    return window
end

return Azura
