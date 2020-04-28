# ios-test-task

Hi team,

Thanks for the interesting task.

Unfortunately, being limited in time I couldn't implement all the functionalities, described in the task.
Here I would like briefly explain what has been done and what I would like to improve.

Done:
1. The app sets an alarm, plays sleep and alarm sounds.
2. Background mode.
3. The workflow, described in the requirements.
4. Play/pause button.
5. Saving of recorded files to Documents folder.
6. Errors handling.

Were not implemented:
1. iTunes file sharing.
2. Switch off recording.
3. Tests.

What I would like to improve:
1. Check more cases.
2. Add more validations in models and view models.

Technical Notes:
- the app prints NSLayoutConstraint errors in the terminal if you open 'Sleep Time' or 'Alarm' action controllers. Please, note, this is common known issue:
https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints

- the app prints issue related to background task (no one background task was created in the app). The issue has been found in iOS 13. Seems like a system bug:
"Can't end BackgroundTask: no background task exists with identifier 5 (0x5), or it may have already been ended. Break in UIApplicationEndBackgroundTaskError() to debug."
