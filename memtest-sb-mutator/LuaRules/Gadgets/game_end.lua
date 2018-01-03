if not gadgetHandler:IsSyncedCode() then
    return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:GetInfo()
    return {
        name      = "Game Over",
        desc      = "GAME OVER! (handles conditions thereof)",
        author    = "SirMaverick, Google Frog, KDR_11k, CarRepairer (unified by KingRaptor)",
        date      = "2009",
        license   = "GPL",
        layer     = 1,
        enabled   = true  --  loaded by default?
    }
end

function gadget:GameFrame(f)
    if f > 30 then
        Spring.SendCommands("quitforce")
    end
end

function gadget:GameOver()
end

