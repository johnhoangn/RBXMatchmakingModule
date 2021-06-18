--[[
	Inter-server matchmaking via MessagingService

	Enduo (Dynamese)
	6.17.2021
]]



local MessagingService = game:GetService("MessagingService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")


local Matchmaking = {}
local MatchingPool = {}


-- When a match is made, there are two scenarios:
-- A, the server that made the match is this one
--  in which we simply send the matchmade message to other servers
-- B, the server was not this one
--  in which we teleport relevant users over to the destination
-- @param userList <table>, arraylike that contains userIDs
-- @param jobID <string>, jobID of the server to teleport to, if necessary
-- @param password <string>, optional but if the destination is a private server
--  the teleport will fail
local function Matchmade(userList, jobID, password)

end


-- A user changed ready state
-- @param userID <integer>
-- @param state <boolean>
-- @param ..., anything extra metadata to add like group information
local function ReadyStateChanged(userID, state, ...)
    if (state and MatchingPool[userID] == nil) then
        Matchmaking:AddUserID(userID, ...)
    else
        MatchingPool[userID] = nil
    end
end


-- Looks at the entire list of users currently known to this server
--	and attempts to match them
-- @param numUsers == 2 <integer>, number of users to attempt to match together
-- @return true if success, false if fail
function Matchmaking:TryMatching(numUsers)
    if (self.Qualifier == nil) then
        warn("Matchmaking error! Matching qualifier was not defined!")

        return false
    end

	return false
end


-- Used to determine whether two users are qualified to match
-- @param callback <function> (userA, userB)
function Matchmaking:SetMatchingQualifier(callback)
	self.Qualifier = callback
end


-- Adds a user to the matching pool
-- @param userID <integer>
function Matchmaking:AddUserID(userID, ...)
	MatchingPool[userID] = {
        Data = {...};
        Local = Players:GetPlayerByUserId(userID) ~= nil;
    }
end


-- Removes a user from the matching pool
-- @param userID <integer>
function Matchmaking:RemoveUserID(userID)
	MatchingPool[userID] = nil
end


-- Teleports a list of users to a different server instance
-- @param userList <table>, arraylike containing userIDs
-- @param jobID <string>, jobID of the server to teleport to
-- @param password <string>
function Matchmaking:Teleport(userList, jobID, password)

end


MessagingService:SubscribeAsync("_Matchmade", Matchmade)
MessagingService:SubscribeAsync("_ReadyState", ReadyStateChanged)


return Matchmaking