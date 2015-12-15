--[[
The base elements are shared by every custom item
]]
local baseSchema = tc.assertTable{
    buttonColor =
        tc.assert(
            tc.optional(tc.tableOf(isnumber)),
            "The buttonColor must be a Color value."
        ),

    category =
        tc.assert(
            tc.optional(isstring),
            "The category must be the name of an existing category!"
        ),

    customCheck =
        tc.assert(
            tc.optional(isfunction),
            "The customCheck must be a function."
        ),

    CustomCheckFailMsg =
        tc.assert(
            tc.optional(isstring, isfunction),
            "The CustomCheckFailMsg must be either a string or a function."
        ),

    sortOrder =
        tc.assert(
            tc.optional(isnumber),
            "The sortOrder must be a number."
        ),

    label =
        tc.assert(
            tc.optional(isstring),
            "The label must be a valid string."
        ),
}

--[[
Properties shared by anything buyable
]]
local BuyableSchema = fn.FAnd{baseSchema, tc.assertTable{
    allowed =
        tc.assert(
            tc.optional(tc.tableOf(isnumber), isnumber),
            "The allowed field must be either an existing team or a table of existing teams.",
            {"Is there a job here that doesn't exist (anymore)?"}
        ),

    getPrice =
        tc.assert(
            tc.optional(isfunction),
            "The getPrice must be a function."
        ),

    model =
        tc.assert(isstring,
            "The model must be valid."
        ),

    price =
        tc.assert(
            function(v, tbl) return isnumber(v) or isfunction(tbl.getPrice) end,
            "The price must be an existing number or (for advanced users) the getPrice field must be a function."
        ),

    spawn =
        tc.assert(
            tc.optional(isfunction),
            "The spawn must be a function."
        ),
}}

-- The command of an entity must be unique
local uniqueEntity = function(cmd, tbl)
    for k, v in pairs(DarkRPEntities) do
        if v.cmd ~= cmd then continue end

        return
            false,
            "This entity does not have a unique command.",
            {
                "There must be some other end that has the same thing for 'cmd'.",
                "Fix this by changing the 'cmd' field of your entity to something else."
            }
    end

    return true
end

-- The command of a job must be unique
local uniqueJob = function(v, tbl)
    local job = DarkRP.getJobByCommand(v)

    if not job then return true end

    return
        false,
        "This job does not have a unique command.",
        {
            "There must be some other job that has the same command.",
            "Fix this by changing the 'command' of your job to something else."
        }
end

