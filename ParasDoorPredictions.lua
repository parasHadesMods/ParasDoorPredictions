--[[
Show what's in the next room, by predicting its seed
based on the current seed and RNG offset.

Features that are useful for routing are prioritized.

Currently shows:
- Room rewards, including Boon options.
- Charon's shop offerings, if the next room is a shop.
- Well shop contents.
- Enemy types and wave count.
- The room's exits, including:
  - Reward type in the subsequent room.
  - Number of exits to the subsequent room.
  - Whether a well shop is in the subsequent room.

Requires Museus7's RngDisplayMod.

]]
ModUtil.RegisterMod("ParasDoorPredictions")

local config = {
  Control = "Gift",
  ShowRewardType = true,
  ShowChaosGates = true,
  ShowErebusGates = true,
  ShowFountains = true,
  ShowPossibleSurvival = true,
  ShowWellShops = true,
  ShowStoreOptions = true,
  ShowUpgradeOptions = true,
  ShowRerolls = true,
  ShowExits = true,
  ShowEncounters = true,
  ShowEnemies = true,
  ShowRoomNames = false
}

ParasDoorPredictions.Config = config
ParasDoorPredictions.Doors = {}
ParasDoorPredictions.Dirty = false
ParasDoorPredictions.Enabled = false
ParasDoorPredictions.LastUpdateRngUses = -1

-- hooks to add / enable / clear the annotations on door
function ParasDoorPredictions.AddDoor(door)
  local annotation = CreateAnnotation(door.ObjectId)
  ParasDoorPredictions.Doors[door.ObjectId] = { Door = door, Annotation = annotation }
  ParasDoorPredictions.Dirty = true
end

function ParasDoorPredictions.Clear()
  ParasDoorPredictions.Doors = {}
  ParasDoorPredictions.Dirty = false
  ParasDoorPredictions.Enabled = false
  ParasDoorPredictions.LastUpdateRngUses = -1
end

function ParasDoorPredictions.Enable()
  ParasDoorPredictions.Enabled = true
end

ModUtil.WrapBaseFunction("AssignRoomToExitDoor", function(baseFunc, door, room)
  baseFunc(door, room)
  ParasDoorPredictions.AddDoor(door)
end, ParasDoorPredictions)

ModUtil.WrapBaseFunction("DoUnlockRoomExits", function(baseFunc, run, room)
  ParasDoorPredictions.Enable()
  baseFunc(run, room)
end, ParasDoorPredictions)

ModUtil.WrapBaseFunction("RandomSetNextInitSeed", function(baseFunc, args)
  ParasDoorPredictions.Clear()
  baseFunc(args)
  if RngDisplayMod then
    print("RandomSetNextInitSeed:", RngDisplayMod.CurrentUses, NextSeeds[1])
  end
end, ParasDoorPredictions)

-- For prediction, we often want to run a function "as if" a global table (eg. CurrentRun) is modified in a certain way.
-- Copy the relevant functions and modify their environment so these can be overridden.

function CloneFunction(func, wrapper)
  local newEnv = {}
  setmetatable(newEnv, {__index = _G})
  local newFunc = load(string.dump(func), nil, "b", newEnv)
  return wrapper(newEnv, newFunc)
end

ParasDoorPredictions.CreateRoom = CloneFunction(CreateRoom, function(env, func)
  return function(run, roomData, args)
    env.CurrentRun = run
    return func(roomData, args)
  end
end)

ParasDoorPredictions.ChooseRoomReward = CloneFunction(ChooseRoomReward, function(env, func)
  return function(run, room, rewardStoreName, previouslyChosenRewards, args)
    env.CurrentRun = run
    env.ChooseRoomReward = ParasDoorPredictions.ChooseRoomReward
    return func(run, room, rewardStoreName, previouslyChosenRewards, args)
  end
end)

ParasDoorPredictions.UpdateRunHistoryCache = CloneFunction(UpdateRunHistoryCache, function(env, func)
  return function(run, roomAdded)
    env.GameState = { RoomCountCache = {} }
    return func(run, roomAdded)
  end
end)

ParasDoorPredictions.GetRarityChances = CloneFunction(GetRarityChances, function(env, func)
  return function(run, args)
    env.CurrentRun = run
    return func(args)
  end
end)

ParasDoorPredictions.IsVoiceLineEligible = CloneFunction(IsVoiceLineEligible, function(env, func)
  env.CheckCooldown = CheckCooldownNoTrigger
  return func
end)

