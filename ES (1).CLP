(defrule read-gender 
    (initial-fact)
    =>
    (printout t crlf crlf " Welcome! Diet and Nutrition Expert System" crlf)
    (printout t " ******************************** " crlf)
    (printout t " This output of this program is" crlf)
    (printout t " 1. Your Body Mass Index (BMI) and body-status." crlf)
    (printout t " 2. Recommended daily calories needed based on your body-status." crlf)
    (printout t " 3. Daily protein needed based on your weight (kgs)." crlf) 
    (printout t " 4. Daily calcium needed based on your age." crlf)
    (printout t " 5. Daily fiber needed based on your calories needed." crlf)
    (printout t " 6. Daily carbohydrate needed based on your weight (kgs)." crlf)
    (printout t " ******************************** " crlf crlf)
    (printout t " What is your gender (Female/Male) *case-sensitive* :") 
    (assert (gender (read))))

(defrule read-age
    (gender ?)
    =>
    (printout t " Please enter your age:")
    (assert (age (read))))

(defrule read-height 
    (age ?)
    =>
    (printout t "Please enter your height (in CMs):") 
    (assert (height (read))))

(defrule read-weight 
    (height ?)
    =>
    (printout t "Please enter your weight (in KGs):") 
    (assert (weight (read))))

(defrule read-activity-days
    (weight ?)
    =>
    (printout t "How many days do you exercise for a week:") 
    (assert (activity-days (read))))

(defrule activity-sedentary
    (activity-days ?d)
    =>
    (if (< ?d 2)
    then
    (assert (activity-factor 1.2) (activity-rate sedentary))))

(defrule activity-moderate
    (activity-days ?d)
    =>
    (if (and (>= ?d 2) (< ?d 5))
    then
    (assert (activity-factor 1.55) (activity-rate moderate))))

(defrule activity-hard
    (activity-days ?d)
    =>
    (if (>= ?d 5)
    then
    (assert (activity-factor 1.75) (activity-rate hard))))

(defrule calculate-BMI
    (weight ?w)
    (height ?h)
    =>
    (assert (bmi (/ (* ?w (/ ?h 100)) (/ ?h 100)))))

(defrule status-underweight
    (bmi ?b)
    =>
    (if (<? ?b 18.5)
    then
    (assert (body-status underweight))))

(defrule status-normalweight
    (bmi ?b)
    =>
    (if (and (>= ?b 18.5) (<? ?b 24.9))
    then
    (assert (body-status normal-weight))))


(defrule status-overweight
    (bmi ?b)
    =>
    (if (and (>= ?b 24.9) (<? ?b 29.9))
    then
    (assert (body-status overweight))))

(defrule status-obesity
    (bmi ?b)
    =>
    (if (>= ?b 29.9)
    then
    (assert (body-status obesity))))

(defrule calculate-calories-needed-female
    (gender Female)
    (age ?a)
    (weight ?w)
    (height ?h)
    (activity-factor ?af)
    =>
    (assert (calories-needed (/ (- (+ (* 10 ?w) (* 6.25 ?h) (* -5 ?a)) 161) ?af))))

(defrule calculate-calories-needed-male 
    (gender Male) 
    (age ?a)
    (weight ?w)
    (height ?h)
    (activity-factor ?af)
    =>
    (assert (calories-needed (/ (+ (- (+ (* 10 ?w) (* 6.25 ?h) (* -5 ?a)) 5)) ?af))))

(defrule get-calcium-baby
    (age ?a)
    =>
    (if (< ?a 4)
    then
    (assert (calcium-needed 700))))

(defrule get-calcium-children
    (age ?a)
    =>
    (if (and (>= ?a 4) (< ?a 9))
    then
    (assert (calcium-needed 1000))))

(defrule get-calcium-teenager
    (age ?a)
    =>
    (if (and (>= ?a 9) (< ?a 19))
    then
    (assert (calcium-needed 1300))))

(defrule get-calcium-adult
    (age ?a)
    =>
    (if (and (>= ?a 19) (< ?a 51))
    then
    (assert (calcium-needed 1000))))

(defrule get-calcium-oldpeople
    (age ?a)
    =>
    (if (>= ?a 51)
    then
    (assert (calcium-needed 1200))))

(defrule pget-protein-sedentary
    (activity-rate sedentary)
    (weight ?w)
    =>
    (assert (protein-needed (* 0.5 ?w))))

(defrule get-protein-moderate 
    (activity-rate moderate)
    (weight ?w)
    =>
    (assert (protein-needed (* 0.7 ?w))))

(defrule get-protein-hard 
    (activity-rate hard)
    (weight ?w)
    =>
    (assert (protein-needed (* 0.9 ?w))))

(defrule get-carbohydrate
    (weight ?w)
    =>
    (assert (carbohydrate-needed (* 4 ?w))))

(defrule get-fiber
    (calories-needed ?c)
    =>
    (assert (fiber-needed (math truncate (/ ?c 58.5)))))

(defrule protein-advice 
    (protein-needed ?p)
    =>
    (printout t crlf crlf" **********## Result ############" crlf)
    (printout t " 1. You need " ?p "g of protein per day." crlf))


(defrule carbohydrate-advice
    (carbohydrate-needed ?c)
    =>
    (printout t " 3. You need " ?c "g of carbohydrate per day." crlf))

(defrule fiber-advice
    (fiber-needed ?f)
    =>
    (printout t " 2. You need " ?f "g of fiber per day." crlf))

(defrule calcium-advice
    (calcium-needed ?c)
    =>
    (printout t " 4. You need " ?c "mg of calcium per day." crlf))

(defrule calories-advice-underweight
    (body-status underweight)
    (calories-needed ?c)
    (bmi ?bm)
    =>
    (printout t " 5. Your Body Mass Index (BMI) is " ?bm " and you are underweight." crlf)
    (printout t " 6. You need " ?c " calories per day. " crlf)
    (printout t " 7. For advice from the experts, You may need extra daily 300 calories (" (+ 300 ?c) ") to gain 0.25kg/week." crlf crlf))

(defrule calories-advice-normalweight
    (body-status normal-weight)
    (calories-needed ?c)
    (bmi ?bm)
    =>
    (printout t " 5. Your Body Mass Index (BMI) is " ?bm " and you have a normal weight." crlf)
    (printout t " 6. You need " ?c " calories per day to maintain your healthy weight." crlf crlf))

(defrule calories-advice-overweight
    (body-status overweight)
    (calories-needed ?c)
    (bmi ?bm)
    =>
    (printout t " 5. Your Body Mass Index (BMI) is " ?bm " and you are overweight." crlf)
    (printout t " 6. You need " ?c " calories per day. " crlf)
    (printout t " 7. For advice from the experts, You may need to reduce your daily calories needed by 300 to " (- ?c 300) " to lose 0.25kg/week." crlf crlf))

(defrule calories-advice-obesity
    (body-status obesity)
    (calories-needed ?c)
    (bmi ?bm)
    =>
    (printout t " 5. Your Body Mass Index (BMI) is " ?bm " and you are obese." crlf)
    (printout t " 6. You need " ?c " calories per day. " crlf)
    (printout t " 7. For advice from the experts, You may need to reduce your daily calories needed by 500 to " (- ?c 500) " to lose 0.5kg/week." crlf crlf))
