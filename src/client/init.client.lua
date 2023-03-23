local Azura = require(script.Azura.Azura)

local Window = Azura:createWindow()

local DropDownMenuFrame = Window:createFrame({
    class = "w-[100px] h-[100px]",
})

local Navbar = Window:createFrame({
    class="w-full h-[32px] bg-slate-800 rounded-md p-1 flex gap-1"
},{

    MenuButton = Window:createTextButton({
        Name = "Navbar",
        Text = "Navbar",
        class="h-full bg-slate-800 text-white px-2 rounded-md as",
       
    }),

    Window:createTextButton({
        Name = "Navbar",
        Text = "Navbar",
        class="h-full bg-slate-800 text-white px-2 rounded-md as"
    }),
    Window:createTextButton({
        Name = "WindowButton",
        Text = "WindowButton",
        class="h-full bg-slate-800 text-white px-2 rounded-md as",
        DropDownMenu = {
            DropDownMenuFrame,
            offset = 4,
        },
        onClick = (function(self, Properties)
            print(self ,Properties)
        end)
    }),

})