-- data
ParasDoorPredictions.OverrideExitCount = {
  RoomSecret01 = 2,
  RoomSecret02 = 3,
  RoomSecret03 = 1
}

ParasDoorPredictions.SecretPointCount = {
  RoomSimple01 = 1,
  A_Combat01 = 3,
  A_Combat02 = 2,
  A_Combat03 = 2,
  A_Combat04 = 3,
  A_Combat05 = 3,
  A_Combat06 = 3,
  A_Combat07 = 2,
  A_Combat08A = 2,
  A_Combat08B = 3,
  A_Combat09 = 2,
  A_Combat10 = 3,
  A_Combat11 = 4,
  A_Combat12 = 3,
  A_Combat13 = 2,
  A_Combat14 = 2,
  A_Combat15 = 4,
  A_Combat16 = 2,
  A_Combat17 = 4,
  A_Combat18 = 4,
  A_Combat19 = 3,
  A_Combat20 = 3,
  A_Combat21 = 2,
  A_Combat24 = 3,
  A_MiniBoss01 = 1,
  A_MiniBoss03 = 2,
  A_MiniBoss04 = 2,
  B_Intro = 1,
  B_Combat01 = 1,
  B_Combat02 = 4,
  B_Combat03 = 2,
  B_Combat04 = 2,
  B_Combat05 = 1,
  B_Combat06 = 6,
  B_Combat07 = 2,
  B_Combat08 = 2,
  B_Combat09 = 2,
  B_Combat10 = 1,
  B_Combat21 = 4,
  B_Combat22 = 2,
  B_MiniBoss01 = 1,
  B_MiniBoss02 = 2,
  C_Intro = 2,
  C_Combat01 = 3,
  C_Combat02 = 2,
  C_Combat03 = 3,
  C_Combat04 = 3,
  C_Combat05 = 3,
  C_Combat06 = 3,
  C_Combat08 = 4,
  C_Combat09 = 4,
  C_Combat10 = 2,
  C_Combat11 = 4,
  C_Combat12 = 3,
  C_Combat13 = 2,
  C_Combat14 = 1,
  C_MiniBoss02 = 3,
}


ParasDoorPredictions.RarityColorMap = {
  Common = Color.BoonPatchCommon,
  Rare = Color.BoonPatchRare,
  Epic = Color.BoonPatchEpic,
  Heroic = Color.BoonPatchHeroic,
  Legendary = Color.BoonPatchLegendary
}

