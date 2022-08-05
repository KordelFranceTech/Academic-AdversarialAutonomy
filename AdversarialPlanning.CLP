;;; Kordel K. France
;;; Planning Against Adversaries Using CLIPS and PDDL
;;;
;;;
;;;  Description: This program defines rules for a robot to navigate the Wumpus World and
;;;  receive a reward. The Wumpus World is a toy problem commonly referred to in all editions
;;;  of "Artificial Intelligence: A Modern Approach" by Stuart Russell and Peter Norvig where
;;;  "Wumpuses" are adversarial agents acting against some other agent seeking a reward. This
;;;  program was built using the CLIPS programming language.
;;;
;;;  PDDL (Planning Domain Definition Language) defines a notation used to establish common
;;;  conventions for AI planners. My interest in planners largely comes from my interest in RL
;;;  as well as their use in robotic navigation and multiagent autonomy. While this CLIPS
;;;  program does not resemble a PDDL planner in its exact form, maintaining parity with PDDL
;;;  principles was the goal.
;;;
;;;  The goal of this program is purely investigational and is not intended to establish any
;;;  sort of claims on its validity in performing "state-of-the-art" planning work.
;;;
;;;_____________________________________________________________________________________________
;;;
;;; To Run:
;;; * set the path such that the directory points to the one where this file is located
;;; * run the following commands:
;;;    (load "WumpusWorld_KFrance.clp")
;;;    (reset)
;;;    (run)
;;;
;;;
;;;_____________________________________________________________________________________________
;;;
;;; The Wumpus World
;;;
;;; R = Robot
;;; W = Wumpus
;;; G = Goal
;;;
;;;     ------------------------
;;;    |  R   *   *   *   *   * |
;;;    |                        |
;;;    |  *   *   *   *   *   * |
;;;    |                        |
;;;    |  *   *   *   *   *   * |
;;;    |                        |
;;;    |  *   *   *   *   *   * |
;;;    |                        |
;;;    |  *   *   *   *   *   * |
;;;    |                        |
;;;    |  *   W   *   W   *   G |
;;;     ------------------------
;;;
;;;
;;;_____________________________________________________________________________________________
;;;
;;; Robot goals: collect coins (the reward) before the Wumpuses do OR get to the goal at the
;;;  opposite end of the map. Avoid being eaten by Wumpuses.
;;;
;;; Wumpus (adversary) goal: try to eat the robot (the primary reward) and stop it from moving
;;;  to the goal position (G), collecting coins (the secondary reward) along the way.
;;;
;;;_____________________________________________________________________________________________
;;;
;;; Note: There are some commented out actions below. They are left in for a reason.
;;; Uncomment those actions to see the importance of salience in creating a successful
;;; planner. The planner gives some very erratic results when those code blocks are included
;;; because my saliences are improperly configured. I left the error in because it is a good
;;; indication of the importance of establishing rule-action priority and a mediation strategy
;;; within a plannner. The robot arrives at the goal (beating the Wumpuses) with a probability
;;; of only around 10%. There is definite room for optimization and some opportunity to
;;; incorporate a mediation algorithm such as MEDIATOR from Kolodner and Simpson (1989). Again,
;;; there is definite room to optimize the salience.
;;;
;;;_____________________________________________________________________________________________



;; defines where the coins are on the map
(deffacts reward_facts
    (pos_at 1 2 coins 1 )
    (pos_at 1 3 coins 1 )
    (pos_at 2 3 coins 1 )
    (pos_at 2 4 coins 1 )
    (pos_at 3 2 coins 1 )
    (pos_at 3 3 coins 1 )
    (pos_at 4 3 coins 1 )
    (pos_at 4 4 coins 1 )
    (pos_at 5 4 coins 1 )
    (pos_at 5 5 coins 1 )
    (pos_at 6 5 coins 1 )
    (pos_at 6 6 coins 1 )
        
)


;; defines the starting positions for robot and both wumpuses
(deffacts navigation_facts
  (wumpus1_at 6 4)
  (wumpus2_at 6 2)
  (robot_at 1 1)
)


;; initiailize with a random strategy
(defrule init
  (initial-fact)
=>
  (set-strategy Random)
)


