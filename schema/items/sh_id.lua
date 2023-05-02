-- Item Statistics

ITEM.name = "Identification Card"
ITEM.description = "Originally instituted when proposed by Luna Solaris in December 2005, the now-standard ID Card system replaced the previous system of exclusively ID Numbers.\nPreviously, Citizens were expected to remember their 5 digit identification number, which was wildly unpopular with the elderly."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/dorado/tarjeta2.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

function ITEM:PopulateTooltip(tooltip)
    local data = tooltip:AddRow("data")
    data:SetBackgroundColor(derma.GetColor("Success", tooltip))
    data:SetText("Name: " .. self:GetData("name", "Unissued") .. "\nID Number: " .. self:GetData("id", "00000") .. "\nIssue Date: " .. self:GetData("issueDate", "Unissued"))
    data:SetFont("BudgetLabel")
    data:SetExpensiveShadow(0.5)
    data:SizeToContents()

    local warning = tooltip:AddRow("warning")
    warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
    warning:SetText("Each card has an RFID chip and a photo of whoever was present at the time of it being issued. It would be unwise to get caught with a card that isn't yours.")
    warning:SetFont("DermaDefault")
    warning:SetExpensiveShadow(0.5)
    warning:SizeToContents()
end