ParasDoorPredictions.FriendlyNameMap = {
  GemDropRunProgress = "Gems",
  LockKeyDropRunProgress = "Key",
  RoomRewardMetaPointDropRunProgress = "Darkness",
  GiftDropRunProgress = "Nectar",
  StackUpgrade = "Pom of Power",
  StackUpgradeDrop = "Pom of Power",
  RoomRewardMaxHealthDrop = "Centaur Heart",
  RoomRewardHealDrop = "Food",
  RoomRewardMoneyDrop = "Charon's Obols",
  WeaponUpgrade = "Daedalus Hammer",
  AphroditeUpgrade = "Aphrodite",
  AresUpgrade = "Ares",
  ArtemisUpgrade = "Artemis",
  AthenaUpgrade = "Athena",
  DemeterUpgrade = "Demeter",
  DionysusUpgrade = "Dionysus",
  PoseidonUpgrade = "Poseidon",
  ZeusUpgrade = "Zeus",
  Swarmer = "Numbskull",
  SwarmerElite = "Armored Numbskull",
  HeavyMelee = "Thug",
  HeavyMeleeElite = "Armored Thug",
  DisembodiedHand = "Wringer",
  DisembodiedHandElite = "Armored Wringer",
  PunchingBagUnit = "Lout",
  PunchingBagUnitElite = "Armored Lout",
  ThiefMineLayer = "Pest",
  ThiefMineLayerElite = "Armored Pest",
  ThiefImpulseMineLayer = "Bother",
  ThiefImpulseMineLayerElite = "Armored Bother",
  LightRanged = "Witch",
  LightRangedElite = "Armored Witch",
  SpreadShotUnit = "Spreader",
  SpreadShotUnitElite = "Armored Spreader",
  SplitShotUnit = "Splitter",
  SplitShotUnitElite = "Armored Splitter",
  HeavyRanged = "Brimstone",
  HeavyRangedElite = "Armored Brimstone",
  HeavyRangedForked = "SnakeStone",
  HeavyRangedForkedElite = "Armored SnakeStone",
  HealRanged = "Healing Brimstone",
  HealRangedElite = "Armored Healing Brimstone",
  ShieldRanged = "Shield Brimstone",
  ShieldRangedElite = "Armored Shield Brimstone",
  RangedBurrower = "Dracon",
  RangedBurrowerElite = "Armored Dracon",
  Chariot = "Chariot",
  ChariotElite = "Armored Chariot",
  ChariotSuicide = "Flamewheel",
  ChariotSuicideElite = "Armored Flamewheel",
  LightSpawner = "Skullomat",
  LightSpawnerElite = "Armored Skullomat",
  FlurrySpawner = "Soul Catcher",
  FlurrySpawnerElite = "Armored Soul Catcher",
  BloodlessNaked = "Bloodless",
  BloodlessNakedElite = "Armored Bloodless",
  BloodlessNakedBerserker = "Bone-Raker",
  BloodlessNakedBerserkerElite = "Armored Bone-Raker",
  BloodlessWaveFist = "Wave-Maker",
  BloodlessWaveFistElite = "Armored Wave-Maker",
  BloodlessSelfDestruct = "Slam-Dancer",
  BloodlessSelfDestructElite = "Armored Slam-Dancer",
  BloodlessPitcher = "Burn-Flinger",
  BloodlessPitcherElite = "Armored Burn-Flinger",
  BloodlessGrenadier = "Inferno-Bomber",
  BloodlessGrenadierElite = "Armored Inferno-Bomber",
  CrusherUnit = "Skull Crusher",
  CrusherUnitElite = "Armored Skull Crusher",
  FreezeShotUnit = "Gorgon",
  FreezeShotUnitElite = "Armored Gorgon",
  ShadeNaked = "Eyeball",
  ShadeBowUnit = "Strongbow",
  ShadeBowUnitElite = "Armored Strongbow",
  ShadeSpearUnit = "Longspear",
  ShadeSpearUnitElite = "Armored Longspear",
  ShadeShieldUnit = "Greatshield",
  ShadeShieldUnitElite = "Armored Greatshield",
  ShadeSwordUnit = "Brightsword",
  ShadeSwordUnitElite = "Armored Brightsword",
  SatyrRanged = "Satyr",
  SatyrRangedElite = "Armored Satyr",
  Crawler = "Crawler",
  CrawlerElite = "Armored Crawler",
  CrawlerMiniboss = "Tiny Vermin",
  RatThug = "Gigantic Vermin",
  RatThugElite = "Armored Gigantic Vermin"
}

function ToFriendlyName(name)
  return ParasDoorPredictions.FriendlyNameMap[name] or name
end

TmpPlayedRandomLines = nil
-- like PlayVoiceLines, but assumes neverQueue = true
-- and args = nil, which is how it's called in LeaveRoomAudio
function SimulateVoiceLines(run, voiceLines)
  if voiceLines == nil then
    print("SimulateVoiceLines: voiceLines == nil")
    return
  end
  local source = GetLineSource(voiceLines)
  if source == nil then
    print("SimulateVoiceLines: source == nil")
  end
  if not ParasDoorPredictions.IsVoiceLineEligible(run, voiceLines, nil, nil, source, nil) then
    print("SimulateVoiceLines: Ineligible")
    if voiceLines.PlayedNothingFunctionName ~= nil then
      print("==== BEGIN KNOWN ISSUE ====")
      print("voiceLines.PlayedNothingFunctionName", voiceLines.PlayedNothingFunctionName)
      print("==== END KNOWN ISSUE ====")
    end
    return
  end
  if source.PlayingVoiceLines then
    if voiceLines.Queue == "Interrupt" then
      print("INTERRUPT!")
    else
      return -- assuming neverQueue
    end
  end
  source.PlayingVoiceLines = true
  -- PlayVoiceLine, including sublines
  TmpPlayedRandomLines = DeepCopyTable(PlayedRandomLines)
  SimulateVoiceLine(run, voiceLines, source)
  source.PlayingVoiceLines = false
end

