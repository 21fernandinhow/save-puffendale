# Game Design — Save Puffendale

## Concept

Puffendale is a village cursed by the Witch of Procrastination. Players restore it by completing real-life tasks, converting productivity into magic points.

## Magic Points

| Action | Points |
|---|---|
| Complete a task | +10 |
| Uncomplete a task | -10 |

Magic points never go below 0.

## Village Status

The village status reflects accumulated magic points:

| Status | Threshold |
|---|---|
| Devastated | ≤ 60 points |
| Recovering | 61 – 249 points |
| Healthy | ≥ 250 points |

## Difficulty & Weekly Decay

Every week, magic points decay based on the player's chosen difficulty. This simulates the village falling back under the witch's influence if tasks are neglected.

| Difficulty | Weekly Decay |
|---|---|
| Easy | -5 points |
| Normal | -25 points |
| Hard | -50 points |

Decay is applied by `WeeklyMagicPointsDecayJob`.

## Achievements

20 achievements unlock as magic points accumulate. Milestones run from 10 to 400 points, tracking the player's long-term progress in saving the village.

## Game Modes

Players can change difficulty at any time via the Game Mode selection screen. This adjusts the weekly decay rate going forward.
