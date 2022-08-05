# AdversarialAutonomy
Planning in an adversarial environment using the CLIPS programming language and PDDL.

### Description: 
This program defines rules for a robot to navigate the Wumpus World and
receive a reward. The Wumpus World is a toy problem commonly referred to in all editions
of "Artificial Intelligence: A Modern Approach" by Stuart Russell and Peter Norvig where
"Wumpuses" are adversarial agents acting against some other agent seeking a reward. This
program was built using the CLIPS programming language.

PDDL (Planning Domain Definition Language) defines a notation used to establish common
conventions for AI planners. My interest in planners largely comes from my interest in RL
as well as their use in robotic navigation and multiagent autonomy. While this CLIPS
program does not resemble a PDDL planner in its exact form, maintaining parity with PDDL
principles was the goal.

The goal of this program is purely investigational and is not intended to establish any
sort of claims on its validity in performing "state-of-the-art" planning work.

_____________________________________________________________________________________________

### To Run
 * set the path such that the directory points to the one where this file is located
 * run the following commands:
    (load "WumpusWorld_KFrance.clp")
    (reset)
    (run)


_____________________________________________________________________________________________

### The Wumpus World

 R = Robot
 W = Wumpus
 G = Goal

     ---------------------
    |  R   *   *   *   *  |
    |                     |
    |  *   *   *   *   *  |
    |                     |
    |  *   *   *   *   *  |
    |                     |
    |  *   *   *   *   *  |
    |                     |
    |  *   W   *   W   G  |
     ---------------------


_____________________________________________________________________________________________

### Behavior and Incentives
Robot goals: collect coins (the reward) before the Wumpuses do OR get to the goal at the
  opposite end of the map. Avoid being eaten by Wumpuses.

 Wumpus (adversary) goal: try to eat the robot (the primary reward) and stop it from moving
  to the goal position (G), collecting coins (the secondary reward) along the way.

_____________________________________________________________________________________________

 Note: There are some commented out actions below. They are left in for a reason.
 Uncomment those actions to see the importance of salience in creating a successful
 planner. The planner gives some very erratic results when those code blocks are included
 because my saliences are improperly configured. I left the error in because it is a good
 indication of the importance of establishing rule-action priority and a mediation strategy
 within a plannner. The robot arrives at the goal (beating the Wumpuses) with a probability
 of only around 10%. There is definite room for optimization and some opportunity to
 incorporate a mediation algorithm such as MEDIATOR from Kolodner and Simpson (1989). Again,
 there is definite room to optimize the salience.

_____________________________________________________________________________________________