;; defines "mission complete"
(defrule goal_achieved
    (declare (salience 100))
    (pos_at 1 2 coins 0 )
    (pos_at 1 3 coins 0 )
    (pos_at 2 3 coins 0 )
    (pos_at 2 4 coins 0 )
    (pos_at 3 2 coins 0 )
    (pos_at 3 3 coins 0 )
    (pos_at 4 3 coins 0 )
    (pos_at 4 4 coins 0 )
    (pos_at 5 4 coins 0 )
    (pos_at 5 5 coins 0 )
    (pos_at 6 5 coins 0 )
    (pos_at 6 6 coins 0 )
    ;; uncomment to make things a little more complex:
    ;; robot must get all coins AND get to final pos
    ; (robot_at 6 6)
=>
  (printout t "no more coins to be collected"  crlf)
  (halt)
)


;; wumpus 1 ate the robot before the coins were picked up
(defrule wumpus1_eats_robot
    (robot_at ?x ?y)
    (wumpus1_at ?x ?y)
=>
    (printout t "robot got eaten by wumpus1 " crlf)
    (halt)
)


;; wumpus 2 ate the robot before the coins were picked up
(defrule wumpus2_eats_robot
    (robot_at ?x ?y)
    (wumpus2_at ?x ?y)
=>
    (printout t "robot got eaten by wumpus2 " crlf)
    (halt)
)


;;;______________________________________________________________________________________________
;; WUMPUS 1 RULES
;;;______________________________________________________________________________________________


;; move wumpus 1 one unit stochastically
(defrule wumpus1_move_stochastic
  ?z <- (wumpus1_at ?x ?y)
=>
  (retract ?z)
  (assert (wumpus1_at (- ?x (random -1 1)) (- ?y (random -1 1))))
)


;; move wumpus1 left one unit
;(defrule wumpus1_move_left
;  ?z <- (wumpus1_at ?x ?y)
;  (pos_at ?x =(- ?y 1) coins ?f  )
;=>
;  (retract ?z)
;  (assert (wumpus1_at ?x (- ?y 1)))
;)

;; move wumpus1 right one unit
;(defrule wumpus1_move_right
;  ?z <- (wumpus1_at ?x ?y)
;  (pos_at ?x =(+ ?y 1) coins ?f  )
;=>
;  (retract ?z)
;  (assert (wumpus1_at ?x (+ ?y 1)))
;)


;; move wumpus1 up one unit
;(defrule wumpus1_move_up
;  ?z <- (wumpus1_at ?x ?y)
;  (pos_at =(- ?x 1) ?y coins ?f )
;=>
;  (retract ?z)
;  (assert (wumpus1_at (- ?x 1) ?y ))
;)


;; move wumpus1 down one unit
;(defrule wumpus1_move_down
;  ?z <- (wumpus1_at ?x ?y)
;  (pos_at =(+ ?x 1) ?y coins ?f  )
;=>
;  (retract ?z)
;  (assert (wumpus1_at (+ ?x 1) ?y ))
;)


;; move wumpus1 diagonally up one unit and left one unit
 ;(defrule wumpus1_move_diagonally_up_left
 ; ?z <- (wumpus1_at ?x ?y)
 ; (pos_at =(- ?x 1) =(- ?y 1) coins ?f  )
;=>
 ; (retract ?z)
 ;(assert (wumpus1_at (- ?x 1) (- ?y 1)))
;)


;; move wumpus1 diagonally down one unit and right one unit
;(defrule wumpus1_move_diagonally_down_right
;  ?z <- (wumpus1_at ?x ?y)
 ; (pos_at =(+ ?x 1) =(+ ?y 1) coins ?f  )
;=>
 ; (retract ?z)
 ; (assert (wumpus1_at (+ ?x 1) (+ ?y 1)))
;)


;; move wumpus1 diagonally up one unit and right one unit
;(defrule wumpus1_move_diagonally_up_right
;  ?z <- (wumpus1_at ?x ?y)
;  (pos_at =(- ?x 1) =(+ ?y 1) coins ?f )
;=>
;  (retract ?z)
;  (assert (wumpus1_at (- ?x 1) (+ ?y 1) ))
;)


;; move wumpus1 diagonally down one unit and left one unit
;(defrule wumpus1_move_diagonally_down_left
;  ?z <- (wumpus1_at ?x ?y)
;  (pos_at =(+ ?x 1) =(+ ?y 1) coins ?f  )
;=>
;  (retract ?z)
;  (assert (wumpus1_at (+ ?x 1) (+ ?y 1) ))
;)


