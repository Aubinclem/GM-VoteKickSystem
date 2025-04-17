local voteInProgress = false
local votes = {}

util.AddNetworkString("StartVoteKick")

hook.Add("PlayerSay", "VoteKickCommand", function(ply, text)
    if string.sub(text, 1, 10) == "!votekick " and not voteInProgress then
        local targetName = string.sub(text, 11)
        local target = nil
        for _, v in ipairs(player.GetAll()) do
            if string.find(string.lower(v:Nick()), string.lower(targetName)) then
                target = v
                break
            end
        end

        if target then
            voteInProgress = true
            votes = {}
            PrintMessage(HUD_PRINTTALK, ply:Nick() .. " a lancé un vote pour kick " .. target:Nick() .. "! Tapez !yes ou !no.")
            timer.Simple(30, function()
                local yes = 0
                local no = 0
                for _, v in pairs(votes) do
                    if v == true then yes = yes + 1 else no = no + 1 end
                end
                if yes > no then
                    target:Kick("Vote-kick approuvé par la majorité.")
                    PrintMessage(HUD_PRINTTALK, target:Nick() .. " a été kick par vote.")
                else
                    PrintMessage(HUD_PRINTTALK, "Le vote-kick contre " .. target:Nick() .. " a échoué.")
                end
                voteInProgress = false
            end)
        end
    elseif voteInProgress and (text == "!yes" or text == "!no") then
        votes[ply] = (text == "!yes")
        ply:ChatPrint("Votre vote a été pris en compte.")
    end
end)
