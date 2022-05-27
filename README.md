# Meet the open-source unique calculator app 👋
> A calculator app written for iOS, using swift, to be a modern and simple calculator
> with history, and with currency and unit conversions.

### ✨ See The App In Use
![4 app screenshots in black, green, red, and white with keypad and calculation shown](https://github.com/eliraz003/ios-calculator-app/blob/main/github_preview.png?raw=true)

### 📖 How To Install And Run
1. Download and install xCode and set up a provisioning profile
2. Download the codebase and open the CalcApp.xcodeproj in xCode
3. Within xCode, navigate to the Target options and change the "Team"
to your team within "Signing And Capabilities"
4. (optional) Change the address of the currency API to your endpoint

### 📱 Best Features
- Calculation history
- Currency conversion
- Time addition and conversion
- Calculating lengths and masses
- 8 Themes
- Faviouriting currencies

### 🏗 Get Started With The Codebase
> The main scripts you will need to worry about are:
UIViewController
UIControlDelegate
UIInterfaceDelegate
UIKeypadView
UIKeypadButton
UICalculationRowController
UICalculationRow

* The `UIViewController` script handles the main functionality and UI for the app
* The `UIViewController` inherits from the `UIControlDelegate` and `UIInterfaceDelegate` which provide static functionallity so that other parts of the app can call for actions, for example to call the backspace action call `UIViewController.controlDelegate.backspace()`
* Whenever the calculation is changed (pressing backspace, changing unit, adding a number, or changing the operation) the `WRTITE FUNCTION` is called to recalculate the total value
* `UIKeypadView` is the view that renders the keypad, it is self contained and creates a keypad based on the `keypadLabels` dictionary found, you can try changing these to create a new keypad layout
* `UIKeypadButton` is the individual button for the keypad, it can have either a label or icon property to determain what is rendered inside. When clicked it calls a `didPressKeyButton(action: String)` action within the `UIKeypadView` with the ID property passed to the label (determained by the `keypadLabels` dictionary)
* UICalculationRowController controls the calculation part of the app, it has two main properties, `rows:[UICalculationRow]` and `totalRow:UICalculationRow`, with `rows` containing every calculation currenctly inputted, and `totalRow` being the row that shows the user their final calculation.

### 🤝 Contributing
Contributions, issues and feature requests are welcome.
Feel free to check issues page if you want to contribute.
You can also send me an email at elirazatia003@gmail.com if you need 
furthur help and I will try to update this file with the information.