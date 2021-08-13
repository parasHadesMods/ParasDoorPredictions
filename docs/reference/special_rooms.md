Special Rooms
=============

Fountain, story, and miniboss rooms are only offered (on the exits) once per run.
Rooms marked with F have a chance to be forced as described below. Rooms marked
with Y are not forced, but are eligible. Unmarked rooms are ineligible.

Tartarus
--------

| Chamber Number | Fountain | Bouldy | MidShop | MidBoss | Thanatos | Survival |
|----------------|----------|--------|---------|---------|----------|----------|
|              2 |          |        |         |         |          |          |
|              3 |          |        |         |         |          |          |
|              4 |          |        |         |         |          |          |
|              5 |        Y |        |         |         |          |          |
|              6 |        Y |      Y |       F |         |          |          |
|              7 |        Y |      Y |       F |       F |          |          |
|              8 |        Y |      Y |       F |       F |          |        Y |
|              9 |        Y |      Y |       F |       F |          |        Y |
|             10 |        Y |      Y |       Y |       F |          |        Y |
|             11 |        Y |      Y |       Y |       F |        Y |        Y |
|             12 |        Y |      Y |         |         |        Y |        Y |

Asphodel
--------

| Chamber Number | Fountain | Euridice | MidShop | MidBoss | Thanatos |
|----------------|----------|----------|---------|---------|----------|
|             17 |          |          |         |         |          |
|             18 |          |        Y |         |         |        Y |
|             19 |        Y |        Y |       F |         |        Y |
|             20 |        Y |        Y |       F |       F |        Y |
|             21 |        Y |        Y |       F |       F |        Y |
|             22 |        Y |        Y |         |       F |        Y |

Elysium
-------

| Chamber Number | Fountain | Patroclus | MidShop | MidBoss | Thanatos |
|----------------|----------|-----------|---------|---------|----------|
|             27 |          |           |         |         |          |
|             28 |          |           |         |         |          |
|             29 |        Y |         Y |       F |         |        Y |
|             30 |        Y |         Y |       F |       F |        Y |
|             31 |        Y |         Y |       F |       F |        Y |
|             32 |        Y |         Y |       F |       F |        Y |
|             33 |        Y |         Y |         |       F |        Y |
|             34 |        Y |         Y |         |         |        Y |

MidShop
-------

The MidShop in each biome can only be offered on the exit of 2 or 3 exit rooms.
The MidShop is never offered on the exit of the following rooms:
 - Chaos
 - `B_Combat10` (the S-shaped room in Asphodel)
 - Elysium Fountain
 - Butterfly Ball MiniBoss
 - `C_Combat04`
 - `C_Combat05`

Room Selection
--------------
For each exit, the game:
1. Checks for any rooms that are eligible to be forced (F) at the next room's depth. The chance
   of a room being forced is 1/N, where N is the remaining number of depths at which the room is
   eligible to be forced. For example, Elysium MidBosses have 1/4 chance at depth 30, 1/3 at 31, 1/2 at 32, and 1/1 at 33.
2. Picks one of the forced rooms at random (if any) and offers it.
3. If no rooms are forced (ie. none are eligible or all fail the roll to be forced), finds all rooms that
   are eligible at the next room's depth (including those eligible to be forced).
4. Picks one of the elgible rooms at random and offers it.