--[[
Validate jobs
]]
DarkRP.validateJob = fn.FAnd{baseSchema, tc.assertTable{
    color =
        tc.assert(
            tc.tableOf(isnumber),
            "The color must be a Color value.",
            {"Color values look like this: Color(r, g, b, a), where r, g, b and a are numbers between 0 and 255."}
        ),

    model =
        tc.assert(
            fn.FOr{isstring, tc.nonEmpty(tc.tableOf(isstring))},
            "The model must either be a table of correct model strings or a single correct model string.",
            {
                "This error could happens when the model does not exist on the server.",
                "Are you sure the model path is right?",
                "Is the model from an addon that is not properly installed?"
            }
        ),

    description =
        tc.assert(
            isstring,
            "The description must be a string."
        ),

    weapons =
        tc.assert(
            tc.optional(tc.tableOf(isstring)),
            "The weapons must be a valid table of strings.",
            {"Example: weapons = {\"med_kit\", \"weapon_bugbait\"},"}
        ),

    command =
        tc.assert(
            fn.FAnd{isstring, uniqueJob},
            "The command must be a string."
        ),

    max =
        tc.assert(
            fn.FAnd{isnumber, fp{fn.Lte, 0}},
            "The max must be a number greater than or equal to zero.",
            {
                "Zero means infinite.",
                "A decimal between 0 and 1 is seen as a percentage."
            }
        ),

    salary =
        tc.assert(
            fn.FAnd{isnumber, fp{fn.Lte, 0}},
            "The salary must be a number greater than zero."
        ),

    admin =
        tc.assert(
            fn.FAnd{isnumber, fp{fn.Lte, 0}, fp{fn.Gte, 2}},
            "The admin value must be a number greater than or equal to zero and smaller than three."
        ),

    vote =
        tc.assert(
            tc.optional(isbool),
            "The vote must be either true or false."
        ),

    ammo =
        tc.assert(
            tc.optional(tc.tableOf(isnumber)),
            "The ammo must be a table containing numbers.",
            {"See example on http://wiki.darkrp.com/index.php/DarkRP:CustomJobFields"}
        ),

    hasLicense =
        tc.assert(
            tc.optional(isbool),
            "The hasLicense must be either true or false."
        ),

    NeedToChangeFrom =
        tc.assert(
            tc.optional(tc.tableOf(isnumber), isnumber),
            "The NeedToChangeFrom must be either an existing team or a table of existing teams",
            {"Is there a job here that doesn't exist (anymore)?"}
        ),

    modelScale =
        tc.assert(
            tc.optional(isnumber),
            "The modelScale must be a number."
        ),

    maxpocket =
        tc.assert(
            tc.optional(isnumber),
            "The maxPocket must be a number."
        ),

    maps =
        tc.assert(
            tc.optional(tc.tableOf(isstring)),
            "The maps value must be a table of valid map names."
        ),

    candemote =
        tc.assert(
            tc.optional(isbool),
            "The candemote value must be either true or false."
        ),

    mayor =
        tc.assert(
            tc.optional(isbool),
            "The mayor value must be either true or false."
        ),

    chief =
        tc.assert(
            tc.optional(isbool),
            "The chief value must be either true or false."
        ),

    medic =
        tc.assert(
            tc.optional(isbool),
            "The medic value must be either true or false."
        ),

    cook =
        tc.assert(
            tc.optional(isbool),
            "The cook value must be either true or false."
        ),

    hobo =
        tc.assert(
            tc.optional(isbool),
            "The hobo value must be either true or false."
        ),

    playerClass =
        tc.assert(
            tc.optional(isstring),
            "The playerClass must be a valid string."
        ),

    CanPlayerSuicide =
        tc.assert(
            tc.optional(isfunction),
            "The CanPlayerSuicide must be a function."
        ),

    PlayerCanPickupWeapon =
        tc.assert(
            tc.optional(isfunction),
            "The PlayerCanPickupWeapon must be a function."
        ),

    PlayerDeath =
        tc.assert(
            tc.optional(isfunction),
            "The PlayerDeath must be a function."
        ),

    PlayerLoadout =
        tc.assert(
            tc.optional(isfunction),
            "The PlayerLoadout must be a function."
        ),

    PlayerSelectSpawn =
        tc.assert(
            tc.optional(isfunction),
            "The PlayerSelectSpawn must be a function."
        ),

    PlayerSetModel =
        tc.assert(
            tc.optional(isfunction),
            "The PlayerSetModel must be a function."
        ),

    PlayerSpawn =
        tc.assert(
            tc.optional(isfunction),
            "The PlayerSpawn must be a function."
        ),

    PlayerSpawnProp =
        tc.assert(
            tc.optional(isfunction),
            "The PlayerSpawnProp must be a function."
        ),

    RequiresVote =
        tc.assert(
            tc.optional(isfunction),
            "The RequiresVote must be a function."
        ),

    ShowSpare1 =
        tc.assert(
            tc.optional(isfunction),
            "The ShowSpare1 must be a function."
        ),

    ShowSpare2 =
        tc.assert(
            tc.optional(isfunction),
            "The ShowSpare2 must be a function."
        ),

    canStartVote =
        tc.assert(
            tc.optional(isfunction),
            "The canStartVote must be a function."
        ),

    canStartVoteReason =
        tc.assert(
            tc.optional(isstring, isfunction),
            "The canStartVoteReason must be either a string or a function."
        ),
}}