function SimulateVoiceLine(run, line, source)
  source = GetLineSource(line, source)
  if source == nil then
    return
  end
  if line.Cue ~= nil then
    -- no effect on rng
    -- assume success
    return true
  end
  if line.RandomRemaining then
    local eligibleUnplayedLines = {}
    local allEligibleLines = {}
    for k, subLine in ipairs(line) do
      if ParasDoorPredictions.IsVoiceLineEligible(run, subLine, nil, line, source) then
        table.insert(allEligibleLines, subLine)
        if not TmpPlayedRandomLines[subLine.Cue] then
          table.insert(eligibleUnplayedLines, subLine)
        end
      end
    end
    if not IsEmpty( allEligibleLines ) then
      local randomLine = nil
      if IsEmpty( eligibleUnplayedLines ) then
        -- turn the record over
        for k, subLine in ipairs(line) do
          TmpPlayedRandomLines[subLine.Cue] = nil
        end
        randomLine = GetRandomValue( allEligibleLines )
      else
        randomLine = GetRandomValue( eligibleUnplayedLines )
      end
      TmpPlayedRandomLines[randomLine.Cue] = true
      if SimulateVoiceLine(run, randomLine, source) then
        return true
      end
    end
  else
    for k, subLine in ipairs( line ) do
      if ParasDoorPredictions.IsVoiceLineEligible(run, subLine, nil, line, source) then
        if SimulateVoiceLine(run, subLine, source) then
          return true
        end
      end
    end
  end
  
  return false
end

function PredictUpgradeOptions(run, lootName)
  RandomSynchronize()
  local lootData = LootData[lootName]
  local loot = DeepCopyTable(lootData)
  loot.RarityChances = ParasDoorPredictions.GetRarityChances(run, loot)
  SetTraitsOnLoot(loot)
  return loot.UpgradeOptions
end

function PredictUpgradeOptionsReroll(run, lootName, previousOptions)
  RandomSynchronize(run.NumRerolls - 1)
  SimulateVoiceLines(run, HeroVoiceLines.UsedRerollPanelVoiceLines)
  local itemNames = {}
  for i, value in pairs(previousOptions) do
    table.insert( itemNames, value.ItemName)
  end
  local lootData = LootData[lootName]
  local loot = DeepCopyTable(lootData)
  loot.RarityChances = ParasDoorPredictions.GetRarityChances(run, loot)
  SetTraitsOnLoot(loot, { ExclusionNames = { GetRandomValue( previousOptions) } })
  return loot.UpgradeOptions
end

function RunWithUpdatedHistory(run)
  local runCopy = DeepCopyTable(run)
  table.insert(runCopy.RoomHistory, runCopy.CurrentRoom)
  ParasDoorPredictions.UpdateRunHistoryCache(runCopy, runCopy.CurrentRoom)
  return runCopy
end

function ExitCountForRoom(room)
  return ParasDoorPredictions.OverrideExitCount[room.Name] or room.NumExits
end

function IsFountainRoom(room)
  return Contains(room.LegalEncounters, "HealthRestore")
end

function IsErebusRoom(room)
  return Contains(room.LegalEncounters, "ShrineChallengeTartarus")
end

