# ARCTextField

An advanced text field component with validation, states, and rich styling.

## Overview

`ARCTextField` provides a premium text input experience with support for floating labels, validation, icons, and multiple visual styles following Apple's Human Interface Guidelines.

Per Apple HIG: "Use a text field to request a small amount of information, such as a name or an email address. Show a hint in a text field to help communicate its purpose."

## Features

- **Multiple visual styles**: Outlined, filled, underlined, and liquid glass
- **Animated floating labels**: Labels animate from placeholder to above field
- **Built-in validation**: Required, email, password, phone, URL, and custom rules
- **Leading/trailing icons**: SF Symbol support for visual context
- **Clear button**: Configurable visibility (never, while editing, always)
- **Character counting**: Optional limit with visual counter
- **Password visibility toggle**: Built-in secure field with show/hide
- **Full accessibility**: VoiceOver support with proper labels and hints

## Usage

### Basic Text Field

```swift
@State private var name = ""

ARCTextField("Enter your name", text: $name)
```

### Email with Validation

```swift
@State private var email = ""

ARCTextField(
    "Email address",
    text: $email,
    configuration: .email
)
```

### Secure Password Field

```swift
@State private var password = ""

ARCSecureField(
    "Password",
    text: $password,
    configuration: .password
)
```

### With Icons and Helper Text

```swift
ARCTextField(
    "Search",
    text: $searchText,
    configuration: ARCTextFieldConfiguration(
        style: .filled,
        leadingIcon: "magnifyingglass",
        helperText: "Search for restaurants, cuisines, or locations"
    )
)
```

### Multiline with Character Limit

```swift
ARCTextField(
    "Bio",
    text: $bio,
    configuration: ARCTextFieldConfiguration(
        inputType: .multiline(lineLimit: 5),
        characterLimit: 150,
        showCharacterCount: true
    )
)
```

### Custom Validation

```swift
ARCTextField(
    "Username",
    text: $username,
    configuration: ARCTextFieldConfiguration(
        label: "Username",
        leadingIcon: "person",
        validation: ARCTextFieldValidation(
            rules: [
                .required("Username is required"),
                .minLength(3, message: "At least 3 characters"),
                .regex("^[a-zA-Z0-9_]+$", message: "Letters, numbers, underscore only")
            ],
            mode: .all
        ),
        validateOnChange: true
    )
)
```

## Configuration Presets

ARCTextField provides several built-in presets:

| Preset | Description |
|--------|-------------|
| `.default` | Outlined style with standard settings |
| `.email` | Email keyboard, validation, envelope icon |
| `.password` | Secure entry, lock icon, password validation |
| `.search` | Filled style, search icon, clear button |
| `.multiline` | Multi-line input with character limit |
| `.glass` | Premium liquid glass effect |
| `.phone` | Phone keyboard, validation |
| `.url` | URL keyboard, validation |
| `.filled` | Solid background style |
| `.underlined` | Minimal bottom line style |

## Validation Presets

Built-in validation configurations:

| Preset | Rules |
|--------|-------|
| `.required` | Non-empty value |
| `.email` | Valid email format |
| `.password` | Min 8 chars, letter + number |
| `.strongPassword` | Upper, lower, digit, special char |
| `.username` | 3-20 chars, alphanumeric + underscore |
| `.phoneNumber` | 10-15 digits |
| `.urlValidation` | Valid URL with scheme and host |

## Visual States

The text field displays different visual states:

- **Idle**: Default appearance with normal border color
- **Focused**: Highlighted border, floating label animation
- **Valid**: Green border and checkmark icon
- **Invalid**: Red border, error icon, and error message
- **Disabled**: Reduced opacity, non-interactive

## Topics

### Main Components

- ``ARCTextField``
- ``ARCSecureField``

### Configuration

- ``ARCTextFieldConfiguration``
- ``ARCTextFieldConfiguration/Style-swift.enum``
- ``ARCTextFieldConfiguration/InputType-swift.enum``
- ``ARCTextFieldConfiguration/ClearButtonMode-swift.enum``

### Validation

- ``ARCTextFieldValidation``
- ``ARCTextFieldValidation/ValidationMode-swift.enum``
- ``ARCTextFieldValidation/ValidationRule``

### Showcases

- ``ARCTextFieldShowcase``
