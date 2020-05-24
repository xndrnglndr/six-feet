# sixfeet

## What is this?
Six-Feet is an augmented reality iOS application that uses a device's rear camera to detect a person, highlight that person with an orange cylinder, and display the distance to that person.  If the distance is less than 6 feet, the distance label will display in red, and an (optional) alarm will sound. The unit system can be changed to metric.

*At the time of writing, this app is only supported on devices with A12/A12X Bionic or later chips, ANE, and TrueDepth Camera, running iOS 13 or above: iPhone XS/XS Max/XR/11/11 Pro/11 Pro Max, and iPad Pro 11-inch (2nd generation)/12.9-inch (4th generation).*

## Installation
* Open `SixFeet.xcodeproj` in Xcode
* Build and run on a supported device

## What do I need to do to publish to the app store?
1. Per [Apple](https://developer.apple.com/news/?id=03142020a), if you want to submit this app, you must be a "recognized [entity] such as [a] government [organization], health-focused [NGO], [company] deeply credentialed in health issues, [or a] medical or educational [institution]" as this would be considered related to COVID-19.

Note that Apple is willing to waive the normal developer account fee for some of these entities if the app itself is free ("nonprofit organizations, accredited educational institutions, and government entities that plan to distribute only free apps on the App Store can request to have their annual membership fee waived, if based in an eligible country").

2. Because apps need a privacy policy, you must update the privacy policy URL to one that points to your privacy policy (change the URL on line 65 of `SixFeet/Controller/InfoViewController.swift`).

3. That's it - the app should otherwise be ready to go (just build and archive). Remeber that **you will need to abide by the LICENSE.txt terms**. Also, if you do upload this to the App Store, please email [6feetapp@gmail.com](mailto:6feetapp@gmail.com) - it'd be nice to know.

## License
This is open-source software - see `LICENSE.txt` for more information.