--[[
Validate shipments
]]
DarkRP.validateShipment = fn.FAnd{BuyableSchema, tc.assertTable{
    entity =
        tc.assert(
            isstring, "The entity of the shipment must be a string."
        ),

    amount =
        tc.assert(
            fn.FAnd{isnumber, fp{fn.Lte, 0}}, "The amount must be a number greater than zero."
        ),

    separate =
        tc.assert(
            tc.optional(isbool), "the separate field must be either true or false."
        ),

    pricesep =
        tc.assert(
            function(v, tbl) return not tbl.separate or isnumber(v) and v >= 0 end,
            "The pricesep must be a number greater than or equal to zero."
        ),

    noship =
        tc.assert(
            tc.optional(isbool),
            "The noship must be either true or false."
        ),

    shipmodel =
        tc.assert(
            tc.optional(isstring),
            "The shipmodel must be a valid model."
        ),

    weight =
        tc.assert(
            tc.optional(isnumber),
            "The weight must be a number."
        ),

    spareammo =
        tc.assert(
            tc.optional(isnumber),
            "The spareammo must be a number."
        ),

    clip1 =
        tc.assert(
            tc.optional(isnumber),
            "The clip1 must be a number."
        ),

    clip2 =
        tc.assert(
            tc.optional(isnumber),
            "The clip2 must be a number."
        ),

    shipmentClass =
        tc.assert(
            tc.optional(isstring),
            "The shipmentClass must be a string."
        ),

    onBought =
        tc.assert(
            tc.optional(isfunction),
            "The onBought must be a function."
        ),

}}

--[[
Validate vehicles
]]
DarkRP.validateVehicle = fn.FAnd{BuyableSchema, tc.assertTable{
    name =
        tc.assert(
            isstring,
            "The name of the vehicle must be a string."
        ),

    distance =
        tc.assert(
            tc.optional(isnumber),
            "The distance must be a number."
        ),

    angle =
        tc.assert(
            tc.optional(isangle),
            "The distance must be a valid Angle."
        ),
}}

--[[
Validate Entities
]]
DarkRP.validateEntity = fn.FAnd{BuyableSchema, tc.assertTable{
    ent =
        tc.assert(
            isstring,
            "The name of the entity must be a string."
        ),

    max =
        tc.assert(
            function(v, tbl) return isnumber(v) or isfunction(tbl.getMax) end,
            "The max must be an existing number or (for advanced users) the getMax field must be a function."
        ),

    cmd =
        tc.assert(
            fn.FAnd{isstring, uniqueEntity},
            "The cmd must be a valid string."
        ),

    name =
        tc.assert(
            isstring,
            "The name must be a valid string."
        ),
}}

--[[
Validate Agendas
]]
DarkRP.validateAgenda = tc.assertTable{
    Title =
        tc.assert(
            isstring,
            "The title must be a string."
        ),

    Manager =
        tc.assert(
            fn.FOr{isnumber, tc.nonEmpty(tc.tableOf(isnumber))},
            "The Manager must either be a single team or a non-empty table of existing teams.",
            {"Is there a job here that doesn't exist (anymore)?"}
        ),

    Listeners =
        tc.assert(
            tc.nonEmpty(tc.tableOf(isnumber)),
            "The Listeners must be a non-empty table of existing teams.",
            {
                "Is there a job here that doesn't exist (anymore)?",
                "Are you trying to have multiple manager jobs in this agenda? In that case you must put the list of manager jobs in curly braces.",
                [[Like so: DarkRP.createAgenda("Some agenda", {TEAM_MANAGER1, TEAM_MANAGER2}, {TEAM_LISTENER1, TEAM_LISTENER2})]]
            }
        )
}

--[[
Validate Categories
]]
DarkRP.validateCategory = tc.assertTable{
    name =
        tc.assert(
            isstring,
            "The name must be a string."
        ),

    categorises =
        tc.assert(
            tc.oneOf{"jobs", "entities", "shipments", "weapons", "vehicles", "ammo"},
            [[The categorises must be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo"]],
            {
                "Mind that this is case sensitive.",
                "Also mind the quotation marks."
            }
        ),

    startExpanded =
        tc.assert(
            isbool,
            "The startExpanded must be either true or false."
        ),

    color =
        tc.assert(
            tc.tableOf(isnumber),
            "The color must be a Color value."
        ),

    canSee =
        tc.assert(
            tc.optional(isfunction),
            "The canSee must be a function."
        ),

    sortOrder =
        tc.assert(
            tc.optional(isnumber),
            "The sortOrder must be a number."
        ),
}