function PredictLoot(door)
  predictions = {}
  local tmpRoom = DeepCopyTable(door.Room)
  -- Make a copy of CurrentRun that has the current room
  -- in the room history. This well make the Is*Eligible
  -- functions correctly calculate restrictions  based
  -- on run depth, biome depth, etc.
  local tmpRun = RunWithUpdatedHistory(CurrentRun)

  local secretPointCount = ParasDoorPredictions.SecretPointCount[tmpRoom.Name] or 0
  if secretPointCount > 0 and IsSecretDoorEligible(tmpRun, tmpRoom) then
    predictions.HasChaosGate = true
    secretPointCount = secretPointCount - 1
  end
  local hasShrinePointDoor = secretPointCount > 0 and IsShrinePointDoorEligible(tmpRun, tmpRoom)
  if IsFountainRoom(tmpRoom) then
    predictions.HasFountain = true
  end
  local lootName = nil
  if tmpRoom.ChosenRewardType == "Boon" then
    lootName = tmpRoom.ForceLootName
  elseif tmpRoom.ChosenRewardType == "TrialUpgrade" then
    lootName = "TrialUpgrade"
  elseif tmpRoom.ChosenRewardType == "WeaponUpgrade" then
    lootName = "WeaponUpgrade"
  elseif tmpRoom.ChosenRewardType == "HermesUpgrade" then
    lootName = "HermesUpgrade"
  end

  local rng = GetGlobalRng()
  
  local oldSeed = RngDisplayMod.CurrentSeed
  local oldUses = RngDisplayMod.CurrentUses
  -- Advance the rng to the right position.
  -- 1. If this is a Chaos room, roll as if we had interacted with it,
  --    ie. take damage, display health, etc.
  if tmpRoom.ChosenRewardType == "TrialUpgrade" then
    -- Interactables
    CoinFlip(rng) -- SacrificeHealth
    -- SecretDoorUsedPresentation
    CoinFlip(rng) -- PlayVoiceLine
    CoinFlip(rng) -- DisplayPlayerDamageText
    CoinFlip(rng) -- DisplayPlayerDamageText
  end
 -- 2. Simulate LeaveRoomPresentation, playing voice lines etc.
  local exitFunctionName = CurrentRun.CurrentRoom.ExitFunctionName or door.ExitFunctionName or "LeaveRoomPresentation"
  if exitFunctionName == "AsphodelLeaveRoomPresentation" then
    if CurrentRun.CurrentRoom.ExitVoiceLines ~= nil then
      SimulateVoiceLines(tmpRun, CurrentRun.CurrentRoom.ExitVoiceLines)
    else
      print("GlobalVoiceLines.ExitedAsphodelRoomVoiceLines")
      SimulateVoiceLines(tmpRun, GlobalVoiceLines.ExitedAsphodelRoomVoiceLines)
    end
  end
  if door.ExitVoiceLines ~= nil then
    print("door.ExitVoiceLines")
    SimulateVoiceLines(tmpRun, door.ExitVoiceLines)
  elseif CurrentRun.CurrentRoom.ExitVoiceLines ~= nil then
    print("CurrentRun.CurrentRoom.ExitVoiceLines")
    SimulateVoiceLines(tmpRun, CurrentRun.CurrentRoom.ExitVoiceLines)
  elseif CurrentRun.CurrentRoom.Encounter.ExitVoiceLines ~= nil then
    print("CurrentRun.CurrentRoom.Encounter.ExitVoiceLines")
    SimulateVoiceLines(tmpRun, CurrentRun.CurrentRoom.Encounter.ExitVoiceLines)
  else
    if RandomChance(0.17) then
      if GlobalVoiceLines.GeneralExitVoiceLines ~= nil then
        print("GlobalVoiceLines.GeneralExitVoiceLines")
        SimulateVoiceLines(tmpRun, GlobalVoiceLines.GeneralExitVoiceLines)
      end
      if CurrentRun.Hero.Health <= 50 then
        if GlobalVoiceLines.HealthStatusPostExitVoiceLines ~= nil then
          print("GlobalVoiceLines.HealthStatusPostExitVoiceLines")
          SimulateVoiceLines(tmpRun, GlobalVoiceLines.GeneralExitVoiceLines)
        end
      end
    end
  end
  -- 3. LeaveRoom, determining the orientation and encounter for the next
  --    room, and also rolling the chaos well if any.
  -- ExitDirection is set in LeaveRoomPresentation
  local heroExitIds = GetIdsByType({ Name = "HeroExit" })
  local hasExitDirection = (exitFunctionName == "LeaveRoomPresentation" and not IsEmpty(heroExitIds)) or exitFunctionName == "AsphodelLeaveRoomPresentation"
  if hasExitDirection and tmpRoom.EntranceDirection ~= nil and tmpRoom.EntranceDirection ~= "LeftRight" then
    -- room orientation is forced
  else
    CoinFlip(rng) -- flip room randomly
  end
  -- generate encounter, if necessary
  if tmpRoom.Encounter == nil then
    local tmpRun = DeepCopyTable(CurrentRun)
    tmpRoom.Encounter = ChooseEncounter(tmpRun, tmpRoom)
  else
    print("Already have encounter", tmpRoom.Encounter.Name)
  end
  predictions.Encounter = tmpRoom.Encounter
  -- RunShopGeneration
  -- generate shop, if necessary
  local hasWellShop = false
  if IsWellShopEligible(tmpRun, tmpRoom) then
    hasWellShop = true
    tmpRun.LastWellShopDepth = currentRun.RunDepthCache
    tmpRoom.Store = FillInShopOptions({ StoreData = StoreData.RoomShop, RoomName = tmpRoom.Name })
    predictions.StoreOptions = tmpRoom.Store.StoreOptions
  end
  if predictions.HasFountain then
    -- We run shop generation anyways to ensure that the rng is advanced correctly before seeding the next room. But if it's a fountain, the shop won't actually be present, so don't return any contents.
    -- TODO: Check if non-tartarus fountain rooms can have well shops
    hasWellShop = false
    predictions.StoreOptions = nil
  end
  if tmpRoom.ChosenRewardType == "Shop" then
    hasWellShop = false
    tmpRoom.Store = FillInShopOptions({ StoreData = StoreData.WorldShop, RoomName = tmpRoom.Name })
    predictions.StoreOptions = tmpRoom.Store.StoreOptions
  end
  -- Determine the seed of the next room, which we will use for predicting
  -- what will occur there.
  local uses = RngDisplayMod.CurrentUses
  local seed = RandomInt(-2147483647, 2147483646)
  print("PredictLoot: as if", uses, seed)

  -- Predict boon or chaos reward
  NextSeeds[1] = seed
  tmpRun.CurrentRoom = tmpRoom
  if lootName ~= nil then
    predictions["UpgradeOptions"] = PredictUpgradeOptions(tmpRun, lootName) -- calls RandomSynchronize
  end
  if predictions.StoreOptions ~= nil then
    for k, item in pairs(predictions.StoreOptions) do
      if item.Args == nil then
        item.Args = {}
      end
      if item.Name == "HermesUpgradeDrop" then
        item.Args["ForceLootName"] = "HermesUpgrade"
      end
      if item.Name == "BlindBoxLoot" then
        -- ChooseLoot
        local eligibleLootNames = GetEligibleLootNames()
        RandomSynchronize()
        item.Args["ForceLootName"] = GetRandomValue(eligibleLootNames)
      end
    
      if item.Args.ForceLootName ~= nil then
        item.Args["UpgradeOptions"] = PredictUpgradeOptions(tmpRun, item.Args.ForceLootName) -- calls RandomSynchronize()
      end
    end
  end
  -- StartRoom()
  local runForWellPrediction = RunWithUpdatedHistory(tmpRun)
  local exitRooms = {}
  -- Predict if the room's exit doors will be blue or gold leaf.
  local rewardStoreName = ChooseNextRewardStore(tmpRun) -- calls RandomSynchronize
  -- DoUnlockRoomExits()
  if hasShrinePointDoor then
    RandomSynchronize(13)
    if predictions.HasChaosGate then
      -- simulate generating the chaos room, see HandleSecretSpawns
      CoinFlip() -- RemoveRandomValue( secretPointIds )
      ChooseNextRoomData(tmpRun, {RoomDataSet = RoomSetData.Secrets}) -- ignore result, called for rng side effects
    end
    local shrinePointRoomOptions = tmpRoom.ShrinePointRoomOptions or RoomSetData.Base.BaseRoom.ShrinePointRoomOptions
    local shrinePointRoomName = GetRandomValue(shrinePointRoomOptions)
    local shrinePointRoomData = RoomSetData.Base[shrinePointRoomName]
    if shrinePointRoomData ~= nil then
      local shrinePointRoom = ParasDoorPredictions.CreateRoom(tmpRun, shrinePointRoomData, { SkipChooseReward = true })
      shrinePointRoom.NeedsReward = true
      table.insert(exitRooms, shrinePointRoom)
    end
  end
  RandomSynchronize()
  local exitCount = ExitCountForRoom(tmpRoom)
  for i=1,exitCount do
    local roomData = ChooseNextRoomData(tmpRun)
    local exitRoom = ParasDoorPredictions.CreateRoom(tmpRun, roomData, { SkipChooseReward = true, SkipChooseEncounter = true})
    table.insert(exitRooms, exitRoom)
  end
  for i, exitRoom in pairs(exitRooms) do
    if exitRoom.ForcedRewardStore ~= nil then
      -- if any room is forced to give eg. a gold leaf,
      -- then all of them will.
      rewardStoreName = exitRoom.ForcedRewardStore
    end
  end
  local rewardsChosen = {}
  for i, exitRoom in pairs(exitRooms) do
    local exitCanHaveSurvival = Contains(exitRoom.LegalEncounters, "SurvivalTartarus") and IsEncounterEligible(runForWellPrediction, exitRoom, EncounterData.SurvivalTartarus)
    local exitIsFountain = IsFountainRoom(exitRoom)
    local exitIsErebus = IsErebusRoom(exitRoom)
    local exitRoomExitCount = ExitCountForRoom(exitRoom)
    exitRoom.ChosenRewardType = ParasDoorPredictions.ChooseRoomReward(tmpRun, exitRoom, rewardStoreName, rewardsChosen) -- calls RandomSynchronize(4)
    local exitHasWellShop = IsWellShopEligible(runForWellPrediction, exitRoom) and exitRoom.ChosenRewardType ~= "Shop" and not exitIsFountain -- TODO: check if non-Tartarus fountain rooms can have shops
    local exitSecretPointCount = ParasDoorPredictions.SecretPointCount[exitRoom.Name] or 0
    local exitHasChaosGate = exitSecretPointCount > 0 and IsSecretDoorEligible(runForWellPrediction, exitRoom)
    if exitHasChaosGate then
      exitSecretPointCount = exitSecretPointCount - 1
    end
    local exitHasShrinePointDoor = exitSecretPointCount > 0 and IsShrinePointDoorEligible(runForWellPrediction, exitRoom)
    if exitRoom.ChosenRewardType ~= "Devotion" then -- don't care about trials, we won't take them anyways
      SetupRoomReward(tmpRun, exitRoom, rewardsChosen)
    end
    table.insert( rewardsChosen, {
      RewardType = exitRoom.ChosenRewardType,
      ForceLootName = exitRoom.ForceLootName,
      WellShop = exitHasWellShop,
      ExitCount = exitRoomExitCount,
      Fountain = exitIsFountain,
      ShrinePointDoor = exitHasShrinePointDoor,
      ChaosGate = exitHasChaosGate,
      Erebus = exitIsErebus,
      CanHaveSurvival = exitCanHaveSurvival,
      RoomName = exitRoom.Name
    })
  end
  predictions.NextExitRewards = rewardsChosen

  -- Rerolls
  if predictions.UpgradeOptions and lootName ~= "WeaponUpgrade" then
    predictions.UpgradeOptionsReroll = PredictUpgradeOptionsReroll(tmpRun, lootName, predictions.UpgradeOptions)
  end
  if false then
    -- well shop rerolls are heavily manipulable, not useful to show them
    RandomSynchronize(tmpRun.NumRerolls - 1)
    SimulateVoiceLines(tmpRun, HeroVoiceLines.UsedRerollPanelVoiceLines)
    local randomExclusion = { GetRandomValue(tmpRoom.Store.StoreOptions).Name }
    local rerollStore = FillInShopOptions({ StoreData = StoreData.RoomShop, RoomName = tmpRoom.Name, ExclusionNames = randomExclusion })
    predictions.StoreOptionsReroll = rerollStore.StoreOptions
  end
  -- Reset the RNG to the current value.
  NextSeeds[1] = oldSeed
  RandomSynchronize(oldUses)

  return predictions
