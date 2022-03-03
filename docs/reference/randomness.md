Randomness in Routed
====================

Some things are still random even when you control the RNG seed in every room.

Money
-----
Whether and how much money will drop from an enemy is rolled during combat, without any RNG resets.

Spawn Locations
---------------
Initial enemy spawn locations are rolled with fixed RNG uses every time - they happen before
Zagreus can take any actions to affect RNG. This ensures that same position in the spawn point
list (MapState.SpawnPoints) is used every time (eg. the 4th entry). The spawn points are loaded
into this table in an arbitrary order by GetIds (Combat.lua#3879), so different spawn points will
be in the selected position from run to run.

Subsequent enemy spawn locations are rolled during combat, without any RNG resets. Which spawn points
are eligible also varies depending on Zagreus's position.

Enemies Spawned
---------------
Which enemy will spawn is rolled during combat, without any RNG resets. The enemy set for each room
is fixed for the route.

Enemy AI
--------
Enemy movement and attacks are rolled during combat, without any RNG resets. They also depend
on Zagreus's and the enemy's position.

Gemstones
---------
Gemstone room rewards have an on-pickup voice line. This is rolled before RNG
resets at the end of the room, based on the combat RNG.

Price of Midas
--------------
When a Price of Midas appears in a well, two rolls occur:
 - one to determine the health cost (HealthCost)
 - one to determine the ratio between health cost and money earned (PayoutPerHealthPoint)
These two rolls happen in an arbitrary order, based on the order that these entries appear
in the ConsumableData.DamageSelfDrop table, which varies each time the game is loaded.

The Price of Midas will take one of two possible values based on this order.

Sell Well
---------
Boons appear in an arbitrary order in the sell well.

