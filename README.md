<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->



## PinTextField

You can use this widget for phone number verification. After the data entry is provided, it returns it to you with the code name. You can do whatever you want with the code you have received.

![pintextfield](https://user-images.githubusercontent.com/13915117/147392982-cb0baeba-2b23-4fcb-9c6f-7588eefbe97e.gif)

## Usage

```dart
    PinTextField(
                  number: 6,
                  onComplete: (code) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Completed code is $code')));
                  },
                  validator: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Do not leave any codes missing!')));
                  })
```

- `number` number of textfields required for the pin.
- `onComplete` code that returns after all textfields are filled.
- `validator` Error message to be thrown if the form is submitted before any textfield is filled.
- `width` with of each textfield.
- `obscureText` Determines whether to hide codes.
- `style` TextStyle of codes.
- `decoration` InputDecoration of textfields.
- `validateErrorText` This is the error message that will be sent if the form is tried to be sent while the codes are missing.

## Additional information

In the future, it is planned that the phone will listen to the sms and receive the codes automatically.
