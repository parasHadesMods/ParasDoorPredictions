RNG Manipulations
=================

Cast
----
* One RNG increment occurs when the bloodstone from Zagreus's cast is dropped on the ground. This roll determines the amount
of upward force applied to the bloodstone (ie. how high it will bounce).
* An additional RNG increment is applied when the bloodstone drops on the ground if the cast is Poseidon's cast or if the cast
is from Beowulf shield. This roll determines the amount of horizontal force applied to the bloodstone (ie. how much
horizontal distance it will bounce).
* An additional RNG increment is applied when the bloodstone drops on the ground if the cast is from Beowulf shield. This roll
determines the angle at which the bloodstone will be ejected.

Cast Loading
------------
* One RNG increment occurs when a cast is loaded into Beowulf or Hera. This roll is part of determining if a voice line is
eligible to play.
* An additionanl RNG increment is applied if a voice line actually plays, to select the voice line. This is a 5% chance and
there is a 200s cooldown (see HeroData.LoadingAmmoVoiceLines).

Summon
------
Up to three RNG increments can happen when Zagreus attempts to summon his assist and fail:
* The first roll is part of determining if a voice line is eligible to play, and always occurs immediately.
* The second roll chooses which eligible voice line to play. This one only occurs if a voice line is actually played. There is
a 10 second cooldown on these voice lines; while it's running only one increment (for the first roll) will occur. The second
increment can also be blocked if the voice line can't play for some other reason (eg. Zag is saying something else).
* The third roll is also about determining if a voice line is eligible, and occurs if you have previously (on the same save file)
gotten a voice line from the NPC you are asking to assist because they were already in the room when you pressed the assist button.For example, if you try to summon Meg during the Meg fight while Meg is alive, and Meg says "No way, Zag", then from that point on your save file will give an additional increment when you attempt to summon Meg.

Reload
-------
One RNG increment occurs when you reload any of the Rail weapons. This roll determines if a voice line should play.
* An additional RNG increment is applied if a voice line is actually played, to select the voice line. This is around a 7.5% chance
and has a 300s cooldown (see HeroData.GunReloadingStartVoiceLines).

Codex
-----
When boon description pages are displayed in the codex, a fixed number of RNG increments occur depending on the god and page.

| God       | Page 1 | Page 2 | Page 3 | Page 4 | Page 5 | Page 6 | Total |
|-----------|--------|--------|--------|--------|--------|--------|-------|
| Zeus      |      4 |      5 |      4 |      8 |      5 |      2 |    28 |
| Poseidon  |     26 |      3 |      0 |      2 |      4 |      4 |    39 |
| Athena    |      4 |      4 |      1 |      3 |      5 |      2 |    19 |
| Aphrodite |      4 |      4 |      0 |      3 |      4 |      2 |    17 |
| Artemis   |      4 |      3 |      2 |      5 |      4 |      1 |    19 |
| Ares      |      4 |      3 |      1 |      3 |      4 |      2 |    17 |
| Dionysus  |      4 |      3 |      3 |      4 |      5 |      3 |    22 |
| Hermes    |      3 |      2 |      4 |      4 |    N/A |    N/A |    13 |
| Demeter   |      4 |      4 |      0 |      4 |      4 |      2 |    18 |

These rolls relate to determining the various properties of the boons (amount of damage, knockback, etc).

Well Shop
---------
Opening or re-opening a well shop sets the RNG offset to 12.

Reroll
------
One RNG increment occurs when you get a voice line from attempting to reroll using fated persuasion when you have
insufficient rerolls remaining. This voice line is on a 7 second cooldown (see HeroData.CannotRerollVoiceLines).

Purchase Well Item
----------------------
One RNG increment occurs when you get a voice line from purchasing a well item. This voice line is on a 30 second cooldown (see GlobalVoiceLines.PurchasedWellShopItemVoiceLines).

Fail to Purchase Well Item
--------------------------------
One RNG increment occurs when you get a voice line from attempting to purchase a well item which you cannot purchase.
* There is a 10 second cooldown on the voice line for invalid purchases (HeroData.CannotPurchaseVoiceLines).
* There is a 6 second cooldown on the voice line for purchases you can't afford (HeroData.NotEnoughCurrencyVoiceLines).

Pots
----
* One RNG increment occurs when Zagreus breaks a pot. This roll determines whether the pot will drop money (0% chance for normal pot,100% chance for gold pot).
* Additional RNG increments due to voice lines occur when you break pots in shops or Sisyphus' room (see GlobalVoiceLines.BreakableDestroyedVoiceLines).
* Additional RNG increments due to voice lines occur when you break gold pots (see GlobalVoiceLines.BreakableHighValueDestroyedVoiceLines).
