# StudentHealthTracker
It’s Not So Bad is a lighthearted yet realistic app that applies the college grading system to everyday life

Code is under It'sNotSoBad /iOS_Final/iOS_Final/ 
Complete instructions, sample screens, flowchart, compilation instructions are under AppGuide while code for the project can be found under It'sNotSoBad /AppGuide/.

User Instructions:
1. You will be given a blank state upon starting the app for the first time. When you start the
app make sure to use the simulator’s preset location by going to debug -> simulate
location -> New York. If the simulator is not running it might not let you do this so if you
must, first start the simulator then do the simulate location procedure. To ensure that it is
being simulated there should be a check mark next to New York.
2. To begin adding semesters, click the update button on the bottom left hand corner of the
home screen.
3. To add semesters, click the add semester button on the top right hand corner and input
your semester name. Add as many semesters as you wish.
4. To edit the individual weights/scores of a category click on the respective cell and move
the respective weight and scores sliders to the desired amounts. Click update to confirm.
5. Back brings you back to the homepage. The total circle represents your average total
grade (sum of all semester grades/number of semesters). Previous represents the total
score of the previous semester and Current represents the total score of the current
semester.
6. Clicking on the bottom right hand “my data” button brings you to your scores and
weights over time. Scroll left and right to view all categories. The top right hand corner
label and the data itself changes as the timer within this view controller rotates through
your semester data every 3 seconds.
7. Back brings you back to the homepage again. Click on the top right hand life check
button to be sent to a screen that pops up a YouTube video and small piece of advice. A
sound should first play upon entering this screen depending on your score. The video and
description varies based on your current semester’s highest weighted category’s score.
We assume this is what is most important to you right now, so if you have less than or
equal to an 85 in that category, it will display a video and description unique to that
category. If you have a score that is greater than 85 in that category it will display a
different video and description.
8. The bottom left hand assistance map button brings you to a map that displays useful
businesses/stores near you based on your current scores. The businesses that it displays
will vary depending on which category is your highest weighted category and what your
score in that category is.
9. To check if CoreData is working you can simply close the app then restart the app again.
Note* in simulator you might or might not need to do debug -> simulate location -> new
york when running the app again. Right now we do not support deleting semesters but if
you wish to start from a clean slate for testing purposes, uncommenting lines 286 and 287
in ViewControllerActual will delete all records in CoreData