;;;______________________________________________________________________________________________
;; WUMPUS 2 RULES
;;;______________________________________________________________________________________________

;; move wumpus 2 one unit stochastically
(defrule wumpus2_move_stochastic
;    (declare (salience 11))
  ?z <- (wumpus2_at ?x ?y)
=>
  (retract ?z)
  (assert (wumpus2_at (- ?x (random -1 1)) (- ?y (random -1 1))))
)


;; move wumpus2 left one unit
;(defrule wumpus2_move_left
 ; ?z <- (wumpus2_at ?x ?y)
 ; (pos_at ?x =(- ?y 1) coins ?f  )
;=>
 ; (retract ?z)
 ; (assert (wumpus2_at ?x (- ?y 1)))
;)


;; move wumpus2 right one unit
;(defrule wumpus2_move_right
;  ?z <- (wumpus2_at ?x ?y)
 ; (pos_at ?x =(+ ?y 1) coins ?f  )
;=>
 ; (retract ?z)
 ; (assert (wumpus2_at ?x (+ ?y 1)))
;)


;; move wumpus2 up one unit
;(defrule wumpus2_move_up
 ; ?z <- (wumpus2_at ?x ?y)
 ; (pos_at =(- ?x 1) ?y coins ?f )
;=>
;  (retract ?z)
 ; (assert (wumpus2_at (- ?x 1) ?y ))
;)


;; move wumpus2 down one unit
;(defrule wumpus2_move_down
 ; ?z <- (wumpus2_at ?x ?y)
 ; (pos_at =(+ ?x 1) ?y coins ?f  )
;=>
 ; (retract ?z)
 ; (assert (wumpus2_at (+ ?x 1) ?y ))
;)


;; move wumpus2 diagonally up one unit and left one unit
;(defrule wumpus2_move_diagonally_up_left
;  ?z <- (wumpus2_at ?x ?y)
;  (pos_at =(- ?x 1) =(- ?y 1) coins ?f  )
;=>
;  (retract ?z)
;  (assert (wumpus2_at (- ?x 1) (- ?y 1)))
;)


;; move wumpus2 diagonally down one unit and right one unit
;(defrule wumpus2_move_diagonally_down_right
;  ?z <- (wumpus2_at ?x ?y)
;  (pos_at =(+ ?x 1) =(+ ?y 1) coins ?f  )
;=>
;  (retract ?z)
;  (assert (wumpus2_at (+ ?x 1) (+ ?y 1)))
;)


;; move wumpus2 diagonally up one unit and right one unit
;(defrule wumpus2_move_diagonally_up_right
;  ?z <- (wumpus2_at ?x ?y)
;  (pos_at =(- ?x 1) =(+ ?y 1) coins ?f )
;=>
;  (retract ?z)
;  (assert (wumpus2_at (- ?x 1) (+ ?y 1) ))
;)


;; move wumpus2 diagonally down one unit and left one unit
;(defrule wumpus2_move_diagonally_down_left
;  ?z <- (wumpus2_at ?x ?y)
;  (pos_at =(+ ?x 1) =(+ ?y 1) coins ?f  )
;=>
;  (retract ?z)
;  (assert (wumpus2_at (+ ?x 1) (+ ?y 1) ))
;)


;;;______________________________________________________________________________________________
;; ROBOT RULES
;;;______________________________________________________________________________________________

;; robot stuck at left barrier
(defrule robot_fix_stuck_x_low
  (declare (salience 2))
  ?z <- (robot_at 1 ?y)
=>
  (printout t "robot stuck at left barrier..."  crlf)
  (retract ?z)
  (assert (robot_at (+ 6 (mod (random) 2)) ?y))
)


;; robot stuck at right barrier
(defrule robot_fix_stuck_x_high
  (declare (salience 2))
  ?z <- (robot_at 6 ?y)
=>
  (printout t "robot stuck at right barrier..."  crlf)
  (retract ?z)
  (assert (robot_at (- 6 (mod (random) 2)) ?y))
)


