(DEFINE (PROBLEM STRIPS-MYSTY-23)
   (:DOMAIN MYSTERY-STRIPS)
   (:OBJECTS CANTELOPE ARUGULA CHOCOLATE SNICKERS LAMB TURKEY
             BROCCOLI LETTUCE PEPPER PEAR TOFU ENDIVE LEMON WONDERBREAD
             POPOVER TUNA SCALLION CHICKEN GUAVA TOMATO PORK CUCUMBER
             HAMBURGER MELON PISTACHIO FLOUNDER APPLE HOTDOG OKRA SWEETROLL
             WURST HAM GRAPEFRUIT KALE CHERRY UNDERSTANDING LUBRICITY
             EMPATHY TRIUMPH ENTERTAINMENT SATIETY AESTHETICS ACHIEVEMENT
             EXPECTATION CURIOSITY EXCITEMENT STIMULATION PROSTATITIS
             LACERATION GRIEF ANGINA DEPRESSION LONELINESS DREAD ABRASION
             ANGER HANGOVER JEALOUSY BOILS ANXIETY SCIATICA ANXIETY-2
             DREAD-1 LACERATION-4 HANGOVER-3 DEPRESSION-8 BOILS-7
             JEALOUSY-6 MORAVIA QUEBEC OREGON GOIAS GUANABARA KENTUCKY ARIZONA
             PENNSYLVANIA BAVARIA SURREY VENUS VULCAN MARS MERCURY)
   (:INIT (FOOD CANTELOPE)
          (FOOD ARUGULA)
          (FOOD CHOCOLATE)
          (FOOD SNICKERS)
          (FOOD LAMB)
          (FOOD TURKEY)
          (FOOD BROCCOLI)
          (FOOD LETTUCE)
          (FOOD PEPPER)
          (FOOD PEAR)
          (FOOD TOFU)
          (FOOD ENDIVE)
          (FOOD LEMON)
          (FOOD WONDERBREAD)
          (FOOD POPOVER)
          (FOOD TUNA)
          (FOOD SCALLION)
          (FOOD CHICKEN)
          (FOOD GUAVA)
          (FOOD TOMATO)
          (FOOD PORK)
          (FOOD CUCUMBER)
          (FOOD HAMBURGER)
          (FOOD MELON)
          (FOOD PISTACHIO)
          (FOOD FLOUNDER)
          (FOOD APPLE)
          (FOOD HOTDOG)
          (FOOD OKRA)
          (FOOD SWEETROLL)
          (FOOD WURST)
          (FOOD HAM)
          (FOOD GRAPEFRUIT)
          (FOOD KALE)
          (FOOD CHERRY)
          (PLEASURE UNDERSTANDING)
          (PLEASURE LUBRICITY)
          (PLEASURE EMPATHY)
          (PLEASURE TRIUMPH)
          (PLEASURE ENTERTAINMENT)
          (PLEASURE SATIETY)
          (PLEASURE AESTHETICS)
          (PLEASURE ACHIEVEMENT)
          (PLEASURE EXPECTATION)
          (PLEASURE CURIOSITY)
          (PLEASURE EXCITEMENT)
          (PLEASURE STIMULATION)
          (PAIN PROSTATITIS)
          (PAIN LACERATION)
          (PAIN GRIEF)
          (PAIN ANGINA)
          (PAIN DEPRESSION)
          (PAIN LONELINESS)
          (PAIN DREAD)
          (PAIN ABRASION)
          (PAIN ANGER)
          (PAIN HANGOVER)
          (PAIN JEALOUSY)
          (PAIN BOILS)
          (PAIN ANXIETY)
          (PAIN SCIATICA)
          (PAIN ANXIETY-2)
          (PAIN DREAD-1)
          (PAIN LACERATION-4)
          (PAIN HANGOVER-3)
          (PAIN DEPRESSION-8)
          (PAIN BOILS-7)
          (PAIN JEALOUSY-6)
          (PROVINCE MORAVIA)
          (PROVINCE QUEBEC)
          (PROVINCE OREGON)
          (PROVINCE GOIAS)
          (PROVINCE GUANABARA)
          (PROVINCE KENTUCKY)
          (PROVINCE ARIZONA)
          (PROVINCE PENNSYLVANIA)
          (PROVINCE BAVARIA)
          (PROVINCE SURREY)
          (PLANET VENUS)
          (PLANET VULCAN)
          (PLANET MARS)
          (PLANET MERCURY)
          (ORBITS MARS MERCURY)
          (CRAVES CURIOSITY CUCUMBER)
          (HARMONY AESTHETICS MARS)
          (EATS LEMON ENDIVE)
          (EATS FLOUNDER HAMBURGER)
          (CRAVES ABRASION ENDIVE)
          (ATTACKS MORAVIA QUEBEC)
          (EATS PEAR ARUGULA)
          (LOCALE GUAVA MORAVIA)
          (CRAVES DEPRESSION-8 WURST)
          (EATS MELON CHERRY)
          (EATS PISTACHIO TOMATO)
          (LOCALE LETTUCE QUEBEC)
          (EATS ARUGULA PEAR)
          (EATS TURKEY SNICKERS)
          (EATS TOFU TURKEY)
          (LOCALE SNICKERS MORAVIA)
          (EATS OKRA SWEETROLL)
          (EATS TURKEY CHOCOLATE)
          (EATS OKRA HAM)
          (CRAVES EMPATHY TOFU)
          (EATS SNICKERS TURKEY)
          (CRAVES BOILS CHICKEN)
          (LOCALE TOFU MORAVIA)
          (LOCALE CUCUMBER GUANABARA)
          (HARMONY SATIETY VULCAN)
          (EATS CUCUMBER PISTACHIO)
          (ATTACKS QUEBEC OREGON)
          (EATS CHERRY TUNA)
          (CRAVES UNDERSTANDING TURKEY)
          (EATS APPLE MELON)
          (CRAVES ACHIEVEMENT GUAVA)
          (HARMONY EXPECTATION VULCAN)
          (ATTACKS BAVARIA SURREY)
          (CRAVES LACERATION-4 APPLE)
          (HARMONY EXCITEMENT MERCURY)
          (EATS CUCUMBER PORK)
          (HARMONY TRIUMPH VULCAN)
          (EATS WURST APPLE)
          (LOCALE FLOUNDER GOIAS)
          (EATS ENDIVE LEMON)
          (LOCALE PEAR BAVARIA)
          (EATS FLOUNDER GUAVA)
          (EATS TOMATO PISTACHIO)
          (CRAVES JEALOUSY SCALLION)
          (EATS CHICKEN HOTDOG)
          (EATS TUNA ENDIVE)
          (CRAVES ANXIETY-2 PORK)
          (EATS SWEETROLL OKRA)
          (EATS CUCUMBER HOTDOG)
          (LOCALE TOMATO OREGON)
          (CRAVES JEALOUSY-6 CHERRY)
          (EATS ENDIVE TUNA)
          (LOCALE WURST GOIAS)
          (EATS HOTDOG SWEETROLL)
          (LOCALE PORK PENNSYLVANIA)
          (LOCALE CANTELOPE MORAVIA)
          (EATS GRAPEFRUIT CHICKEN)
          (ATTACKS KENTUCKY ARIZONA)
          (CRAVES ANGINA BROCCOLI)
          (EATS CHOCOLATE ARUGULA)
          (HARMONY UNDERSTANDING MERCURY)
          (EATS ENDIVE PEPPER)
          (CRAVES ANXIETY GUAVA)
          (CRAVES GRIEF TURKEY)
          (LOCALE MELON MORAVIA)
          (CRAVES BOILS-7 KALE)
          (EATS CHERRY MELON)
          (CRAVES HANGOVER-3 HOTDOG)
          (HARMONY LUBRICITY MERCURY)
          (CRAVES DREAD-1 PISTACHIO)
          (EATS LAMB LEMON)
          (EATS PEAR BROCCOLI)
          (EATS BROCCOLI PEAR)
          (EATS POPOVER SWEETROLL)
          (LOCALE HAM PENNSYLVANIA)
          (HARMONY ACHIEVEMENT MERCURY)
          (LOCALE HAMBURGER QUEBEC)
          (HARMONY STIMULATION VULCAN)
          (CRAVES SATIETY POPOVER)
          (CRAVES DEPRESSION LETTUCE)
          (LOCALE OKRA PENNSYLVANIA)
          (EATS LEMON LAMB)
          (EATS MELON APPLE)
          (EATS WURST GUAVA)
          (EATS PORK CUCUMBER)
          (EATS CANTELOPE LETTUCE)
          (EATS TOFU PEPPER)
          (EATS GUAVA WURST)
          (EATS HAM OKRA)
          (EATS HOTDOG SCALLION)
          (HARMONY ENTERTAINMENT MARS)
          (EATS TUNA PORK)
          (HARMONY EMPATHY MARS)
          (LOCALE LEMON KENTUCKY)
          (EATS SCALLION PORK)
          (CRAVES HANGOVER POPOVER)
          (EATS SWEETROLL POPOVER)
          (LOCALE CHERRY KENTUCKY)
          (EATS CHERRY CUCUMBER)
          (LOCALE SWEETROLL GUANABARA)
          (EATS HOTDOG KALE)
          (ATTACKS GOIAS GUANABARA)
          (EATS PORK KALE)
          (LOCALE TURKEY MORAVIA)
          (EATS BROCCOLI LETTUCE)
          (ATTACKS GUANABARA KENTUCKY)
          (EATS PISTACHIO HOTDOG)
          (EATS LETTUCE BROCCOLI)
          (EATS KALE PORK)
          (EATS GRAPEFRUIT KALE)
          (ATTACKS OREGON GOIAS)
          (EATS PEPPER ENDIVE)
          (LOCALE TUNA SURREY)
          (LOCALE KALE GUANABARA)
          (EATS PORK SCALLION)
          (CRAVES LUBRICITY BROCCOLI)
          (EATS HAM WONDERBREAD)
          (CRAVES AESTHETICS SCALLION)
          (LOCALE APPLE MORAVIA)
          (LOCALE POPOVER GUANABARA)
          (EATS LAMB LETTUCE)
          (EATS TURKEY TOFU)
          (EATS WONDERBREAD WURST)
          (CRAVES ANGER WONDERBREAD)
          (EATS HOTDOG WURST)
          (EATS SWEETROLL HOTDOG)
          (EATS WONDERBREAD HAM)
          (CRAVES LACERATION CHOCOLATE)
          (EATS TOMATO APPLE)
          (EATS CHOCOLATE TURKEY)
          (LOCALE PISTACHIO PENNSYLVANIA)
          (LOCALE BROCCOLI GUANABARA)
          (CRAVES EXPECTATION TOMATO)
          (EATS CANTELOPE SNICKERS)
          (LOCALE PEPPER MORAVIA)
          (EATS PISTACHIO CUCUMBER)
          (EATS LETTUCE LAMB)
          (EATS CUCUMBER CHERRY)
          (EATS HOTDOG CUCUMBER)
          (EATS WURST WONDERBREAD)
          (CRAVES SCIATICA TOMATO)
          (LOCALE CHOCOLATE QUEBEC)
          (CRAVES EXCITEMENT KALE)
          (EATS POPOVER GRAPEFRUIT)
          (ORBITS VENUS VULCAN)
          (CRAVES LONELINESS PEPPER)
          (EATS LETTUCE CANTELOPE)
          (ATTACKS PENNSYLVANIA BAVARIA)
          (CRAVES TRIUMPH ENDIVE)
          (HARMONY CURIOSITY MERCURY)
          (CRAVES DREAD PEAR)
          (ORBITS VULCAN MARS)
          (LOCALE CHICKEN QUEBEC)
          (EATS KALE HOTDOG)
          (EATS SNICKERS CANTELOPE)
          (EATS GRAPEFRUIT POPOVER)
          (LOCALE ARUGULA PENNSYLVANIA)
          (EATS HAMBURGER SWEETROLL)
          (EATS HOTDOG PISTACHIO)
          (EATS HOTDOG CHICKEN)
          (LOCALE GRAPEFRUIT PENNSYLVANIA)
          (EATS WURST HOTDOG)
          (EATS APPLE TOMATO)
          (ATTACKS ARIZONA PENNSYLVANIA)
          (EATS CHICKEN GRAPEFRUIT)
          (LOCALE HOTDOG MORAVIA)
          (LOCALE WONDERBREAD QUEBEC)
          (LOCALE SCALLION OREGON)
          (LOCALE ENDIVE OREGON)
          (CRAVES PROSTATITIS CANTELOPE)
          (EATS ARUGULA CHOCOLATE)
          (EATS PEPPER TOFU)
          (EATS HAMBURGER FLOUNDER)
          (EATS KALE GRAPEFRUIT)
          (EATS PORK TUNA)
          (CRAVES STIMULATION CHERRY)
          (EATS APPLE WURST)
          (EATS TOFU PEAR)
          (EATS SWEETROLL HAMBURGER)
          (LOCALE LAMB QUEBEC)
          (CRAVES ENTERTAINMENT LEMON)
          (EATS WURST PISTACHIO)
          (EATS SCALLION HOTDOG)
          (EATS PEAR TOFU)
          (EATS TUNA CHERRY)
          (EATS GUAVA FLOUNDER)
          (EATS PISTACHIO WURST))
   (:GOAL (AND (CRAVES DREAD WURST)
               (CRAVES PROSTATITIS LETTUCE))))