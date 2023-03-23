local classesList = require(script.Parent.ClassesList)
local utils = require(script.Parent.Parent.utils)

local Styles = {}
Styles.__index = Styles

function Styles.init()
    local self = setmetatable({}, Styles)
    return self
end

function Styles:setStyles(appliedStyles, passedInstance)
    -- Check if the required parameters are provided
    if (not appliedStyles or not passedInstance) then
        return false
    end


    -- Iterate through each class in appliedStyles
    for _, class in pairs(appliedStyles["class"]:split(" ")) do
        local isClass = classesList[class]
        local className, classValue = class:match("(%a+-)%[(.-)%]")
        local customClassValue
        


        -- If className is found, process the custom value for this class
        if (className) then
            if (classValue:match("px")) then
                customClassValue = UDim.new(0, classValue:gsub("px", ""))
            elseif (classValue:match("rem")) then
                customClassValue = UDim.new(0, utils.rem(classValue:gsub("rem", "")))
            elseif (classValue:match("%%")) then
                customClassValue = UDim.new(classValue:gsub("%%", "") / 100, 0)
            end
            isClass = classesList[className .. "custom"]
        end

        -- If the class has a "NewInstanceCreated" function, call it and set its Parent
        if (isClass ~= nil and isClass["NewInstanceCreated"]) then
            local newInstanceFunc = isClass["NewInstanceCreated"]
            if newInstanceFunc then
                local newInstance = newInstanceFunc()
                if newInstance then
                    local instanceAlreadyFound = utils.findInstanceByType(passedInstance, newInstance)
                    -- if instanceAlreadyFound then
                    --     instanceAlreadyFound:Destroy()
                    -- end
                    newInstance.Parent = passedInstance
                end
            end
            continue
        end

        -- If the class exists, apply its properties to the passedInstance
        if (isClass) then
            local requiredInstance;
            if (isClass ~= nil and isClass["RequiredInstance"]) then
                requiredInstance = utils.findInstanceByType(passedInstance, isClass["RequiredInstance"])
                if(not requiredInstance) then
                    warn(tostring(passedInstance)..' "'..passedInstance.Name..'" '.." does not contain "..requiredInstance)
                    continue
                end

            end
            for key, value in pairs(isClass) do
                pcall(function()
                    if (key:match("[.]")) then
                        if (customClassValue) then
                            value = customClassValue
                            customClassValue = nil
                        end
                        local method = key:split(".")[1]
                        if (key:match("X")) then
                            passedInstance[method] = UDim2.new(value, passedInstance[method].Y)
                        elseif (key:match("Y")) then
                            passedInstance[method] = UDim2.new(passedInstance[method].X, value)
                        end
                        return
                    end
                    
                    if(requiredInstance ~= nil) then
                        requiredInstance[key] = value
                        requiredInstance = nil
                    else 
                        passedInstance[key] = value
                    end
                end)

            end
        end
    end
end


return Styles