end

function CreateAnnotation(objectId)
  local annotation = {}
  annotation.ObjectId = objectId
  annotation.NextLineNumber = 0
  annotation.Anchors = {}
  return annotation
end

function AddLine(annotation, text, color)
  color = color or Color.White
  local yOffset = annotation.NextLineNumber * 12

  local id = SpawnObstacle({
    Name = "BlankObstacleNoTimeModifier",
    DestinationId = annotation.ObjectId,
    Group = "Overlay",
    OffsetX = 0, OffsetY = yOffset })
  CreateTextBox({
    Id = id,
    Text = text,
    OffsetX = 0, OffsetY = yOffset,
    Font = "AlegreyaSansSCBold",
    FontSize = 18,
    Color = color,
    Justification = "Center"})

  annotation.NextLineNumber = annotation.NextLineNumber + 1
  annotation.Anchors[annotation.NextLineNumber] = id
end

function ResetAnnotation(annotation)
  for index,id in pairs(annotation.Anchors) do
    Destroy({Ids = {id}})
  end
  annotation.Anchors = {}
  annotation.NextLineNumber = 0
end

function ShowStoreOptions(annotation, storeOptions)
  if config.ShowStoreOptions and storeOptions ~= nil then
    for i, item in pairs(storeOptions) do
      if item.Args ~= nil and item.Args.ForceLootName ~= nil then
        AddLine(annotation, item.Name .. " " .. item.Args.ForceLootName)
        for id, choice in pairs(item.Args.UpgradeOptions) do
          local color = ParasDoorPredictions.RarityColorMap[choice.Rarity]
          AddLine(annotation, choice.ItemName, color)
        end
      else
        AddLine(annotation, item.Name)
      end
    end
  end
