Enemy Spawns
============

Mechanics
=========

1. The game selects which enemy to spawn next (GetNextSpawn)
2. The game selects a spawn point for the next spawn

Both of these are controlled by the lua RNG. No RNG
resets occur as part of this process.

Spawn Points
------------

The spawn points are loaded OnAnyLoad (Combat.lua) as
MapState.SpawnPoints. These values are returned from the
in-engine GetIds function. This function returns the spawn
point ids in an arbitrary order that is not tied to the lua
RNG.
