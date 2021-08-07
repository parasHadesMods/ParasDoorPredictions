Hades Routing Tutorial
======================

In this tutorial, you will create a Styx route that will allow you to get a 2-sack every time
you load from a given save file. The route will consist of a series of room-by-room notes describing
the actions to perform before exiting the room in order to manipulate the random number generator
into giving you a consistent path.

Setup
-----

1. Install Hades on your Mac or PC, from the Steam or the Epic store.
2. Download the tutorial save file. (link)
3. Find your save folder in the table below:

|Platform | Store | Save Folder |
|---------|-------|-------------|
| PC      | Steam |             |
| PC      | Epic  |             |
| Mac     | Steam |             |
| Mac     | Epic  | ~/Library/Application Support/Supergiant Games/Hades |

4. Place the tutorial save file in the save folder.
5. Download the Routing Modpack. (link)
6. Find your game files folder in the table below:
 
| Platform | Store | Game Files Folder |
|----------|-------|-------------------|
| PC       | Steam |                   |
| PC       | Epic  |                   |
| Mac      | Steam |                   |
| Mac      | Epic  | /Users/Shared/Epic\ Games/Hades/Game.macOS.app/Contents/Resources/Content |

7. Unzip the Routing Modpack into the game files folder.
8. Run modimporter.py to install the mods.
9. Start Hades. Load the game in profile 4. This should put you in the styx introduction room (chamber 38), and there
   should be text in the top-right of the screen that says "RNG Seed: 996914823" and "RNG Uses: 7".

Routing the Styx Rewards
------------------------
1. Get a pencil and paper to take notes.
2. Walk to the exit of the styx introduction room, but do not use it.
3. Press the "Gift" button (default: "g" on the keyboard or "right trigger" on controller).
4. The following text should appear over the exit:
```
D_Hub
... several more lines of text you can ignore
D_Mini13 Charon's Obol (1 Exits)
D_Mini09 Boon of Aphrodite (1 Exits)
D_Mini14 Centaur Heart with MiniBoss (1 Exits)
D_Mini14 Pom of Power (1 Exits)
D_Mini12 Boon of Artemis with MiniBoss (1 Exits)
```
5. Press the "Cast" button (default: "right click" on mouse or "B" on controller), and count "1" out loud.
6. The text in the top right should now say "RNG Uses: 8".
7. Press the Gift button.
8. The text over the exit should change to:
```
D_Hub
...
D_Mini13 Centaur Heart (1 Exits)
D_Mini09 Boon of Artemis with Miniboss (1 Exits)
D_Mini14 (1 Exits)
D_Mini14 Pom of Power (1 Exits)
D_Mini12 Boon of Artemis with MiniBoss (1 Exits)
```
9. Press cast again, counting "2" out load, and then "Gift" to refresh the text.
10. Continue casting, counting, and pressing "Gift" until you are given the following text:
```
D_Hub
...
D_Mini14 Boon of Aphrodite with MiniBoss (1 Exits)
D_Mini05 Centaur Heart (1 Exits)
D_Mini10 Boon of Athena (1 Exits)
D_Mini09 Charon's Obol (1 Exits)
D_Mini14 Pom of Power with MiniBoss (1 Exits)
```
11. Write down the following notes:
  - the chamber number (38)
  - the current value of "RNG Uses:"
  - the number of times you pressed "cast" (ie. the number you reached in your counting)
  - "Pom Miniboss" (the reward we want!)
12. Exit the styx introduction room and proceed into the styx hub by pressing the Interact button
    (default: "e" on keyboard or "right bumper" on controller)
13. The chamber rewards should match your notes.
14. You have successfully routed your first room and manipulated RNG to get the rewards you want!

To test the route:
1. Open the menu (default: "esc" on keyboard or "start" on controller) and select "Give Up".
2. Load the game in profile 4. You should be back at the start of the styx introduction room.
3. Walk to the exit. Cast the number of times as written in your notes. Exit the introduction room.
4. The chamber rewards should match your notes again.
5. You have successfully verified that your route works!

Routing the First Styx Path
---------------------------
1. Follow your route from the previous section to the styx hub. Dash over to the pom miniboss door.
2. Press "Gift" to display the room preview.
3. The preview text on the pom door should have "Gigantic Vermin" as the only enemy.
4. This is an acceptable enemy, so write down the following notes:
 - the chamber number (39)
 - the current value of "RNG Seed: "
 - the current value of "RNG Uses: " (12)
 - the number of times you pressed cast in this room AFTER killing the enemies (0)
 - the room to take (Pom Miniboss)
5. Enter the next room by pressing Interact, then kill the giant rats.
6. Press "Gift" to display the room preview text.
7. The preview text says the next room has a "Bother". This is also an acceptable enemy, so write down your room notes just like in step 4. Also note down the enemy that was in this room (Gigantic Vermin).
8. Enter the next room by pressing Interact, then kill the bothers.
9. Press "Gift" to display the room preview text.
10. The room preview text says the next room has a "Bother", and also that the room after is `D_MiniBoss02`. This is the giant rat miniboss, which is both slow and dangerous, so we will avoid it.
11. Press the Cast button, note that the RNG uses changes, count "1", and press "Gift" to refresh the preview text.
12. Repeat step 11 until the preview text has `D_MiniBoss03`. This is the giant snakestone room, which is better, so we'll take it. Write down your room notes like in step 7.
13. Enter the next room by pressing interact, then kill the enemies.
14. Press Gift to show the reward preview. It says the enemy will be "Dire Snakestone" (so we know it's not the Tiny Vermin). Take notes as in step 7.
15. Enter the miniboss and kill it! You have routed your first styx path.

To test the route:
1. Open the menu (default: "esc" on keyboard or "start" on controller) and select "Give Up".
2. Load the game in profile 4. You should be back at the start of the styx introduction room.
3. For each room in your notes:
 - kill any enemies (notice they're the same as they were the first time through)
 - walk to the exit
 - press cast the number of times the notes say to press cast
 - enter the next room
4. You should get the same enemies in each room as the first time, including the miniboss.

Routing the Second Path
-----------------------
1. Follow your route from the previous section to the miniboss room.
2. Kill the miniboss and select the room reward (pom your cast).
3. Take notes for this room like every other room (seed, uses, # of cast presses, enemy) and exit back to the styx hub.
4. Dash to the Centaur Heart door, and press Gift to see the reward preview. The enemies (Satyr Cultist, Gigantic Vermin) are fine so take notes and enter by pressing Interact.
5. Kill the enemies, press Gift to see the reward preview, notice it's Snakestone which is fine, take notes, and enter the next room.
6. Kill the enemies, press Gift to see the reward preview. We are looking for the bottom line to start with `D_Reprieve01` which is the name of the Satyr Sack room. It does, and the enemies are also good! Take notes, and enter the next room.
7. Kill the enemies, take your notes, then enter the next room. It should be the satyr sack, and you have successfully routed your first styx!

To test the route:
1. Open the menu (default: "esc" on keyboard or "start" on controller) and select "Give Up".
2. Load the game in profile 4. You should be back at the start of the styx introduction room.
3. For each room in your notes:
 - kill any enemies (notice they're the same as they were the first time through)
 - walk to the exit
 - press cast the number of times the notes say to press cast
 - enter the next room
4. You should get the same enemies in each room as the first time, including the miniboss and the two-sack!