;; robot stuck at bottom barrier
(defrule robot_fix_stuck_y_low
  (declare (salience 2))
  ?z <- (robot_at ?x 1)
=>
  (printout t "robot stuck at bottom barrier..."  crlf)
  (retract ?z)
  (assert (robot_at ?x (+ 6 (mod (random) 2))))
)


;; robot stuck at top barrier
(defrule robot_fix_stuck_y_high
  (declare (salience 2))
  ?z <- (robot_at ?x 6)
=>
  (printout t "robot stuck at top barrier..."  crlf)
  (retract ?z)
  (assert (robot_at ?x (- 6 (mod (random) 2))))
)


;;; move robot left
;(defrule robot_move_left
;  (declare (salience 3))
;  ?z <- (robot_at ?x ?y)
;  (pos_at ?x =(- ?y 1) coins ?f  )
;=>
;  (printout t "robot moving left..."  crlf)
;  (retract ?z)
;  (assert (robot_at ?x (- ?y 1)))
;)


;;; move robot right
;(defrule robot_move_right
;    (declare (salience 3))
;  ?z <- (robot_at ?x ?y)
;  (pos_at ?x =(+ ?y 1) coins ?f  )
;=>
;  (printout t "robot moving right..."  crlf)
;  (retract ?z)
;  (assert (robot_at ?x (+ ?y 1)))
;)


;;; move robot up
;(defrule robot_move_up
;    (declare (salience 2))
;  ?z <- (robot_at ?x ?y)
;  (pos_at =(- ?x 1) ?y coins ?f )
;=>
;  (printout t "robot moving up..."  crlf)
;  (retract ?z)
;  (assert (robot_at (- ?x 1) ?y ))
;)


;;; move robot down
;(defrule robot_move_down
;    (declare (salience 2))
;  ?z <- (robot_at ?x ?y)
;  (pos_at =(+ ?x 1) ?y coins ?f  )
;=>
;=>
;  (printout t "robot moving down..."  crlf)
;  (retract ?z)
;  (assert (robot_at (+ ?x 1) ?y ))
;)


;;; move robot diagonally up and left
;(defrule robot_move_diagonally_up_left
;    (declare (salience 3))
;  ?z <- (robot_at ?x ?y)
;  (pos_at =(- ?x 1)  =(- ?y 1) coins ?f  )
;=>
;  (printout t "robot moving up left..."  crlf)
;  (retract ?z)
;  (assert (robot_at (- ?x 1) (- ?y 1)))
;)


;;; move robot diagonally down and right
;(defrule robot_move_diagonally_down_right
;    (declare (salience 3))
;  ?z <- (robot_at ?x ?y)
;  (pos_at =(+ ?x 1) =(+ ?y 1) coins ?f  )
;=>
;  (printout t "robot moving down right..."  crlf)
;  (retract ?z)
;  (assert (robot_at (+ ?x 1) (+ ?y 1)))
;)


;;; move robot diagonally up and right
;(defrule robot_move_diagonally_up_right
;    (declare (salience 2))
;  ?z <- (robot_at ?x ?y)
;  (pos_at =(- ?x 1) =(+ ?y 1)coins ?f )
;=>
;  (printout t "robot moving up right..."  crlf)
;  (retract ?z)
;  (assert (robot_at (- ?x 1) (+ ?y 1) ))
;)


;;; move robot diagonally down and left
;(defrule robot_move_diagonally_down_left
;    (declare (salience 2))
;  ?z <- (robot_at ?x ?y)
;  (pos_at =(+ ?x 1) =(- ?y 1) coins ?f  )
;=>
;  (retract ?z)
;  (assert (robot_at (+ ?x 1) (- ?y 1) ))
;)


;; move robot one unit stochastically
(defrule robot_move_stochastic
  ?z <- (robot_at ?x ?y)
  (printout t "(" ?x ?y ")"  crlf)
=>
  (retract ?z)
  (assert (robot_at (- ?x (random -1 1)) (- ?y (random -1 1))))
)


;; get reward
(defrule collect_reward
  (declare (salience 10))
  (robot_at ?x ?y)
  ?z <- (pos_at ?x ?y  coins ?f&~0 )
  (printout ?x)
  (printout ?y)
=>
  (printout t "coin collected"  crlf)
  (retract ?z)
  (assert (pos_at ?x ?y coins (- ?f 1) ))
)
