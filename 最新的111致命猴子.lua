local _Name5 =game:GetService("Players")["LocalPlayer"]["Name"]
local _6, _6_2, _6_3 =string.lower(_Name5)
local _7, _7_2, _7_3 =string.lower(_Name5)
local _11 =loadstring(game:HttpGet("https://raw.githubusercontent.com/finendss/VowLibrary/refs/heads/main/WINDUI.lua"))()
local _call13 =game:GetService("Players")
local _call15 =game:GetService("RunService")
local _call19 =game:GetService("UserInputService")
local _call21 =game:GetService("Lighting")
local _call23 =game:GetService("ReplicatedStorage")
local _LocalPlayer24 =_call13["LocalPlayer"]
local _CurrentCamera25 =game:GetService("Workspace")["CurrentCamera"]
local _27, _27_2, _27_3 =string.lower(_LocalPlayer24["Name"])
local _call29 =Color3["fromRGB"](255, 0, 0)
local _call31 =Color3["fromRGB"](255, 255, 255)
local _call33 =Color3["fromRGB"](255, 255, 255)
local _call35 =Color3["fromRGB"](255, 235, 59)
local _call37 =Color3["fromRGB"](0, 255, 127)
local _call39 =Color3["fromRGB"](255, 255, 255)
local _call41 =Color3["fromRGB"](0, 255, 127)
local _call43 =Color3["fromRGB"](255, 235, 59)
local _call46 =_call13["PlayerRemoving"]:Connect(function(_47)

end)
local _call50 =_call15["Heartbeat"]:Connect(function(_51)

end)
local _call55 =_11:CreateWindow({
  ["Author"] = "\xE4\xBD\x9C\xE8\x80\x85kela_er",
  ["Resizable"] = true,
  ["ScrollBarEnabled"] = true,
  ["Title"] = "\xE8\x87\xB4\xE5\x91\xBD\xE7\x8C\xB4\xE5\xAD\x90",
  ["Transparent"] = true,
  ["HideSearchBar"] = false,
  ["Theme"] = "FIN",
  ["Icon"] = "eye",
  ["Size"] = UDim2["fromOffset"](600, 480),
})
local _call63 =_call55:EditOpenButton({
  ["StrokeThickness"] = 2,
  ["Title"] = "\xE8\x87\xB4\xE5\x91\xBD\xE7\x8C\xB4\xE5\xAD\x90",
  ["Color"] = ColorSequence["new"](Color3["fromHex"]("FF6B6B")),
  ["Draggable"] = true,
  ["Icon"] = "eye",
  ["CornerRadius"] = UDim["new"](0, 16),
})
local _call67 =_call55:Tag({
  ["Title"] = "00:00",
  ["Color"] = Color3["fromRGB"](255, 255, 255),
})
local _call69 =task["spawn"](function()
local _call74 =_call67:SetTitle("15:24")
local _call76 =_call67:SetColor(Color3["fromHSV"](0.01, 1, 1))
local _ =task.wait(0.5)
local _call80 =_call67:SetTitle("15:24")
local _call82 =_call67:SetColor(Color3["fromHSV"](0.02, 1, 1))
local _ =task.wait(0.5)
local _call86 =_call67:SetTitle("15:24")
local _call88 =_call67:SetColor(Color3["fromHSV"](0.03, 1, 1))
local _ =task.wait(0.5)
local _call92 =_call67:SetTitle("15:24")
local _call94 =_call67:SetColor(Color3["fromHSV"](0.04, 1, 1))
local _ =task.wait(0.5)
local _call98 =_call67:SetTitle("15:24")
local _call100 =_call67:SetColor(Color3["fromHSV"](0.05, 1, 1))
local _ =task.wait(0.5)
local _call104 =_call67:SetTitle("15:24")
local _call106 =_call67:SetColor(Color3["fromHSV"](0.060000000000000005, 1, 1))
local _ =task.wait(0.5)
local _call110 =_call67:SetTitle("15:24")
local _call112 =_call67:SetColor(Color3["fromHSV"](0.07, 1, 1))
local _ =task.wait(0.5)
local _call116 =_call67:SetTitle("15:24")
local _call118 =_call67:SetColor(Color3["fromHSV"](0.08, 1, 1))
local _ =task.wait(0.5)
local _call122 =_call67:SetTitle("15:24")
local _call124 =_call67:SetColor(Color3["fromHSV"](0.09, 1, 1))
local _ =task.wait(0.5)
local _call128 =_call67:SetTitle("15:24")
local _call130 =_call67:SetColor(Color3["fromHSV"](0.09999999999999999, 1, 1))
local _ =task.wait(0.5)
local _call134 =_call67:SetTitle("15:24")
local _call136 =_call67:SetColor(Color3["fromHSV"](0.10999999999999999, 1, 1))
local _ =task.wait(0.5)
local _call140 =_call67:SetTitle("15:24")
local _call142 =_call67:SetColor(Color3["fromHSV"](0.11999999999999998, 1, 1))
local _ =task.wait(0.5)
local _call146 =_call67:SetTitle("15:24")
local _call148 =_call67:SetColor(Color3["fromHSV"](0.12999999999999998, 1, 1))
local _ =task.wait(0.5)
local _call152 =_call67:SetTitle("15:24")
local _call154 =_call67:SetColor(Color3["fromHSV"](0.13999999999999999, 1, 1))
local _ =task.wait(0.5)
local _call158 =_call67:SetTitle("15:24")
local _call160 =_call67:SetColor(Color3["fromHSV"](0.15, 1, 1))
local _ =task.wait(0.5)
local _call164 =_call67:SetTitle("15:24")
local _call166 =_call67:SetColor(Color3["fromHSV"](0.16, 1, 1))
local _ =task.wait(0.5)
local _call170 =_call67:SetTitle("15:24")
local _call172 =_call67:SetColor(Color3["fromHSV"](0.17, 1, 1))
local _ =task.wait(0.5)
local _call176 =_call67:SetTitle("15:24")
local _call178 =_call67:SetColor(Color3["fromHSV"](0.18000000000000002, 1, 1))
local _ =task.wait(0.5)
local _call182 =_call67:SetTitle("15:24")
local _call184 =_call67:SetColor(Color3["fromHSV"](0.19000000000000003, 1, 1))
local _ =task.wait(0.5)
local _call188 =_call67:SetTitle("15:24")
local _call190 =_call67:SetColor(Color3["fromHSV"](0.20000000000000004, 1, 1))
local _ =task.wait(0.5)
local _call194 =_call67:SetTitle("15:24")
local _call196 =_call67:SetColor(Color3["fromHSV"](0.21000000000000005, 1, 1))
local _ =task.wait(0.5)
local _call200 =_call67:SetTitle("15:24")
local _call202 =_call67:SetColor(Color3["fromHSV"](0.22000000000000006, 1, 1))
local _ =task.wait(0.5)
local _call206 =_call67:SetTitle("15:24")
local _call208 =_call67:SetColor(Color3["fromHSV"](0.23000000000000007, 1, 1))
local _ =task.wait(0.5)
local _call212 =_call67:SetTitle("15:24")
local _call214 =_call67:SetColor(Color3["fromHSV"](0.24000000000000007, 1, 1))
local _ =task.wait(0.5)
local _call218 =_call67:SetTitle("15:24")
local _call220 =_call67:SetColor(Color3["fromHSV"](0.25000000000000006, 1, 1))
local _ =task.wait(0.5)
local _call224 =_call67:SetTitle("15:24")
local _call226 =_call67:SetColor(Color3["fromHSV"](0.26000000000000006, 1, 1))
local _ =task.wait(0.5)
local _call230 =_call67:SetTitle("15:24")
local _call232 =_call67:SetColor(Color3["fromHSV"](0.2700000000000001, 1, 1))
local _ =task.wait(0.5)
local _call236 =_call67:SetTitle("15:24")
local _call238 =_call67:SetColor(Color3["fromHSV"](0.2800000000000001, 1, 1))
local _ =task.wait(0.5)
local _call242 =_call67:SetTitle("15:24")
local _call244 =_call67:SetColor(Color3["fromHSV"](0.2900000000000001, 1, 1))
local _ =task.wait(0.5)
local _call248 =_call67:SetTitle("15:24")
local _call250 =_call67:SetColor(Color3["fromHSV"](0.3000000000000001, 1, 1))
local _ =task.wait(0.5)
local _call254 =_call67:SetTitle("15:24")
local _call256 =_call67:SetColor(Color3["fromHSV"](0.3100000000000001, 1, 1))
local _ =task.wait(0.5)
local _call260 =_call67:SetTitle("15:24")
local _call262 =_call67:SetColor(Color3["fromHSV"](0.3200000000000001, 1, 1))
local _ =task.wait(0.5)
local _call266 =_call67:SetTitle("15:24")
local _call268 =_call67:SetColor(Color3["fromHSV"](0.3300000000000001, 1, 1))
local _ =task.wait(0.5)
local _call272 =_call67:SetTitle("15:24")
local _call274 =_call67:SetColor(Color3["fromHSV"](0.34000000000000014, 1, 1))
local _ =task.wait(0.5)
local _call278 =_call67:SetTitle("15:24")
local _call280 =_call67:SetColor(Color3["fromHSV"](0.35000000000000014, 1, 1))
local _ =task.wait(0.5)
local _call284 =_call67:SetTitle("15:24")
local _call286 =_call67:SetColor(Color3["fromHSV"](0.36000000000000015, 1, 1))
local _ =task.wait(0.5)
local _call290 =_call67:SetTitle("15:24")
local _call292 =_call67:SetColor(Color3["fromHSV"](0.37000000000000016, 1, 1))
local _ =task.wait(0.5)
local _call296 =_call67:SetTitle("15:24")
local _call298 =_call67:SetColor(Color3["fromHSV"](0.38000000000000017, 1, 1))
local _ =task.wait(0.5)
local _call302 =_call67:SetTitle("15:24")
local _call304 =_call67:SetColor(Color3["fromHSV"](0.3900000000000002, 1, 1))
local _ =task.wait(0.5)
local _call308 =_call67:SetTitle("15:24")
local _call310 =_call67:SetColor(Color3["fromHSV"](0.4000000000000002, 1, 1))
local _ =task.wait(0.5)
local _call314 =_call67:SetTitle("15:24")
local _call316 =_call67:SetColor(Color3["fromHSV"](0.4100000000000002, 1, 1))
local _ =task.wait(0.5)
local _call320 =_call67:SetTitle("15:24")
local _call322 =_call67:SetColor(Color3["fromHSV"](0.4200000000000002, 1, 1))
local _ =task.wait(0.5)
local _call326 =_call67:SetTitle("15:24")
local _call328 =_call67:SetColor(Color3["fromHSV"](0.4300000000000002, 1, 1))
local _ =task.wait(0.5)
local _call332 =_call67:SetTitle("15:24")
local _call334 =_call67:SetColor(Color3["fromHSV"](0.4400000000000002, 1, 1))
local _ =task.wait(0.5)
local _call338 =_call67:SetTitle("15:24")
local _call340 =_call67:SetColor(Color3["fromHSV"](0.45000000000000023, 1, 1))
local _ =task.wait(0.5)
local _call344 =_call67:SetTitle("15:24")
local _call346 =_call67:SetColor(Color3["fromHSV"](0.46000000000000024, 1, 1))
local _ =task.wait(0.5)
local _call350 =_call67:SetTitle("15:24")
local _call352 =_call67:SetColor(Color3["fromHSV"](0.47000000000000025, 1, 1))
local _ =task.wait(0.5)
local _call356 =_call67:SetTitle("15:24")
local _call358 =_call67:SetColor(Color3["fromHSV"](0.48000000000000026, 1, 1))
local _ =task.wait(0.5)
local _call362 =_call67:SetTitle("15:24")
local _call364 =_call67:SetColor(Color3["fromHSV"](0.49000000000000027, 1, 1))
local _ =task.wait(0.5)
local _call368 =_call67:SetTitle("15:24")
local _call370 =_call67:SetColor(Color3["fromHSV"](0.5000000000000002, 1, 1))
local _ =task.wait(0.5)
local er =error("/app/dumper/ms25_dumper/httplog2:661: <25ms: infinitelooperror>")
end)
local _call375 =_call55:Tag({
  ["Title"] = "\xE6\x84\x9F\xE8\xB0\xA2\xE4\xBD\xBF\xE7\x94\xA8",
  ["Color"] = Color3["fromHex"]("#7FDBFF"),
})
local _call377 =_call55:Tab({
  ["Locked"] = false,
  ["Title"] = "\xE6\x80\xAA\xE7\x89\xA9\xE9\x80\x8F\xE8\xA7\x86",
  ["Icon"] = "settings",
})
local _call379 =_call377:Section({
  ["TextSize"] = 17,
  ["Title"] = "ESP \xE6\x80\xBB\xE5\xBC\x80\xE5\x85\xB3",
  ["TextXAlignment"] = "Left",
})
local _call381 =_call377:Toggle({
  ["Callback"] = function(_382)
local _call384 =_11:Notify({
  ["Duration"] = 3,
  ["Title"] = "ESP \xE5\xB7\xB2\xE5\xBC\x80\xE5\x90\xAF",
  ["Content"] = "",
})
end,
  ["Default"] = false,
  ["Title"] = "ESP \xE6\x80\xBB\xE5\xBC\x80\xE5\x85\xB3",
  ["Desc"] = "\xE5\xBC\x80\xE5\x90\xAF/\xE5\x85\xB3\xE9\x97\xAD\xE5\x85\xA8\xE9\x83\xA8\xE9\x80\x8F\xE8\xA7\x86\xE5\x8A\x9F\xE8\x83\xBD",
})
local _call386 =_call377:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE6\x98\xBE\xE7\xA4\xBA\xE9\x80\x89\xE9\xA1\xB9",
  ["TextXAlignment"] = "Left",
})
local _call388 =_call377:Toggle({
  ["Callback"] = function(_389)

end,
  ["Default"] = true,
  ["Title"] = "\xE6\x80\xAA\xE7\x89\xA9\xE9\xAB\x98\xE4\xBA\xAE",
  ["Desc"] = "\xE5\xA5\xBD\xE4\xBD\xBF",
})
local _call391 =_call377:Toggle({
  ["Callback"] = function(_392)

end,
  ["Default"] = true,
  ["Title"] = "\xE6\x80\xAA\xE7\x89\xA9\xE5\x90\x8D\xE5\xAD\x97",
  ["Desc"] = "\xE5\x9C\xA8\xE6\x80\xAA\xE7\x89\xA9\xE5\xA4\xB4\xE9\xA1\xB6\xE6\x98\xBE\xE7\xA4\xBA\xE5\x90\x8D\xE7\xA7\xB0",
})
local _call394 =_call377:Toggle({
  ["Callback"] = function(_395)

end,
  ["Default"] = true,
  ["Title"] = "\xE8\xB7\x9D\xE7\xA6\xBB\xE6\x98\xBE\xE7\xA4\xBA",
  ["Desc"] = "\xE6\x98\xBE\xE7\xA4\xBA\xE4\xBD\xA0\xE4\xB8\x8E\xE6\x80\xAA\xE7\x89\xA9\xE7\x9A\x84\xE8\xB7\x9D\xE7\xA6\xBB",
})
local _call397 =_call377:Toggle({
  ["Callback"] = function(_398)

end,
  ["Default"] = false,
  ["Title"] = "\xE8\xA1\x80\xE9\x87\x8F\xE6\x98\xBE\xE7\xA4\xBA",
  ["Desc"] = "\xE6\x98\xBE\xE7\xA4\xBA\xE6\x80\xAA\xE7\x89\xA9\xE5\xBD\x93\xE5\x89\x8D\xE8\xA1\x80\xE9\x87\x8F(\xE6\xB2\xA1\xE5\x95\xA5\xE7\x94\xA8)",
})
local _call400 =_call377:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE5\x8F\x82\xE6\x95\xB0\xE8\xB0\x83\xE8\x8A\x82",
  ["TextXAlignment"] = "Left",
})
local _call402 =_call377:Slider({
  ["Title"] = "\xE6\x9C\x80\xE5\xA4\xA7\xE6\x98\xBE\xE7\xA4\xBA\xE8\xB7\x9D\xE7\xA6\xBB",
  ["Value"] = {
  ["Min"] = 50,
  ["Default"] = 500,
  ["Max"] = 2000,
},
  ["Increment"] = 10,
  ["Callback"] = function(_403)

end,
  ["Desc"] = "\xE8\xB6\x85\xE8\xBF\x87\xE6\xAD\xA4\xE8\xB7\x9D\xE7\xA6\xBB\xE7\x9A\x84\xE6\x80\xAA\xE7\x89\xA9\xE4\xB8\x8D\xE6\x98\xBE\xE7\xA4\xBAESP",
})
local _call405 =_call377:Slider({
  ["Title"] = "\xE9\xAB\x98\xE4\xBA\xAE\xE5\xA1\xAB\xE5\x85\x85\xE9\x80\x8F\xE6\x98\x8E\xE5\xBA\xA6",
  ["Value"] = {
  ["Min"] = 0,
  ["Default"] = 0.5,
  ["Max"] = 1,
},
  ["Increment"] = 0.05,
  ["Callback"] = function(_406)

end,
  ["Desc"] = "0=\xE5\xAE\x8C\xE5\x85\xA8\xE4\xB8\x8D\xE9\x80\x8F\xE6\x98\x8E 1=\xE5\xAE\x8C\xE5\x85\xA8\xE9\x80\x8F\xE6\x98\x8E",
})
local _call408 =_call377:Slider({
  ["Title"] = "\xE6\x96\x87\xE5\xAD\x97\xE5\xA4\xA7\xE5\xB0\x8F",
  ["Value"] = {
  ["Min"] = 10,
  ["Default"] = 14,
  ["Max"] = 24,
},
  ["Increment"] = 1,
  ["Callback"] = function(_409)

end,
  ["Desc"] = "\xE8\xB0\x83\xE6\x95\xB4ESP\xE6\x96\x87\xE5\xAD\x97\xE6\x98\xBE\xE7\xA4\xBA\xE5\xA4\xA7\xE5\xB0\x8F",
})
local _call411 =_call55:Tab({
  ["Locked"] = false,
  ["Title"] = "\xE6\x80\xAA\xE7\x89\xA9\xE9\x80\x8F\xE8\xA7\x86\xE9\xA2\x9C\xE8\x89\xB2\xE8\xAE\xBE\xE7\xBD\xAE",
  ["Icon"] = "palette",
})
local _call413 =_call411:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE8\x87\xAA\xE5\xAE\x9A\xE4\xB9\x89\xE9\xA2\x9C\xE8\x89\xB2",
  ["TextXAlignment"] = "Left",
})
local _call415 =_call411:Dropdown({
  ["Value"] = "\xE7\xBA\xA2\xE8\x89\xB2",
  ["Callback"] = function(_416)
local _call418 =Color3["fromRGB"](255, 0, 0)
local er =error("/app/dumper/ms25_dumper/httplog2:661: <25ms: infinitelooperror>")
end,
  ["Title"] = "\xE9\xAB\x98\xE4\xBA\xAE\xE5\xA1\xAB\xE5\x85\x85\xE9\xA2\x9C\xE8\x89\xB2",
  ["Values"] = {
  [1] = "\xE7\xBA\xA2\xE8\x89\xB2",
  [2] = "\xE7\xBB\xBF\xE8\x89\xB2",
  [3] = "\xE8\x93\x9D\xE8\x89\xB2",
  [4] = "\xE9\xBB\x84\xE8\x89\xB2",
  [5] = "\xE7\xB4\xAB\xE8\x89\xB2",
  [6] = "\xE9\x9D\x92\xE8\x89\xB2",
  [7] = "\xE7\x99\xBD\xE8\x89\xB2",
  [8] = "\xE9\xBB\x91\xE8\x89\xB2",
},
})
local _call421 =_call411:Dropdown({
  ["Value"] = "\xE7\x99\xBD\xE8\x89\xB2",
  ["Callback"] = function(_422)

end,
  ["Title"] = "\xE9\xAB\x98\xE4\xBA\xAE\xE6\x8F\x8F\xE8\xBE\xB9\xE9\xA2\x9C\xE8\x89\xB2",
  ["Values"] = {
  [1] = "\xE7\x99\xBD\xE8\x89\xB2",
  [2] = "\xE7\xBA\xA2\xE8\x89\xB2",
  [3] = "\xE7\xBB\xBF\xE8\x89\xB2",
  [4] = "\xE8\x93\x9D\xE8\x89\xB2",
  [5] = "\xE9\xBB\x84\xE8\x89\xB2",
  [6] = "\xE9\xBB\x91\xE8\x89\xB2",
},
})
local _call424 =_call411:Dropdown({
  ["Value"] = "\xE7\x99\xBD\xE8\x89\xB2",
  ["Callback"] = function(_425)

end,
  ["Title"] = "\xE6\x80\xAA\xE7\x89\xA9\xE5\x90\x8D\xE5\xAD\x97\xE9\xA2\x9C\xE8\x89\xB2",
  ["Values"] = {
  [1] = "\xE7\x99\xBD\xE8\x89\xB2",
  [2] = "\xE7\xBA\xA2\xE8\x89\xB2",
  [3] = "\xE9\xBB\x84\xE8\x89\xB2",
  [4] = "\xE7\xBB\xBF\xE8\x89\xB2",
  [5] = "\xE9\x9D\x92\xE8\x89\xB2",
  [6] = "\xE7\xB4\xAB\xE8\x89\xB2",
},
})
local _call427 =_call55:Tab({
  ["Locked"] = false,
  ["Title"] = "\xE7\x8E\xA9\xE5\xAE\xB6\xE9\x80\x8F\xE8\xA7\x86",
  ["Icon"] = "users",
})
local _call429 =_call427:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE7\x8E\xA9\xE5\xAE\xB6 ESP \xE6\x80\xBB\xE5\xBC\x80\xE5\x85\xB3",
  ["TextXAlignment"] = "Left",
})
local _call431 =_call427:Toggle({
  ["Callback"] = function(_432)

end,
  ["Default"] = false,
  ["Title"] = "\xE7\x8E\xA9\xE5\xAE\xB6\xE9\x80\x8F\xE8\xA7\x86\xE6\x80\xBB\xE5\xBC\x80\xE5\x85\xB3",
  ["Desc"] = "\xE5\xBC\x80\xE5\x90\xAF/\xE5\x85\xB3\xE9\x97\xAD\xE5\x85\xA8\xE9\x83\xA8\xE7\x8E\xA9\xE5\xAE\xB6\xE9\x80\x8F\xE8\xA7\x86\xE5\x8A\x9F\xE8\x83\xBD",
})
local _call434 =_call427:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE6\x98\xBE\xE7\xA4\xBA\xE9\x80\x89\xE9\xA1\xB9",
  ["TextXAlignment"] = "Left",
})
local _call436 =_call427:Toggle({
  ["Callback"] = function(_437)

end,
  ["Default"] = true,
  ["Title"] = "\xE7\x8E\xA9\xE5\xAE\xB6\xE9\xAB\x98\xE4\xBA\xAE",
  ["Desc"] = "\xE4\xB8\xBA\xE7\x8E\xA9\xE5\xAE\xB6\xE6\xA8\xA1\xE5\x9E\x8B\xE6\xB7\xBB\xE5\x8A\xA0\xE9\xAB\x98\xE4\xBA\xAE\xE6\x8F\x8F\xE8\xBE\xB9",
})
local _call439 =_call427:Toggle({
  ["Callback"] = function(_440)

end,
  ["Default"] = true,
  ["Title"] = "\xE7\x8E\xA9\xE5\xAE\xB6\xE5\x90\x8D\xE5\xAD\x97",
  ["Desc"] = "\xE5\x9C\xA8\xE7\x8E\xA9\xE5\xAE\xB6\xE5\xA4\xB4\xE9\xA1\xB6\xE6\x98\xBE\xE7\xA4\xBA\xE5\x90\x8D\xE7\xA7\xB0",
})
local _call442 =_call427:Toggle({
  ["Callback"] = function(_443)

end,
  ["Default"] = true,
  ["Title"] = "\xE8\xB7\x9D\xE7\xA6\xBB\xE6\x98\xBE\xE7\xA4\xBA",
  ["Desc"] = "\xE6\x98\xBE\xE7\xA4\xBA\xE4\xBD\xA0\xE4\xB8\x8E\xE7\x8E\xA9\xE5\xAE\xB6\xE7\x9A\x84\xE8\xB7\x9D\xE7\xA6\xBB(\xE7\xB1\xB3)",
})
local _call445 =_call427:Toggle({
  ["Callback"] = function(_446)

end,
  ["Default"] = true,
  ["Title"] = "\xE8\xA1\x80\xE9\x87\x8F\xE6\x98\xBE\xE7\xA4\xBA",
  ["Desc"] = "\xE6\x98\xBE\xE7\xA4\xBA\xE7\x8E\xA9\xE5\xAE\xB6\xE5\xBD\x93\xE5\x89\x8D\xE8\xA1\x80\xE9\x87\x8F",
})
local _call448 =_call427:Toggle({
  ["Callback"] = function(_449)

end,
  ["Default"] = false,
  ["Title"] = "\xE6\x98\xBE\xE7\xA4\xBA\xE8\x87\xAA\xE5\xB7\xB1",
  ["Desc"] = "\xE6\x98\xAF\xE5\x90\xA6\xE4\xB9\x9F\xE6\x98\xBE\xE7\xA4\xBA\xE8\x87\xAA\xE5\xB7\xB1\xE7\x9A\x84\xE9\x80\x8F\xE8\xA7\x86",
})
local _call451 =_call427:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE5\x8F\x82\xE6\x95\xB0\xE8\xB0\x83\xE8\x8A\x82",
  ["TextXAlignment"] = "Left",
})
local _call453 =_call427:Slider({
  ["Title"] = "\xE6\x9C\x80\xE5\xA4\xA7\xE6\x98\xBE\xE7\xA4\xBA\xE8\xB7\x9D\xE7\xA6\xBB",
  ["Value"] = {
  ["Min"] = 50,
  ["Default"] = 1000,
  ["Max"] = 3000,
},
  ["Increment"] = 10,
  ["Callback"] = function(_454)

end,
  ["Desc"] = "\xE8\xB6\x85\xE8\xBF\x87\xE6\xAD\xA4\xE8\xB7\x9D\xE7\xA6\xBB\xE7\x9A\x84\xE7\x8E\xA9\xE5\xAE\xB6\xE4\xB8\x8D\xE6\x98\xBE\xE7\xA4\xBAESP",
})
local _call456 =_call427:Slider({
  ["Title"] = "\xE9\xAB\x98\xE4\xBA\xAE\xE5\xA1\xAB\xE5\x85\x85\xE9\x80\x8F\xE6\x98\x8E\xE5\xBA\xA6",
  ["Value"] = {
  ["Min"] = 0,
  ["Default"] = 0.5,
  ["Max"] = 1,
},
  ["Increment"] = 0.05,
  ["Callback"] = function(_457)

end,
  ["Desc"] = "0=\xE5\xAE\x8C\xE5\x85\xA8\xE4\xB8\x8D\xE9\x80\x8F\xE6\x98\x8E 1=\xE5\xAE\x8C\xE5\x85\xA8\xE9\x80\x8F\xE6\x98\x8E",
})
local _call459 =_call427:Slider({
  ["Title"] = "\xE6\x96\x87\xE5\xAD\x97\xE5\xA4\xA7\xE5\xB0\x8F",
  ["Value"] = {
  ["Min"] = 10,
  ["Default"] = 14,
  ["Max"] = 24,
},
  ["Increment"] = 1,
  ["Callback"] = function(_460)

end,
  ["Desc"] = "\xE8\xB0\x83\xE6\x95\xB4\xE7\x8E\xA9\xE5\xAE\xB6ESP\xE6\x96\x87\xE5\xAD\x97\xE5\xA4\xA7\xE5\xB0\x8F",
})
local _call462 =_call427:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE9\xA2\x9C\xE8\x89\xB2\xE8\xAE\xBE\xE7\xBD\xAE",
  ["TextXAlignment"] = "Left",
})
local _call464 =_call427:Dropdown({
  ["Value"] = "\xE7\xBB\xBF\xE8\x89\xB2",
  ["Callback"] = function(_465)

end,
  ["Title"] = "\xE9\xAB\x98\xE4\xBA\xAE\xE5\xA1\xAB\xE5\x85\x85\xE9\xA2\x9C\xE8\x89\xB2",
  ["Values"] = {
  [1] = "\xE7\xBB\xBF\xE8\x89\xB2",
  [2] = "\xE7\xBA\xA2\xE8\x89\xB2",
  [3] = "\xE8\x93\x9D\xE8\x89\xB2",
  [4] = "\xE9\xBB\x84\xE8\x89\xB2",
  [5] = "\xE7\xB4\xAB\xE8\x89\xB2",
  [6] = "\xE9\x9D\x92\xE8\x89\xB2",
  [7] = "\xE7\x99\xBD\xE8\x89\xB2",
  [8] = "\xE9\xBB\x91\xE8\x89\xB2",
},
})
local _call467 =_call427:Dropdown({
  ["Value"] = "\xE7\xBB\xBF\xE8\x89\xB2",
  ["Callback"] = function(_468)

end,
  ["Title"] = "\xE7\x8E\xA9\xE5\xAE\xB6\xE5\x90\x8D\xE5\xAD\x97\xE9\xA2\x9C\xE8\x89\xB2",
  ["Values"] = {
  [1] = "\xE7\xBB\xBF\xE8\x89\xB2",
  [2] = "\xE7\x99\xBD\xE8\x89\xB2",
  [3] = "\xE7\xBA\xA2\xE8\x89\xB2",
  [4] = "\xE9\xBB\x84\xE8\x89\xB2",
  [5] = "\xE9\x9D\x92\xE8\x89\xB2",
  [6] = "\xE7\xB4\xAB\xE8\x89\xB2",
},
})
local _call470 =Color3["fromRGB"](255, 215, 0)
local _call472 =Color3["fromRGB"](255, 255, 255)
local _call475 =_call15["Heartbeat"]:Connect(function()

end)
local _call479 =_call13["PlayerRemoving"]:Connect(function(_480)

end)
local _call482 =task["spawn"](function()

end)
local _call486 =_LocalPlayer24["CharacterAdded"]:Connect(function()

end)
local _Character488 =_LocalPlayer24["Character"]
_LocalPlayer24["CameraMode"] =Enum["CameraMode"]["Classic"]
_LocalPlayer24["CameraMinZoomDistance"] =0.5
_LocalPlayer24["CameraMaxZoomDistance"] =128
local _call493 =_LocalPlayer24["CharacterAdded"]:Connect(function()

end)
local _call496 =task["spawn"](function()

end)
local _call499 =_call55:Tab({
  ["Locked"] = false,
  ["Title"] = "\xE7\x8E\xA9\xE5\xAE\xB6\xE5\x8A\x9F\xE8\x83\xBD",
  ["Icon"] = "user",
})
local _call501 =_call499:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE6\x80\xAA\xE7\x89\xA9\xE7\xAA\x81\xE8\x84\xB8",
  ["TextXAlignment"] = "Left",
})
local _call503 =_call499:Toggle({
  ["Callback"] = function(_504)

end,
  ["Default"] = false,
  ["Title"] = "\xE5\x88\xA0\xE9\x99\xA4\xE6\x80\xAA\xE7\x89\xA9\xE7\xAA\x81\xE8\x84\xB8",
  ["Desc"] = "\xE5\x88\xA0\xE9\x99\xA4\xE6\x80\xAA\xE7\x89\xA9\xE7\xAA\x81\xE8\x84\xB8\xE5\x8A\xA8\xE7\x94\xBB",
})
local _call506 =_call499:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE9\x80\x9F\xE5\xBA\xA6",
  ["TextXAlignment"] = "Left",
})
local _call508 =_call499:Slider({
  ["Title"] = "\xE8\xA1\x8C\xE8\xB5\xB0\xE9\x80\x9F\xE5\xBA\xA6",
  ["Value"] = {
  ["Min"] = 40,
  ["Default"] = 40,
  ["Max"] = 500,
},
  ["Increment"] = 1,
  ["Callback"] = function(_509)

end,
  ["Desc"] = "\xE5\x88\xAB\xE8\xB0\x83\xE5\xA4\xAA\xE5\xBF\xAB",
})
local _call511 =_call499:Dropdown({
  ["Value"] = "\xE9\xBB\x98\xE8\xAE\xA4(40)",
  ["Callback"] = function(_512)

end,
  ["Title"] = "\xE9\x80\x9F\xE5\xBA\xA6",
  ["Values"] = {
  [1] = "\xE9\xBB\x98\xE8\xAE\xA4(40)",
  [2] = "\xE5\xBF\xAB\xE9\x80\x9F(50)",
  [3] = "\xE6\x9E\x81\xE9\x80\x9F(150)",
  [4] = "\xE5\x85\x89\xE9\x80\x9F(300)",
  [5] = "\xE8\xB6\x85\xE5\x85\x89\xE9\x80\x9F(500)",
},
})
local _call514 =_call499:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE8\xB7\xB3\xE8\xB7\x83\xE6\x8E\xA7\xE5\x88\xB6",
  ["TextXAlignment"] = "Left",
})
local _call516 =_call499:Slider({
  ["Title"] = "\xE8\xB7\xB3\xE8\xB7\x83\xE5\x8A\x9B",
  ["Value"] = {
  ["Min"] = 60,
  ["Default"] = 60,
  ["Max"] = 500,
},
  ["Increment"] = 1,
  ["Callback"] = function(_517)

end,
  ["Desc"] = "\xE4\xB8\x8D\xE8\xA6\x81\xE8\xB0\x83\xE5\xA4\xAA\xE9\xAB\x98",
})
local _call519 =_call499:Toggle({
  ["Callback"] = function(_520)

end,
  ["Default"] = false,
  ["Title"] = "\xE6\x97\xA0\xE9\x99\x90\xE8\xB7\xB3\xE8\xB7\x83",
  ["Desc"] = "\xE6\x97\xA0\xE9\x99\x90\xE8\xB7\xB3",
})
local _call522 =_call499:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE9\x87\x8D\xE5\x8A\x9B\xE8\xB0\x83\xE8\x8A\x82",
  ["TextXAlignment"] = "Left",
})
local _call524 =_call499:Slider({
  ["Title"] = "\xE9\x87\x8D\xE5\x8A\x9B",
  ["Value"] = {
  ["Min"] = 0,
  ["Default"] = 196,
  ["Max"] = 400,
},
  ["Increment"] = 1,
  ["Callback"] = function(_525)

end,
  ["Desc"] = "196=\xE9\xBB\x98\xE8\xAE\xA4,\xE8\xB6\x8A\xE4\xBD\x8E\xE8\xB7\xB3\xE5\xBE\x97\xE8\xB6\x8A\xE9\xAB\x98/\xE9\xA3\x98",
})
local _call527 =_call499:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE5\xA4\x8D\xE6\xB4\xBB",
  ["TextXAlignment"] = "Left",
})
local _call529 =_call499:Button({
  ["Callback"] = function()

end,
  ["Title"] = "\xE7\xAB\x8B\xE5\x8D\xB3\xE5\xA4\x8D\xE6\xB4\xBB",
  ["Desc"] = "",
})
local _call532 =_call499:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE7\xAC\xAC\xE4\xB8\x89\xE4\xBA\xBA\xE7\xA7\xB0",
  ["TextXAlignment"] = "Left",
})
local _call534 =_call499:Toggle({
  ["Callback"] = function(_535)

end,
  ["Default"] = true,
  ["Title"] = "\xE7\xAC\xAC\xE4\xB8\x89\xE4\xBA\xBA\xE7\xA7\xB0",
  ["Desc"] = "",
})
local _call537 =Color3["fromRGB"](150, 150, 150)
local _call539 =Color3["fromRGB"](150, 150, 150)
local _call541 =Color3["fromRGB"](200, 200, 200)
local _call543 =Color3["fromRGB"](200, 200, 200)
local _call545 =Color3["fromRGB"](255, 255, 255)
local _call547 =Color3["fromRGB"](255, 255, 255)
local _call549 =_call55:Tab({
  ["Locked"] = false,
  ["Title"] = "\xE5\x85\xB6\xE4\xBB\x96\xE5\x8A\x9F\xE8\x83\xBD",
  ["Icon"] = "zap",
})
local _call551 =_call549:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE4\xBA\xAE\xE5\xBA\xA6\xE6\x8F\x90\xE5\x8D\x87",
  ["TextXAlignment"] = "Left",
})
local _call553 =_call549:Toggle({
  ["Callback"] = function(_554)

end,
  ["Default"] = false,
  ["Title"] = "\xE4\xBA\xAE\xE5\xBA\xA6\xE6\x8F\x90\xE5\x8D\x87",
  ["Desc"] = "\xE4\xB8\x8D\xE5\xBB\xBA\xE8\xAE\xAE\xE4\xBD\xBF\xE7\x94\xA8\xE8\xB6\x85\xE4\xBA\xAE",
})
local _call556 =_call549:Dropdown({
  ["Title"] = "\xE4\xBA\xAE\xE5\xBA\xA6\xE7\xAD\x89\xE7\xBA\xA7",
  ["Value"] = "\xE4\xB8\xAD\xE4\xBA\xAE",
  ["Values"] = {
  [1] = "\xE5\xBE\xAE\xE4\xBA\xAE",
  [2] = "\xE4\xB8\xAD\xE4\xBA\xAE",
  [3] = "\xE8\xB6\x85\xE4\xBA\xAE",
},
  ["Callback"] = function(_557)

end,
  ["Desc"] = "\xE5\xBE\xAE\xE4\xBA\xAE / \xE4\xB8\xAD\xE4\xBA\xAE / \xE8\xB6\x85\xE4\xBA\xAE",
})
local _call559 =_call549:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE4\xBD\x9C\xE8\x80\x85\xE4\xBF\xA1\xE6\x81\xAF",
  ["TextXAlignment"] = "Left",
})
local _call561 =_call549:Button({
  ["Callback"] = function()

end,
  ["Title"] = "\xE5\xA4\x8D\xE5\x88\xB6\xE4\xBD\x9C\xE8\x80\x85UID",
  ["Desc"] = "\xE7\x82\xB9\xE5\x87\xBB\xE5\xA4\x8D\xE5\x88\xB6 UID:3493085004695814 | \xE4\xBD\x9C\xE8\x80\x85B\xE7\xAB\x99",
})
local _call564 =_call549:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE4\xBD\x9C\xE8\x80\x85\xE5\x85\xAC\xE5\x91\x8A",
  ["TextXAlignment"] = "Left",
})
local _call566 =_call549:Paragraph({
  ["Title"] = "\xE5\x85\xAC\xE5\x91\x8A",
  ["Desc"] = "\xE6\xAD\xA4\xE8\x84\x9A\xE6\x9C\xAC\xE5\x9B\xA0\xE4\xB8\xBA\xE8\xA2\xAB\xE5\xBC\x80\xE6\xBA\x90\xE5\x81\x9C\xE6\x9B\xB4\xE4\xBA\x86\xE4\xB8\x80\xE6\xAE\xB5\xE6\x97\xB6\xE9\x97\xB4\xEF\xBC\x8C\xE8\x84\x9A\xE6\x9C\xAC\xE4\xB8\xBAAI\xE5\x88\xB6\xE4\xBD\x9C\xE6\xB0\xB8\xE4\xB9\x85\xE5\x85\xAC\xE7\x9B\x8A\xEF\xBC\x8C\xE8\xB0\xA2\xE8\xB0\xA2\xE9\x85\x8D\xE5\x90\x88\xEF\xBC\x81",
})
local _call568 =_call549:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE6\x9B\xB4\xE6\x96\xB0\xE6\x97\xA5\xE5\xBF\x97",
  ["TextXAlignment"] = "Left",
})
local _call570 =_call549:Paragraph({
  ["Title"] = "\xE6\x9B\xB4\xE6\x96\xB0\xE6\x97\xA5\xE5\xBF\x97",
  ["Desc"] = "\xE6\x9B\xB4\xE6\x96\xB0\xE4\xBA\x86\xE5\xA4\x8D\xE6\xB4\xBB\xEF\xBC\x8C\xE5\x9B\xA0\xE4\xB8\xBA\xE6\x96\xB0\xE7\x89\x88\xE6\x9C\xAC\xE7\x9A\x84\xE5\x8E\x9F\xE5\x9B\xA0\xE5\x8E\xBB\xE6\x8E\x89\xE4\xBA\x86\xE4\xB8\x80\xE4\xBA\x9B\xE5\x8A\x9F\xE8\x83\xBD\xE3\x80\x82\xE5\x8D\xB3\xE5\xB0\x86\xE6\x9B\xB4\xE6\x96\xB0\xE2\x80\x9C\xE6\xB4\x9E\xE7\xA9\xB4\xE2\x80\x9D",
})
local _call572 =_call55:Tab({
  ["Locked"] = false,
  ["Title"] = "\xE9\xA3\x9E\xE8\xA1\x8C\xE8\x84\x9A\xE6\x9C\xAC",
  ["Icon"] = "wind",
})
local _call574 =_call572:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE9\xA3\x9E\xE8\xA1\x8C",
  ["TextXAlignment"] = "Left",
})
local _call576 =_call572:Button({
  ["Callback"] = function()

end,
  ["Title"] = "\xE9\xA3\x9E\xE8\xA1\x8C",
  ["Desc"] = "\xE7\x82\xB9\xE5\x87\xBB\xE6\x89\xA7\xE8\xA1\x8C\xE9\xA3\x9E\xE8\xA1\x8C\xE8\x84\x9A\xE6\x9C\xAC",
})
local _call579 =_call55:Tab({
  ["Locked"] = false,
  ["Title"] = "\xE5\x88\xB7\xE9\x92\xB1",
  ["Icon"] = "wind",
})
local _call581 =_call579:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE5\x88\xB7\xE9\x92\xB1",
  ["TextXAlignment"] = "Left",
})
local _call583 =_call579:Button({
  ["Callback"] = function()

end,
  ["Title"] = "\xE5\x88\xB7\xE9\x92\xB1",
  ["Desc"] = "\xE7\x82\xB9\xE5\x87\xBB\xE6\x89\xA7\xE8\xA1\x8C\xE5\x88\xB7\xE9\x92\xB1\xE8\x84\x9A\xE6\x9C\xAC",
})
local _call586 =_call55:Tab({
  ["Locked"] = false,
  ["Title"] = "\xE7\x94\xA9\xE9\xA3\x9E",
  ["Icon"] = "wind",
})
local _call588 =_call586:Section({
  ["TextSize"] = 17,
  ["Title"] = "\xE7\x94\xA9\xE9\xA3\x9E",
  ["TextXAlignment"] = "Left",
})
local _call590 =_call586:Button({
  ["Callback"] = function()

end,
  ["Title"] = "\xE7\x94\xA9\xE9\xA3\x9E",
  ["Desc"] = "\xE7\x82\xB9\xE5\x87\xBB\xE6\x89\xA7\xE8\xA1\x8C\xE7\x94\xA9\xE9\xA3\x9E\xE8\x84\x9A\xE6\x9C\xAC",
})