end

function ShowUpgradeOptions(annotation, upgradeOptions)
  if upgradeOptions ~= nil then
    for id, choice in pairs(upgradeOptions) do
      local upgradeOptionString = ToFriendlyName(choice.ItemName)
      if choice.SecondaryItemName ~= nil then
        upgradeOptionString = upgradeOptionString .. " with " .. ToFriendlyName(choice.SecondaryItemName)
      end
      local color = ParasDoorPredictions.RarityColorMap[choice.Rarity]
      AddLine(annotation, upgradeOptionString, color)
    end
  end
end

function ShowEncounter(annotation, encounter)
  if not config.ShowEncounters then
     return
  end

  if Contains(EncounterSets.ThanatosEncounters, encounter.Name) then
    AddLine(annotation, "Thanatos")
  end
  if encounter.Name == "SurvivalTartarus" then
    AddLine(annotation, "Survival")
  end
  if config.ShowEnemies and encounter.SpawnWaves ~= nil then
    for i, wave in pairs(encounter.SpawnWaves) do
      local waveString = ""
      for j, spawn in pairs(wave.Spawns) do 
        if waveString ~= "" then
          waveString = waveString .. ", "
        end
        waveString = waveString .. ToFriendlyName(spawn.Name)
      end
      AddLine(annotation, waveString)
    end
  end
