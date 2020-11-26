(define (domain mystery-strips)
   (:predicates
       (province ?x)
       (planet ?x)
       (food ?x)
       (pleasure ?x)
       (pain ?x)
       (eats ?n1 ?n2)
       (craves ?v ?n)
       (fears ?c ?v)
       (locale ?n ?a)
       (harmony ?v ?s)
       (attacks ?i ?j)
       (orbits ?i ?j))

   (:action overcome
       :parameters (?c ?v)
       :vars (?n ?s1 ?s2)
       :precondition (and (pain ?c)
			  (pleasure ?v)
			  (craves ?c ?n)
                          (craves ?v ?n)
			  (food ?n)
                          (harmony ?v ?s2)
			  (planet ?s2)
			  (orbits ?s1 ?s2)
                          (planet ?s1))
       :effect (and (not (craves ?c ?n))
                    (fears ?c ?v)
                    (not (harmony ?v ?s2))
                    (harmony ?v ?s1)))
   (:action feast
       :parameters (?v ?n1 ?n2)
       :vars (?l1 ?l2)
       :precondition (and (craves ?v ?n1)
			  (food ?n1)
			  (pleasure ?v)
                          (eats ?n1 ?n2)
			  (food ?n2)
                          (locale ?n1 ?l2)
                          (attacks ?l1 ?l2))
       :effect (and (not (craves ?v ?n1))
                    (craves ?v ?n2)
                    (not (locale ?n1 ?l2))
                    (locale ?n1 ?l1)))
   (:action succumb
       :parameters (?c ?v)
       :vars (?n ?s1 ?s2)
       :precondition (and (fears ?c ?v)
			  (pain ?c)
			  (pleasure ?v)
                          (craves ?v ?n)
			  (food ?n)
			  (harmony ?v ?s1)
                          (orbits ?s1 ?s2))
       :effect (and (not (fears ?c ?v))
                    (craves ?c ?n)
                    (not (harmony ?v ?s1))
                    (harmony ?v ?s2))))
