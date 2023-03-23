local Styles = require(script.Parent.Styles)

local Element = {}
Element.__index = Element

function Element.init(type, WindowInstance, parent, appliedProperties)
    local self = setmetatable({}, Element)
    self.Type = type
    self.WindowInstance = WindowInstance
    self.Parent = parent
    self.appliedProperties = appliedProperties
    return self
end

function Element:create()
    self.Instance = Instance.new(self.Type, self.Parent)
    self:setStyles(self.appliedProperties) 
    self:setProperties(self.appliedProperties)
    self:FilterUnwanted({
        ["AutoButtonColor"] = false,
        ["BorderSizePixel"] = 0
    })
    return self
end

function Element:setProperties(properties)
    if(not properties) then return end

    for pName, pValue in pairs(properties) do
        if(pName == "class") then continue end
        
        local isOn = pName:sub(1, 2) == "on"
        
        if(isOn) then
            pName = pName:gsub("on", "")
        end
        
        pName = string.upper(string.sub(pName, 1, 1)) .. string.sub(pName, 2)
        
        if(isOn) then
            setMethod = self["on"..pName]
        else
            setMethod = self["set"..pName]
        end

        if(not setMethod) then 
            warn("Property '"..pName.."' not found instance ".. self.Instance.ClassName ..", please check spelling.")
            continue
        end
        setMethod(self, pValue)
    end

end

function Element:setStyles(stylesList) 
    Styles:setStyles(stylesList, self.Instance)
end

function Element:setDropDownMenu(DropDownProperties)
    if not DropDownProperties or not DropDownProperties[1] or not DropDownProperties[1].Instance then
        return
    end

    local DropMenu = DropDownProperties[1].Instance
    DropMenu.Parent = self.WindowInstance

    local function updateDropMenuPosition()
        print("changed")
        local currentInstance = self.Instance
        local desiredPosition = UDim2.new(0, currentInstance.AbsolutePosition.X, 0, currentInstance.AbsolutePosition.Y + currentInstance.AbsoluteSize.Y + DropDownProperties.offset)
        DropMenu.Position = desiredPosition
    end

    self.Instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateDropMenuPosition)
    updateDropMenuPosition()
end

function Element:setName(name)
    self.Instance.Name = name
    return name
end

function Element:setText(txt)
    self.Instance.Text = txt
    return txt
end

function Element:onClick(passedFunction)
    self.Instance.MouseButton1Down:connect(function(...)
        passedFunction(..., self.appliedProperties)
    end)
end

function Element:setParent(newParent)
    self.Parent = newParent.Instance
    self.Instance.Parent = self.Parent
    return self.Parent
end

function Element:FilterUnwanted(list)
    for methodName, methodValue in (list) do
        pcall(function()
            self.Instance[methodName] = methodValue
        end)
    end
end

function Element:getName()
    return self.Instance.Name
end


return Element