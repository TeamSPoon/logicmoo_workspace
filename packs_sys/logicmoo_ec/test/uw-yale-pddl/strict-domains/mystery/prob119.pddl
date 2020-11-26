(DEFINE (PROBLEM STRIPS-MYSTY-A-7)
   (:DOMAIN MYSTERY-STRIPS)
   (:OBJECTS BAGUETTE LETTUCE SWEETROLL SNICKERS WURST SCALLOP BEEF
             GRAPEFRUIT HOTDOG ONION TOFU ENDIVE CHICKEN KALE TOMATO TUNA
             CUCUMBER HAMBURGER SHRIMP LOBSTER EXPECTATION CURIOSITY
             SATISFACTION ACHIEVEMENT STIMULATION LONELINESS LACERATION GRIEF
             HANGOVER ANGER ANGINA GUANABARA MANITOBA BAVARIA JUPITER VULCAN
             EARTH URANUS)
   (:INIT (FOOD BAGUETTE)
          (FOOD LETTUCE)
          (FOOD SWEETROLL)
          (FOOD SNICKERS)
          (FOOD WURST)
          (FOOD SCALLOP)
          (FOOD BEEF)
          (FOOD GRAPEFRUIT)
          (FOOD HOTDOG)
          (FOOD ONION)
          (FOOD TOFU)
          (FOOD ENDIVE)
          (FOOD CHICKEN)
          (FOOD KALE)
          (FOOD TOMATO)
          (FOOD TUNA)
          (FOOD CUCUMBER)
          (FOOD HAMBURGER)
          (FOOD SHRIMP)
          (FOOD LOBSTER)
          (PLEASURE EXPECTATION)
          (PLEASURE CURIOSITY)
          (PLEASURE SATISFACTION)
          (PLEASURE ACHIEVEMENT)
          (PLEASURE STIMULATION)
          (PAIN LONELINESS)
          (PAIN LACERATION)
          (PAIN GRIEF)
          (PAIN HANGOVER)
          (PAIN ANGER)
          (PAIN ANGINA)
          (PROVINCE GUANABARA)
          (PROVINCE MANITOBA)
          (PROVINCE BAVARIA)
          (PLANET JUPITER)
          (PLANET VULCAN)
          (PLANET EARTH)
          (PLANET URANUS)
          (LOCALE HOTDOG GUANABARA)
          (LOCALE LETTUCE BAVARIA)
          (EATS WURST BAGUETTE)
          (EATS SNICKERS BAGUETTE)
          (EATS TOMATO TUNA)
          (LOCALE ENDIVE MANITOBA)
          (HARMONY ACHIEVEMENT EARTH)
          (EATS SWEETROLL LETTUCE)
          (CRAVES LONELINESS BEEF)
          (CRAVES ANGINA KALE)
          (EATS ONION TOFU)
          (CRAVES ANGER KALE)
          (LOCALE TOMATO GUANABARA)
          (EATS HOTDOG GRAPEFRUIT)
          (EATS SHRIMP TOMATO)
          (EATS TUNA TOMATO)
          (EATS LETTUCE SWEETROLL)
          (EATS KALE CUCUMBER)
          (EATS TUNA SHRIMP)
          (EATS SWEETROLL SNICKERS)
          (LOCALE TUNA MANITOBA)
          (ATTACKS GUANABARA MANITOBA)
          (LOCALE BAGUETTE GUANABARA)
          (EATS HAMBURGER KALE)
          (LOCALE BEEF BAVARIA)
          (EATS TUNA CHICKEN)
          (EATS LETTUCE KALE)
          (LOCALE ONION GUANABARA)
          (LOCALE LOBSTER BAVARIA)
          (EATS CHICKEN TUNA)
          (EATS LOBSTER CUCUMBER)
          (EATS TOFU ONION)
          (EATS CUCUMBER LOBSTER)
          (LOCALE CUCUMBER MANITOBA)
          (HARMONY CURIOSITY EARTH)
          (EATS KALE LETTUCE)
          (EATS TUNA BEEF)
          (EATS SCALLOP ENDIVE)
          (EATS SCALLOP HOTDOG)
          (ORBITS EARTH URANUS)
          (LOCALE HAMBURGER MANITOBA)
          (ORBITS JUPITER VULCAN)
          (EATS ONION GRAPEFRUIT)
          (EATS HOTDOG SCALLOP)
          (EATS GRAPEFRUIT ONION)
          (EATS WURST LETTUCE)
          (HARMONY STIMULATION URANUS)
          (EATS BEEF TUNA)
          (EATS TOMATO SHRIMP)
          (EATS HAMBURGER TUNA)
          (LOCALE SCALLOP GUANABARA)
          (EATS ENDIVE BEEF)
          (LOCALE SNICKERS MANITOBA)
          (EATS TOMATO HAMBURGER)
          (EATS TUNA HAMBURGER)
          (EATS HAMBURGER TOMATO)
          (EATS BEEF ENDIVE)
          (CRAVES CURIOSITY CHICKEN)
          (CRAVES ACHIEVEMENT TUNA)
          (EATS SNICKERS SWEETROLL)
          (CRAVES SATISFACTION KALE)
          (ATTACKS MANITOBA BAVARIA)
          (EATS BAGUETTE SNICKERS)
          (CRAVES EXPECTATION SNICKERS)
          (LOCALE SWEETROLL BAVARIA)
          (EATS ENDIVE SCALLOP)
          (EATS GRAPEFRUIT HOTDOG)
          (CRAVES LACERATION BEEF)
          (CRAVES HANGOVER TOFU)
          (LOCALE KALE GUANABARA)
          (CRAVES STIMULATION CUCUMBER)
          (EATS SWEETROLL BEEF)
          (EATS TOFU BEEF)
          (EATS BEEF SWEETROLL)
          (EATS KALE HAMBURGER)
          (HARMONY EXPECTATION URANUS)
          (ORBITS VULCAN EARTH)
          (LOCALE SHRIMP GUANABARA)
          (CRAVES GRIEF BEEF)
          (EATS BEEF TOFU)
          (LOCALE CHICKEN GUANABARA)
          (HARMONY SATISFACTION VULCAN)
          (EATS LETTUCE WURST)
          (LOCALE TOFU GUANABARA)
          (EATS CUCUMBER KALE)
          (LOCALE WURST GUANABARA)
          (EATS SHRIMP TUNA)
          (EATS LOBSTER CHICKEN)
          (EATS BAGUETTE WURST)
          (EATS CHICKEN LOBSTER)
          (LOCALE GRAPEFRUIT GUANABARA))
   (:GOAL (AND (CRAVES HANGOVER CUCUMBER))))