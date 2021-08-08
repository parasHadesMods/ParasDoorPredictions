RNG Manipulations
=================

Cast
----
One RNG increment occurs when the bloodstone from Zagreus's cast is dropped on the ground. This roll determines the amount
of upward force applied to the bloodstone (ie. how high it will bounce).
An additional RNG increment is applied when the bloodstone drops on the ground if the cast is Poseidon's cast or if the cast
is from Beowulf shield. This roll determines the amount of horizontal force applied to the bloodstone (ie. how much
horizontal distance it will bounce).
An additional RNG increment is applied when the bloodstone drops on the ground if the cast is from Beowulf shield. This roll
determines the angle at which the bloodstone will be ejected.

Cast Loading
------------
One RNG increment occurs when a cast is loaded into Beowulf or Hera. This roll is part of determining if a voice line is
eligible to play.
An additionanl RNG increment is applied if a voice line actually plays, to select the voice line. This is a 5% chance and
there is a 200s cooldown (see HeroData.LoadingAmmoVoiceLines).

Summon
------
Up to two RNG increments can happen when Zagreus attempts to summon his assist.
The first roll is part of determining if a voice line is eligible to play, and always occurs immediately.
The second roll chooses which eligible voice line to play. This one only occurs if a voice line is actually played. There is
a 10 second cooldown on these voice lines; while it's running only one increment (for the first roll) will occur. The second
increment can also be blocked if the voice line can't play for some other reason (eg. Zag is saying something else).

Codex
-----
When boon description pages are displayed in the codex, a fixed number of RNG increments occur depending on the god and page.

| God       | Page 1 | Page 2 | Page 3 | Page 4 | Page 5 | Page 6 |
|-----------|--------|--------|--------|--------|--------|--------|
| Zeus      |      4 |      5 |      4 |      8 |      5 |      2 |
| Poseidon  |     26 |      3 |      0 |      2 |      4 |      4 |
| Athena    |      4 |      4 |      1 |      3 |      5 |      2 |
| Aphrodite |      4 |      4 |      0 |      3 |      4 |      2 |
| Artemis   |      4 |      3 |      2 |      5 |      4 |      1 |
| Ares      |      4 |      3 |      1 |      3 |      4 |      2 |
| Dionysus  |      4 |      3 |      3 |      4 |      5 |      3 |
| Hermes    |      3 |      2 |      4 |      4 |    N/A |    N/A |
| Demeter   |      4 |      4 |      0 |      4 |      4 |      2 |

These rolls relate to determining the various properties of the boons (amount of damage, knockback, etc).

Well Shop
---------
Opening or re-opening a well shop sets the RNG offset to 12.

Reroll
------
One RNG increment occurs when you get a voice line from attempting to reroll using fated persuasion when you have
insufficient rerolls remaining. This voice line is on a 7 second cooldown (see HeroData.CannotRerollVoiceLines).

Pots
----
One RNG increment occurs when Zagreus breaks a pot. This roll determines whether the pot will drop money (0% chance for normal pot,100% chance for gold pot).
Additional RNG increments due to voice lines occur when you break pots in shops or Sisyphus' room (see GlobalVoiceLines.BreakableDestroyedVoiceLines).
Additional RNG increments due to voice lines occur when you break gold pots (see GlobalVoiceLines.BreakableHighValueDestroyedVoiceLines).
