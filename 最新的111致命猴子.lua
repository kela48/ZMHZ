local _call3 =game:GetService("TweenService")
local _call5 =game:GetService("UserInputService")
local _call7 =game:GetService("Players")
local _call9 =game:GetService("RunService")
local _call11 =game:GetService("SoundService")
local _call13 =game:GetService("Lighting")
local _call15 =game:GetService("ReplicatedStorage")
local _LocalPlayer18 =_call7["LocalPlayer"]
local _CurrentCamera19 =game:GetService("Workspace")["CurrentCamera"]
local _call23 =Color3["fromRGB"](22, 22, 30)
local _call25 =Color3["fromRGB"](20, 20, 28)
local _call27 =Color3["fromRGB"](30, 30, 42)
local _call31 =Color3["fromRGB"](110, 110, 255)
local _call35 =Color3["fromRGB"](225, 225, 245)
local _call37 =Color3["fromRGB"](150, 150, 180)
local _call39 =Color3["fromRGB"](70, 70, 160)
local _call41 =Color3["fromRGB"](220, 80, 110)
local _call43 =Color3["fromRGB"](70, 160, 110)
local _call45 =Instance["new"]("ScreenGui")
_call45["Name"] ="ERHub_22612885"
_call45["ResetOnSpawn"] =false
_call45["ZIndexBehavior"] =Enum["ZIndexBehavior"]["Sibling"]
_call45["Parent"] =_LocalPlayer18:WaitForChild("PlayerGui")
local _call51 =Instance["new"]("TextButton")
_call51["Name"] ="MiniBox_22612885"
_call51["Size"] =UDim2["new"](0, 46, 0, 46)
_call51["Position"] =UDim2["new"](1, -62, 0.5, -23)
_call51["BackgroundColor3"] =_call23
_call51["Text"] =""
_call51["AutoButtonColor"] =false
_call51["Visible"] =true
_call51["Parent"] =_call45
local _call57 =Instance["new"]("UICorner", _call51)
_call57["CornerRadius"] =UDim["new"](0, 10)
local _call61 =Instance["new"]("UIStroke", _call51)
_call61["Color"] =_call31
_call61["Thickness"] =1.5
_call61["ApplyStrokeMode"] =Enum["ApplyStrokeMode"]["Border"]
local _call66 =_call51["MouseEnter"]:Connect(function()
local _call75 =_call3:Create(_call51, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = Color3["fromRGB"](40, 40, 56),
})
local _call77 =_call75:Play()
end)
local _call80 =_call51["MouseLeave"]:Connect(function()
local _call89 =_call3:Create(_call51, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call23,
})
local _call91 =_call89:Play()
end)
local _call93 =Instance["new"]("TextLabel", _call51)
_call93["Size"] =UDim2["new"](1, 0, 1, 0)
_call93["BackgroundTransparency"] =1
_call93["Text"] ="ER"
_call93["TextColor3"] =_call31
_call93["Font"] =Enum["Font"]["GothamBold"]
_call93["TextSize"] =20
local _call99 =Instance["new"]("Frame")
_call99["Name"] ="Main_22612885"
_call99["AnchorPoint"] =Vector2["new"](0.5, 0.5)
_call99["Size"] =UDim2["new"](0, 0, 0, 0)
_call99["Position"] =UDim2["new"](0.5, 0, 0.5, 0)
_call99["BackgroundColor3"] =Color3["fromRGB"](16, 16, 22)
_call99["Visible"] =false
_call99["ClipsDescendants"] =true
_call99["Parent"] =_call45
local _call107 =Instance["new"]("UICorner", _call99)
_call107["CornerRadius"] =UDim["new"](0, 12)
local _call111 =Instance["new"]("UIStroke", _call99)
_call111["Color"] =_call31
_call111["Thickness"] =1.5
_call111["ApplyStrokeMode"] =Enum["ApplyStrokeMode"]["Border"]
local _call115 =Instance["new"]("Frame")
_call115["Name"] ="TopBar_22612885"
_call115["Size"] =UDim2["new"](1, 0, 0, 52)
_call115["BackgroundColor3"] =_call25
_call115["Parent"] =_call99
local _call119 =Instance["new"]("UICorner", _call115)
_call119["CornerRadius"] =UDim["new"](0, 12)
local _call123 =Instance["new"]("Frame")
_call123["Size"] =UDim2["new"](0, 8, 0, 8)
_call123["Position"] =UDim2["new"](0, 20, 0, 12)
_call123["BackgroundColor3"] =_call31
_call123["Parent"] =_call115
local _call129 =Instance["new"]("UICorner", _call123)
_call129["CornerRadius"] =UDim["new"](0, 4)
local _call133 =Instance["new"]("TextLabel")
_call133["Size"] =UDim2["new"](1, -120, 0, 18)
_call133["Position"] =UDim2["new"](0, 40, 0, 8)
_call133["BackgroundTransparency"] =1
_call133["Text"] ="\xE8\x87\xB4\xE5\x91\xBD\xE7\x8C\xB4\xE5\xAD\x90"
_call133["TextColor3"] =_call35
_call133["Font"] =Enum["Font"]["GothamBold"]
_call133["TextSize"] =16
_call133["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
_call133["Parent"] =_call115
local _call143 =Instance["new"]("TextLabel")
_call143["Size"] =UDim2["new"](1, -120, 0, 14)
_call143["Position"] =UDim2["new"](0, 40, 0, 28)
_call143["BackgroundTransparency"] =1
_call143["Text"] ="\xE4\xBD\x9C\xE8\x80\x85 kela_er"
_call143["TextColor3"] =_call37
_call143["Font"] =Enum["Font"]["Gotham"]
_call143["TextSize"] =11
_call143["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
_call143["Parent"] =_call115
local _call153 =Instance["new"]("Frame")
_call153["Name"] ="BtnRow_22612885"
_call153["Size"] =UDim2["new"](0, 68, 0, 28)
_call153["Position"] =UDim2["new"](1, -76, 0, 12)
_call153["BackgroundTransparency"] =1
_call153["Parent"] =_call115
local _call159 =Instance["new"]("UIListLayout", _call153)
_call159["FillDirection"] =Enum["FillDirection"]["Horizontal"]
_call159["HorizontalAlignment"] =Enum["HorizontalAlignment"]["Right"]
_call159["VerticalAlignment"] =Enum["VerticalAlignment"]["Center"]
_call159["Padding"] =UDim["new"](0, 6)
_call159["SortOrder"] =Enum["SortOrder"]["LayoutOrder"]
local _call171 =Instance["new"]("TextButton")
_call171["Name"] ="MinBtn_22612885"
_call171["Size"] =UDim2["new"](0, 28, 0, 28)
_call171["LayoutOrder"] =1
_call171["BackgroundColor3"] =_call27
_call171["Text"] =""
_call171["AutoButtonColor"] =false
_call171["Parent"] =_call153
local _call175 =Instance["new"]("UICorner", _call171)
_call175["CornerRadius"] =UDim["new"](0, 8)
local _call179 =Instance["new"]("UIStroke", _call171)
_call179["Color"] =_call31
_call179["Thickness"] =1.2
_call179["ApplyStrokeMode"] =Enum["ApplyStrokeMode"]["Border"]
local _call184 =_call171["MouseEnter"]:Connect(function()
local _call193 =_call3:Create(_call171, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = Color3["fromRGB"](60, 60, 130),
})
local _call195 =_call193:Play()
end)
local _call198 =_call171["MouseLeave"]:Connect(function()
local _call207 =_call3:Create(_call171, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call27,
})
local _call209 =_call207:Play()
end)
local _call211 =Instance["new"]("Frame", _call171)
_call211["Name"] ="MinIcon_22612885"
_call211["Size"] =UDim2["new"](0, 14, 0, 14)
_call211["Position"] =UDim2["new"](0.5, -7, 0.5, -7)
_call211["BackgroundTransparency"] =1
local _call217 =Instance["new"]("Frame", _call211)
_call217["Size"] =UDim2["new"](1, -4, 0, 2)
_call217["Position"] =UDim2["new"](0, 2, 0.5, -1)
_call217["BackgroundColor3"] =_call37
_call217["BorderSizePixel"] =0
local _call223 =Instance["new"]("UICorner", _call217)
_call223["CornerRadius"] =UDim["new"](0, 1)
local _call227 =Instance["new"]("TextButton")
_call227["Name"] ="CloseBtn_22612885"
_call227["Size"] =UDim2["new"](0, 28, 0, 28)
_call227["LayoutOrder"] =2
_call227["BackgroundColor3"] =_call27
_call227["Text"] =""
_call227["AutoButtonColor"] =false
_call227["Parent"] =_call153
local _call231 =Instance["new"]("UICorner", _call227)
_call231["CornerRadius"] =UDim["new"](0, 8)
local _call235 =Instance["new"]("UIStroke", _call227)
_call235["Color"] =_call41
_call235["Thickness"] =1.2
_call235["ApplyStrokeMode"] =Enum["ApplyStrokeMode"]["Border"]
local _call242 =_call227["MouseEnter"]:Connect(function()
local _call251 =_call3:Create(_call227, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = Color3["fromRGB"](70, 30, 45),
})
local _call253 =_call251:Play()
end)
local _call256 =_call227["MouseLeave"]:Connect(function()
local _call265 =_call3:Create(_call227, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call27,
})
local _call267 =_call265:Play()
end)
local _call269 =Instance["new"]("Frame", _call227)
_call269["Name"] ="XIcon_22612885"
_call269["Size"] =UDim2["new"](0, 12, 0, 12)
_call269["Position"] =UDim2["new"](0.5, -6, 0.5, -6)
_call269["BackgroundTransparency"] =1
local _call275 =Instance["new"]("Frame", _call269)
_call275["Size"] =UDim2["new"](1, 0, 0, 2)
_call275["Position"] =UDim2["new"](0, 0, 0.5, -1)
_call275["BackgroundColor3"] =_call41
_call275["BorderSizePixel"] =0
_call275["Rotation"] =45
local _call281 =Instance["new"]("UICorner", _call275)
_call281["CornerRadius"] =UDim["new"](0, 1)
local _call285 =Instance["new"]("Frame", _call269)
_call285["Size"] =UDim2["new"](1, 0, 0, 2)
_call285["Position"] =UDim2["new"](0, 0, 0.5, -1)
_call285["BackgroundColor3"] =_call41
_call285["BorderSizePixel"] =0
_call285["Rotation"] =-45
local _call291 =Instance["new"]("UICorner", _call285)
_call291["CornerRadius"] =UDim["new"](0, 1)
local _call296 =_call115["InputBegan"]:Connect(function(_297)
local _301 =(_297["UserInputType"]==Enum["UserInputType"]["MouseButton1"])
local _305 =(_297["UserInputType"]==Enum["UserInputType"]["Touch"])
end)
local _call308 =_call115["InputEnded"]:Connect(function(_309)
local _313 =(_309["UserInputType"]==Enum["UserInputType"]["MouseButton1"])
local _317 =(_309["UserInputType"]==Enum["UserInputType"]["Touch"])
end)
local _call320 =_call5["InputEnded"]:Connect(function(_321)
local _325 =(_321["UserInputType"]==Enum["UserInputType"]["MouseButton1"])
local _329 =(_321["UserInputType"]==Enum["UserInputType"]["Touch"])
end)
local _call332 =_call5["InputChanged"]:Connect(function(_333)

end)
local _call335 =Instance["new"]("ScrollingFrame")
_call335["Name"] ="TabBar_22612885"
_call335["Size"] =UDim2["new"](0, 148, 1, -62)
_call335["Position"] =UDim2["new"](0, 8, 0, 58)
_call335["BackgroundColor3"] =_call25
_call335["Parent"] =_call99
_call335["ScrollBarThickness"] =4
_call335["ScrollBarImageColor3"] =_call31
_call335["CanvasSize"] =UDim2["new"](0, 0, 0, 0)
_call335["AutomaticCanvasSize"] =Enum["AutomaticSize"]["Y"]
_call335["ScrollingDirection"] =Enum["ScrollingDirection"]["Y"]
_call335["ScrollingEnabled"] =true
_call335["ElasticBehavior"] =Enum["ElasticBehavior"]["WhenScrollable"]
_call335["BorderSizePixel"] =0
local _call349 =Instance["new"]("UICorner", _call335)
_call349["CornerRadius"] =UDim["new"](0, 10)
local _call353 =Instance["new"]("UIStroke", _call335)
_call353["Color"] =_call39
_call353["Thickness"] =1
_call353["ApplyStrokeMode"] =Enum["ApplyStrokeMode"]["Border"]
local _call357 =Instance["new"]("UIListLayout", _call335)
_call357["Padding"] =UDim["new"](0, 6)
_call357["HorizontalAlignment"] =Enum["HorizontalAlignment"]["Center"]
_call357["SortOrder"] =Enum["SortOrder"]["LayoutOrder"]
local _call365 =Instance["new"]("UIPadding", _call335)
_call365["PaddingTop"] =UDim["new"](0, 8)
_call365["PaddingBottom"] =UDim["new"](0, 8)
local _call371 =Instance["new"]("Frame")
_call371["Name"] ="Content_22612885"
_call371["Size"] =UDim2["new"](1, -172, 1, -62)
_call371["Position"] =UDim2["new"](0, 164, 0, 58)
_call371["BackgroundColor3"] =_call23
_call371["Parent"] =_call99
local _call377 =Instance["new"]("UICorner", _call371)
_call377["CornerRadius"] =UDim["new"](0, 10)
local _call381 =Instance["new"]("UIStroke", _call371)
_call381["Color"] =_call39
_call381["Thickness"] =1
_call381["ApplyStrokeMode"] =Enum["ApplyStrokeMode"]["Border"]
local _call385 =Instance["new"]("TextButton")
_call385["Name"] ="ResizeHandle_22612885"
_call385["Size"] =UDim2["new"](0, 18, 0, 18)
_call385["Position"] =UDim2["new"](1, -20, 1, -20)
_call385["BackgroundTransparency"] =1
_call385["Text"] =""
_call385["AutoButtonColor"] =false
_call385["ZIndex"] =5
_call385["Parent"] =_call99
local _call391 =Instance["new"]("Frame", _call385)
_call391["Size"] =UDim2["new"](0, 2, 0, 5)
_call391["Position"] =UDim2["new"](0, 9, 0, 11)
_call391["AnchorPoint"] =Vector2["new"](1, 1)
_call391["BackgroundColor3"] =_call37
_call391["BorderSizePixel"] =0
_call391["Rotation"] =45
local _call399 =Instance["new"]("UICorner", _call391)
_call399["CornerRadius"] =UDim["new"](0, 1)
local _call403 =Instance["new"]("Frame", _call385)
_call403["Size"] =UDim2["new"](0, 2, 0, 7)
_call403["Position"] =UDim2["new"](0, 6, 0, 8)
_call403["AnchorPoint"] =Vector2["new"](1, 1)
_call403["BackgroundColor3"] =_call37
_call403["BorderSizePixel"] =0
_call403["Rotation"] =45
local _call411 =Instance["new"]("UICorner", _call403)
_call411["CornerRadius"] =UDim["new"](0, 1)
local _call415 =Instance["new"]("Frame", _call385)
_call415["Size"] =UDim2["new"](0, 2, 0, 9)
_call415["Position"] =UDim2["new"](0, 3, 0, 5)
_call415["AnchorPoint"] =Vector2["new"](1, 1)
_call415["BackgroundColor3"] =_call37
_call415["BorderSizePixel"] =0
_call415["Rotation"] =45
local _call423 =Instance["new"]("UICorner", _call415)
_call423["CornerRadius"] =UDim["new"](0, 1)
local _call428 =_call385["MouseEnter"]:Connect(function()
local _call437 =_call3:Create(_call391, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call31,
})
local _call439 =_call437:Play()
local _call447 =_call3:Create(_call403, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call31,
})
local _call449 =_call447:Play()
local _call457 =_call3:Create(_call415, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call31,
})
local _call459 =_call457:Play()
end)
local _call462 =_call385["MouseLeave"]:Connect(function()
local _call471 =_call3:Create(_call391, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call37,
})
local _call473 =_call471:Play()
local _call481 =_call3:Create(_call403, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call37,
})
local _call483 =_call481:Play()
local _call491 =_call3:Create(_call415, TweenInfo["new"](0.15, Enum["EasingStyle"]["Quart"], Enum["EasingDirection"]["Out"]), {
  ["BackgroundColor3"] = _call37,
})
local _call493 =_call491:Play()
end)
local _call495 =Vector2["new"](320, 240)
local _call497 =Vector2["new"](1200, 800)
local _call500 =_call385["InputBegan"]:Connect(function(_501)
local _505 =(_501["UserInputType"]==Enum["UserInputType"]["MouseButton1"])
local _509 =(_501["UserInputType"]==Enum["UserInputType"]["Touch"])
end)
local _call512 =_call5["InputEnded"]:Connect(function(_513)
local _517 =(_513["UserInputType"]==Enum["UserInputType"]["MouseButton1"])
local _521 =(_513["UserInputType"]==Enum["UserInputType"]["Touch"])
end)
local _call524 =_call5["InputChanged"]:Connect(function(_525)

end)
local _call527 =Instance["new"]("ScrollingFrame", _call371)
_call527["Size"] =UDim2["new"](1, -16, 1, -16)
_call527["Position"] =UDim2["new"](0, 8, 0, 8)
_call527["BackgroundTransparency"] =1
_call527["BorderSizePixel"] =0
_call527["ScrollBarThickness"] =3
_call527["ScrollBarImageColor3"] =_call31
_call527["CanvasSize"] =UDim2["new"](0, 0, 0, 0)
_call527["AutomaticCanvasSize"] =Enum["AutomaticSize"]["Y"]
local _call537 =Instance["new"]("UIListLayout", _call527)
_call537["Padding"] =UDim["new"](0, 8)
_call537["SortOrder"] =Enum["SortOrder"]["LayoutOrder"]
local _call543 =Instance["new"]("Frame", _call45)
_call543["Name"] ="NotifyHolder_22612885"
_call543["AnchorPoint"] =Vector2["new"](1, 0)
_call543["Position"] =UDim2["new"](1, -16, 0, 16)
_call543["Size"] =UDim2["new"](0, 250, 0, 0)
_call543["BackgroundTransparency"] =1
_call543["ZIndex"] =10
local _call551 =Instance["new"]("UIListLayout", _call543)
_call551["SortOrder"] =Enum["SortOrder"]["LayoutOrder"]
_call551["Padding"] =UDim["new"](0, 8)
_call551["VerticalAlignment"] =Enum["VerticalAlignment"]["Top"]
local _559, _559_2, _559_3 =string.lower(_LocalPlayer18["Name"])
local _call561 =Color3["fromRGB"](255, 0, 0)
local _call563 =Color3["fromRGB"](255, 255, 255)
local _call565 =Color3["fromRGB"](255, 255, 255)
local _call567 =Color3["fromRGB"](255, 235, 59)
local _call569 =Color3["fromRGB"](0, 255, 127)
local _call571 =Color3["fromRGB"](255, 255, 255)
local _call573 =Color3["fromRGB"](0, 255, 127)
local _call575 =Color3["fromRGB"](255, 235, 59)
local _call578 =_call9["Heartbeat"]:Connect(function()
for _582, _582_2 in ipairs(_call7:GetPlayers()) do
local _Name583 =_582_2["Name"]
end
end)
local _call587 =_call7["PlayerRemoving"]:Connect(function(_588)

end)
local _call591 =_call9["Heartbeat"]:Connect(function(_592)

end)
local _call594 =task["spawn"](function()

end)
local _call598 =_LocalPlayer18["CharacterAdded"]:Connect(function()

end)
local _Character600 =_LocalPlayer18["Character"]
_LocalPlayer18["CameraMode"] =Enum["CameraMode"]["Classic"]
_LocalPlayer18["CameraMinZoomDistance"] =0.5
_LocalPlayer18["CameraMaxZoomDistance"] =128
local _call604 =task["spawn"](function()

end)
local _call607 =Color3["fromRGB"](150, 150, 150)
local _call609 =Color3["fromRGB"](150, 150, 150)
local _call611 =Color3["fromRGB"](200, 200, 200)
local _call613 =Color3["fromRGB"](200, 200, 200)
local _call615 =Color3["fromRGB"](255, 255, 255)
local _call617 =Color3["fromRGB"](255, 255, 255)
local _call619 =Color3["fromRGB"](255, 0, 0)
local _call621 =Color3["fromRGB"](0, 255, 0)
local _call623 =Color3["fromRGB"](0, 0, 255)
local _call625 =Color3["fromRGB"](255, 255, 0)
local _call627 =Color3["fromRGB"](128, 0, 255)
local _call629 =Color3["fromRGB"](0, 255, 255)
local _call631 =Color3["fromRGB"](255, 255, 255)
local _call633 =Color3["fromRGB"](0, 0, 0)
local _call635 =Color3["fromRGB"](255, 150, 60)
local _call637 =Color3["fromRGB"](0, 255, 127)
local _call639 =Instance["new"]("TextButton", _call335)
_call639["Size"] =UDim2["new"](0.9, 0, 0, 34)
_call639["BackgroundColor3"] =_call27
_call639["Text"] =""
_call639["AutoButtonColor"] =false
local _call643 =Instance["new"]("UICorner", _call639)
_call643["CornerRadius"] =UDim["new"](0, 8)
local _call647 =Instance["new"]("Frame", _call639)
_call647["Name"] ="Highlight_22612885"
_call647["Size"] =UDim2["new"](0, 3, 0.6, 0)
_call647["Position"] =UDim2["new"](0, 0, 0.5, 0)
_call647["AnchorPoint"] =Vector2["new"](0, 0.5)
_call647["BackgroundColor3"] =_call31
_call647["Visible"] =false
local _call655 =Instance["new"]("UICorner", _call647)
_call655["CornerRadius"] =UDim["new"](0, 2)
local _call661 =Instance["new"]("Frame", _call639)
_call661["Name"] ="Icon_home_22612885"
_call661["Size"] =UDim2["new"](0, 14, 0, 14)
_call661["Position"] =UDim2["new"](0, 12, 0.5, -7)
_call661["BackgroundTransparency"] =1
local _call665 =Instance["new"]("Frame", _call661)
_call665["Size"] =UDim2["new"](0, 2, 0, 10)
_call665["Position"] =UDim2["new"](0, 6, 0, 2)
_call665["BackgroundColor3"] =_call31
_call665["BorderSizePixel"] =0
local _call671 =Instance["new"]("UICorner", _call665)
_call671["CornerRadius"] =UDim["new"](0, 1)
local _call675 =Instance["new"]("Frame", _call661)
_call675["Size"] =UDim2["new"](0, 10, 0, 2)
_call675["Position"] =UDim2["new"](0, 2, 0, 5)
_call675["BackgroundColor3"] =_call31
_call675["BorderSizePixel"] =0
local _call681 =Instance["new"]("UICorner", _call675)
_call681["CornerRadius"] =UDim["new"](0, 1)
for _686, _686_2 in ipairs(_call661:GetChildren()) do
local _call688 =_686_2:IsA("Frame")
end
local _call690 =Instance["new"]("TextLabel", _call639)
_call690["Size"] =UDim2["new"](1, -40, 1, 0)
_call690["Position"] =UDim2["new"](0, 36, 0, 0)
_call690["BackgroundTransparency"] =1
_call690["Text"] ="\xE6\x80\xAA\xE7\x89\xA9\xE9\x80\x8F\xE8\xA7\x86"
_call690["TextColor3"] =_call37
_call690["Font"] =Enum["Font"]["GothamBold"]
_call690["TextSize"] =13
_call690["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
local _call700 =Instance["new"]("Frame", _call527)
_call700["Size"] =UDim2["new"](1, 0, 0, 0)
_call700["BackgroundTransparency"] =1
_call700["Visible"] =false
_call700["AutomaticSize"] =Enum["AutomaticSize"]["Y"]
local _call706 =Instance["new"]("UIListLayout", _call700)
_call706["Padding"] =UDim["new"](0, 8)
_call706["SortOrder"] =Enum["SortOrder"]["LayoutOrder"]
local _call713 =_call639["MouseEnter"]:Connect(function()

end)
local _call717 =_call639["MouseLeave"]:Connect(function()

end)
local _call721 =_call639["MouseButton1Click"]:Connect(function()

end)
local _call724 =Instance["new"]("Frame", _call700)
_call724["Size"] =UDim2["new"](1, 0, 0, 22)
_call724["BackgroundTransparency"] =1
local _call730 =Instance["new"]("Frame", _call724)
_call730["Name"] ="Icon_bolt_22612885"
_call730["Size"] =UDim2["new"](0, 14, 0, 14)
_call730["Position"] =UDim2["new"](0, 0, 0.5, -7)
_call730["BackgroundTransparency"] =1
local _call734 =Instance["new"]("Frame", _call730)
_call734["Size"] =UDim2["new"](0, 3, 0, 7)
_call734["Position"] =UDim2["new"](0, 6, 0, 1)
_call734["BackgroundColor3"] =_call31
_call734["BorderSizePixel"] =0
local _call740 =Instance["new"]("UICorner", _call734)
_call740["CornerRadius"] =UDim["new"](0, 1.5)
_call734["Rotation"] =25
local _call744 =Instance["new"]("Frame", _call730)
_call744["Size"] =UDim2["new"](0, 3, 0, 7)
_call744["Position"] =UDim2["new"](0, 5, 0, 6)
_call744["BackgroundColor3"] =_call31
_call744["BorderSizePixel"] =0
local _call750 =Instance["new"]("UICorner", _call744)
_call750["CornerRadius"] =UDim["new"](0, 1.5)
_call744["Rotation"] =25
for _755, _755_2 in ipairs(_call730:GetChildren()) do
local _call757 =_755_2:IsA("Frame")
end
local _call759 =Instance["new"]("TextLabel", _call724)
_call759["Size"] =UDim2["new"](1, -20, 1, 0)
_call759["Position"] =UDim2["new"](0, 20, 0, 0)
_call759["BackgroundTransparency"] =1
_call759["Text"] ="ESP \xE6\x80\xBB\xE5\xBC\x80\xE5\x85\xB3"
_call759["TextColor3"] =_call31
_call759["Font"] =Enum["Font"]["GothamBold"]
_call759["TextSize"] =13
_call759["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
local _call769 =Instance["new"]("Frame", _call700)
_call769["Size"] =UDim2["new"](1, 0, 0, 34)
_call769["BackgroundColor3"] =_call27
local _call773 =Instance["new"]("UICorner", _call769)
_call773["CornerRadius"] =UDim["new"](0, 8)
local _call777 =Instance["new"]("TextLabel", _call769)
_call777["Size"] =UDim2["new"](1, -70, 1, 0)
_call777["Position"] =UDim2["new"](0, 12, 0, 0)
_call777["BackgroundTransparency"] =1
_call777["Text"] ="ESP \xE6\x80\xBB\xE5\xBC\x80\xE5\x85\xB3"
_call777["TextColor3"] =_call35
_call777["Font"] =Enum["Font"]["Gotham"]
_call777["TextSize"] =13
_call777["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
local _call787 =Instance["new"]("Frame", _call769)
_call787["Size"] =UDim2["new"](0, 40, 0, 20)
_call787["Position"] =UDim2["new"](1, -50, 0.5, -10)
_call787["BackgroundColor3"] =Color3["fromRGB"](50, 50, 70)
local _call795 =Instance["new"]("UICorner", _call787)
_call795["CornerRadius"] =UDim["new"](0, 10)
local _call799 =Instance["new"]("Frame", _call787)
_call799["Size"] =UDim2["new"](0, 16, 0, 16)
_call799["Position"] =UDim2["new"](0, 2, 0.5, -8)
_call799["BackgroundColor3"] =Color3["new"](1, 1, 1)
local _call807 =Instance["new"]("UICorner", _call799)
_call807["CornerRadius"] =UDim["new"](0, 8)
local _call811 =Instance["new"]("TextButton", _call769)
_call811["Size"] =UDim2["new"](1, 0, 1, 0)
_call811["BackgroundTransparency"] =1
_call811["Text"] =""
local _call816 =_call811["MouseButton1Click"]:Connect(function()

end)
local _call819 =Instance["new"]("Frame", _call700)
_call819["Size"] =UDim2["new"](1, 0, 0, 22)
_call819["BackgroundTransparency"] =1
local _call825 =Instance["new"]("Frame", _call819)
_call825["Name"] ="Icon_shield_22612885"
_call825["Size"] =UDim2["new"](0, 14, 0, 14)
_call825["Position"] =UDim2["new"](0, 0, 0.5, -7)
_call825["BackgroundTransparency"] =1
local _call829 =Instance["new"]("Frame", _call825)
_call829["Size"] =UDim2["new"](0, 2, 0, 10)
_call829["Position"] =UDim2["new"](0, 6, 0, 2)
_call829["BackgroundColor3"] =_call31
_call829["BorderSizePixel"] =0
local _call835 =Instance["new"]("UICorner", _call829)
_call835["CornerRadius"] =UDim["new"](0, 1)
local _call839 =Instance["new"]("Frame", _call825)
_call839["Size"] =UDim2["new"](0, 8, 0, 2)
_call839["Position"] =UDim2["new"](0, 3, 0, 6)
_call839["BackgroundColor3"] =_call31
_call839["BorderSizePixel"] =0
local _call845 =Instance["new"]("UICorner", _call839)
_call845["CornerRadius"] =UDim["new"](0, 1)
for _850, _850_2 in ipairs(_call825:GetChildren()) do
local _call852 =_850_2:IsA("Frame")
end
local _call854 =Instance["new"]("TextLabel", _call819)
_call854["Size"] =UDim2["new"](1, -20, 1, 0)
_call854["Position"] =UDim2["new"](0, 20, 0, 0)
_call854["BackgroundTransparency"] =1
_call854["Text"] ="\xE6\x98\xBE\xE7\xA4\xBA\xE9\x80\x89\xE9\xA1\xB9"
_call854["TextColor3"] =_call31
_call854["Font"] =Enum["Font"]["GothamBold"]
_call854["TextSize"] =13
_call854["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
local _call864 =Instance["new"]("Frame", _call700)
_call864["Size"] =UDim2["new"](1, 0, 0, 34)
_call864["BackgroundColor3"] =_call27
local _call868 =Instance["new"]("UICorner", _call864)
_call868["CornerRadius"] =UDim["new"](0, 8)
local _call872 =Instance["new"]("TextLabel", _call864)
_call872["Size"] =UDim2["new"](1, -70, 1, 0)
_call872["Position"] =UDim2["new"](0, 12, 0, 0)
_call872["BackgroundTransparency"] =1
_call872["Text"] ="\xE6\x80\xAA\xE7\x89\xA9\xE9\xAB\x98\xE4\xBA\xAE"
_call872["TextColor3"] =_call35
_call872["Font"] =Enum["Font"]["Gotham"]
_call872["TextSize"] =13
_call872["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
local _call882 =Instance["new"]("Frame", _call864)
_call882["Size"] =UDim2["new"](0, 40, 0, 20)
_call882["Position"] =UDim2["new"](1, -50, 0.5, -10)
_call882["BackgroundColor3"] =_call43
local _call888 =Instance["new"]("UICorner", _call882)
_call888["CornerRadius"] =UDim["new"](0, 10)
local _call892 =Instance["new"]("Frame", _call882)
_call892["Size"] =UDim2["new"](0, 16, 0, 16)
_call892["Position"] =UDim2["new"](1, -18, 0.5, -8)
_call892["BackgroundColor3"] =Color3["new"](1, 1, 1)
local _call900 =Instance["new"]("UICorner", _call892)
_call900["CornerRadius"] =UDim["new"](0, 8)
local _call904 =Instance["new"]("TextButton", _call864)
_call904["Size"] =UDim2["new"](1, 0, 1, 0)
_call904["BackgroundTransparency"] =1
_call904["Text"] =""
local _call909 =_call904["MouseButton1Click"]:Connect(function()

end)
local _call912 =Instance["new"]("Frame", _call700)
_call912["Size"] =UDim2["new"](1, 0, 0, 34)
_call912["BackgroundColor3"] =_call27
local _call916 =Instance["new"]("UICorner", _call912)
_call916["CornerRadius"] =UDim["new"](0, 8)
local _call920 =Instance["new"]("TextLabel", _call912)
_call920["Size"] =UDim2["new"](1, -70, 1, 0)
_call920["Position"] =UDim2["new"](0, 12, 0, 0)
_call920["BackgroundTransparency"] =1
_call920["Text"] ="\xE6\x80\xAA\xE7\x89\xA9\xE5\x90\x8D\xE5\xAD\x97"
_call920["TextColor3"] =_call35
_call920["Font"] =Enum["Font"]["Gotham"]
_call920["TextSize"] =13
_call920["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
local _call930 =Instance["new"]("Frame", _call912)
_call930["Size"] =UDim2["new"](0, 40, 0, 20)
_call930["Position"] =UDim2["new"](1, -50, 0.5, -10)
_call930["BackgroundColor3"] =_call43
local _call936 =Instance["new"]("UICorner", _call930)
_call936["CornerRadius"] =UDim["new"](0, 10)
local _call940 =Instance["new"]("Frame", _call930)
_call940["Size"] =UDim2["new"](0, 16, 0, 16)
_call940["Position"] =UDim2["new"](1, -18, 0.5, -8)
_call940["BackgroundColor3"] =Color3["new"](1, 1, 1)
local _call948 =Instance["new"]("UICorner", _call940)
_call948["CornerRadius"] =UDim["new"](0, 8)
local _call952 =Instance["new"]("TextButton", _call912)
_call952["Size"] =UDim2["new"](1, 0, 1, 0)
_call952["BackgroundTransparency"] =1
_call952["Text"] =""
local _call957 =_call952["MouseButton1Click"]:Connect(function()

end)
local _call960 =Instance["new"]("Frame", _call700)
_call960["Size"] =UDim2["new"](1, 0, 0, 34)
_call960["BackgroundColor3"] =_call27
local _call964 =Instance["new"]("UICorner", _call960)
_call964["CornerRadius"] =UDim["new"](0, 8)
local _call968 =Instance["new"]("TextLabel", _call960)
_call968["Size"] =UDim2["new"](1, -70, 1, 0)
_call968["Position"] =UDim2["new"](0, 12, 0, 0)
_call968["BackgroundTransparency"] =1
_call968["Text"] ="\xE8\xB7\x9D\xE7\xA6\xBB\xE6\x98\xBE\xE7\xA4\xBA"
_call968["TextColor3"] =_call35
_call968["Font"] =Enum["Font"]["Gotham"]
_call968["TextSize"] =13
_call968["TextXAlignment"] =Enum["TextXAlignment"]["Left"]
local _call978 =Instance["new"]("Frame", _call960)
_call978["Size"] =UDim2["new"](0, 40, 0, 20)
_call978["Position"] =UDim2["new"](1, -50, 0.5, -10)
_call978["BackgroundColor3"] =_call43
local _call984 =Instance["new"]("UICorner", _call978)
_call984["CornerRadius"] =UDim["new"](0, 10)
local _call988 =Instance["new"]("Frame", _call978)
_call988["Size"] =UDim2["new"](0, 16, 0, 16)
_call988["Position"] =UDim2["new"](1, -18, 0.5, -8)
_call988["BackgroundColor3"] =Color3["new"](1, 1, 1)
local _call996 =Instance["new"]("UICorner", _call988)
_call996["CornerRadius"] =UDim["new"](0, 8)
local _call1000 =Instance["new"]("TextButton", _call960)
_call1000["Size"] =UDim2["new"](1, 0, 1, 0)
_call1000["BackgroundTransparency"] =1
_call1000["Text"] =""
local _call1005 =_call1000["MouseButton1Click"]:Connect(function()

end)
local _call1008 =Instance["new"]("Frame", _call700)
_call1008["Size"] =UDim2["new"](1, 0, 0, 34)
_call1008["BackgroundColor3"] =_call27
local er =error("/app/dumper/ms25_dumper/httplog2:661: <25ms: infinitelooperror>")
