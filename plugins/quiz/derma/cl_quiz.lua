local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
    self:MakePopup()
    self:SetMouseInputEnabled(true)
    self:MoveToFront()

    self.disconnectButton = self:Add("ixMenuButton")
    self.disconnectButton:SetSize(300, 40)
    self.disconnectButton:SetPos(60, ScrH() - 100)
    self.disconnectButton:SetText("Disconnect")
    self.disconnectButton:SetContentAlignment(4)
    self.disconnectButton.DoClick = function()
        self:Remove()
        -- RunConsoleCommand("disconnect")
    end

    self.questions = self:Add("DScrollPanel")
    self.questions:Dock(FILL)
    self.questions:DockMargin(ScreenScale(50), ScreenScale(50), ScreenScale(50), ScreenScale(50))
    self.questions.PaintOver = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 100))
    end
    
    for k, v in ipairs(ix.quiz.GetQuestions()) do
        local question = self.questions:Add("DComboBox")
        question:SetSize(300, 30)
        question:Dock(TOP)
        question:DockMargin(ScreenScale(10), ScreenScale(10), ScreenScale(10), 0)
        question:SetValue(v.message or "#EE")
        for o, i in ipairs(ix.quiz.GetOptions(k)) do
            question:AddChoice(i, o)
        end
        
        combo = question
    end
    
    self.finishButton = self:Add("ixMenuButton")
    self.finishButton:SetSize(300, 40)
    self.finishButton:SetPos(ScrW() - 360, ScrH() - 100)
    self.finishButton:SetText("Finish")
    self.finishButton:SetContentAlignment(6)
    self.finishButton.DoClick = function()
        self:Remove()
        -- RunConsoleCommand("disconnect")
    end
end

vgui.Register("ixQuiz", PANEL, "DFrame")