end

-- reward can be a room
function RewardTypeString(rewardType, forceLootName)
  local rewardString = ToFriendlyName(rewardType)
  if forceLootName ~= nil then
    rewardString = rewardString .. " of " .. ToFriendlyName(forceLootName)
  end
  return rewardString
end

function ShowExits(annotation, nextExitRewards)
  if not config.ShowExits then 
    return
  end

  for k, reward in pairs(predictions.NextExitRewards) do
    local rewardString = ""
    if config.ShowRoomNames then
      rewardString = rewardString .. reward.RoomName .. " "
    end
    if config.ShowRewardType and reward.RewardType ~= nil then
       rewardString = rewardString .. RewardTypeString(reward.RewardType, reward.ForceLootName)
    end
    if config.ShowFountains and reward.Fountain then
       rewardString = rewardString .. " with Fountain"
    end
    if config.ShowWellShops and reward.WellShop then
      rewardString = rewardString .. " with Well Shop"
    end
    if config.ShowChaosGates and reward.ChaosGate then
      rewardString = rewardString .. " with Chaos Gate"
    end
    if config.ShowErebusGates and reward.ShrinePointDoor then
      rewardString = rewardString .. " with Erebus Gate"
    end
    if reward.Erebus then
      rewardString = rewardString .. " through Erebus Gate"
    end
    if config.ShowPossibleSurvival and reward.CanHaveSurvival then
      rewardString = rewardString .. " with possible survival"
    end
    rewardString = rewardString .. " (" .. reward.ExitCount .. " Exits)"
    AddLine(annotation, rewardString)
  end
end

function ShowDoorPreview(annotation, door)
  if config.ShowRoomNames then
    AddLine(annotation, door.Room.Name)
  end
  if config.ShowRewardType and door.Room.ChosenRewardType ~= nil then
    AddLine(annotation, RewardTypeString(door.Room.ChosenRewardType, door.Room.ForceLootName))
  end
  local predictions = PredictLoot(door)
  if config.ShowStoreOptions and predictions.StoreOptions ~= nil then
    ShowStoreOptions(annotation, predictions.StoreOptions)
    if config.ShowRerolls and predictions.StoreOptionsReroll ~= nil then
      AddLine(annotation, "Reroll")
      ShowStoreOptions(annotation, predictions.StoreOptionsReroll)
    end
  end
  if config.ShowFountains and predictions.HasFountain then
    AddLine(annotation, "Fountain")
  end
  if config.ShowChaosGates and predictions.HasChaosGate then
    AddLine(annotation, "Chaos Gate")
  end
  if config.ShowUpgradeOptions and predictions.UpgradeOptions ~= nil then
    ShowUpgradeOptions(annotation, predictions.UpgradeOptions)
    if config.ShowRerolls and predictions.UpgradeOptionsReroll ~= nil then
      AddLine(annotation, "Reroll")
      ShowUpgradeOptions(annotation, predictions.UpgradeOptionsReroll)
    end
  end
  ShowEncounter(annotation, predictions.Encounter)
  ShowExits(annotation, predictions.NextExitRewards)
end

OnControlPressed { config.Control,
  function (triggerArgs)
    if not RngDisplayMod then
      return ModUtilHades.PrintOverhead("RngDisplayMod not installed.")
    end
    local rngUses = RngDisplayMod.CurrentUses
    if ParasDoorPredictions.Enabled and (ParasDoorPredictions.Dirty or rngUses ~= ParasDoorPredictions.LastUpdateRngUses) then
      ParasDoorPredictions.Dirty = false
      ParasDoorPredictions.LastUpdateRngUses = rngUses

      for doorId, door in pairs(ParasDoorPredictions.Doors) do
        ResetAnnotation(door.Annotation)
        ShowDoorPreview(door.Annotation, door.Door)
      end
    end
  end
}

