local utils = {}

function utils.rem(v)
    return 16 * v
end

function utils.findInstanceByType(MainInstance, InstanceType, f)
    for _, currentChild in pairs(MainInstance:GetChildren()) do
        if(currentChild:isA(InstanceType)) then
            return currentChild
        end
    end

end

return utils