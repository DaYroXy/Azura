import pyperclip

padding_template = '''
["pl-{index}"] = {{
    ["NewInstanceCreated"] = (function()
        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingTop  = UDim.new(0, 0)
        UIPadding.PaddingBottom  = UDim.new(0, 0)
        UIPadding.PaddingRight  = UDim.new(0, 0)
        UIPadding.PaddingLeft  = UDim.new(0, rem({rem_value}))
        return UIPadding
    end)
}},
'''

padding_definitions = []

for i in range(1, 21):
    rem_value = 0.25 * i
    # Format the rem_value with the desired number format
    formatted_rem_value = '{:.2f}'.format(rem_value).rstrip('0').rstrip('.')
    padding_definitions.append(padding_template.format(index=i, rem_value=formatted_rem_value))

lua_code = "\n".join(padding_definitions)
pyperclip.copy(lua_code)