# ARCAIRecommender

An AI-powered recommendation component with dual modes: quick categories and interactive questionnaire.

## Overview

ARCAIRecommender provides a complete recommendation UI following Apple Intelligence design patterns. It supports two modes for gathering user preferences and displaying personalized recommendations.

## Features

- **Dual Mode Support**: Quick category selection or interactive questionnaire
- **Apple Intelligence Design**: Animated sparkles icon with pulse effect
- **Generic Item Support**: Works with any model conforming to `AIRecommenderItem`
- **Questionnaire System**: Single choice, multiple choice, and slider inputs
- **Chip-based Selection**: Modern pill-style option buttons
- **Configuration Presets**: Ready-to-use configurations for different apps
- **Full Accessibility**: VoiceOver labels and Dynamic Type support
- **Dark Mode Ready**: Semantic colors and materials

## Modes

### Quick Mode

Quick mode displays predefined categories with immediate results. Ideal for users who want fast recommendations.

```swift
@State private var selectedCategory: AIRecommenderCategory = .favorites

ARCAIRecommender(
    selectedCategory: $selectedCategory,
    items: recommendations,
    configuration: .restaurant
) { category in
    loadRecommendations(for: category)
} onItemSelected: { item in
    navigateToDetail(item)
}
```

### Questionnaire Mode

Questionnaire mode collects user preferences through interactive questions before generating recommendations.

```swift
@State private var answers = AIRecommenderAnswers()

ARCAIRecommender<MyItem>(
    questions: myQuestions,
    answers: $answers,
    configuration: .default
) { finalAnswers in
    let prompt = buildAIPrompt(from: finalAnswers)
    fetchRecommendations(prompt: prompt)
}
```

### Dual Mode

Combine both modes with a tab switcher for maximum flexibility.

```swift
@State private var mode: AIRecommenderMode = .quick
@State private var selectedCategory: AIRecommenderCategory = .favorites
@State private var answers = AIRecommenderAnswers()

ARCAIRecommender(
    mode: $mode,
    categories: AIRecommenderCategory.defaultCategories,
    selectedCategory: $selectedCategory,
    questions: questions,
    answers: $answers,
    items: recommendations,
    configuration: .default
) { category in
    // Quick mode category changed
} onItemSelected: { item in
    // Item tapped
} onQuestionnaireSubmit: { answers in
    // Questionnaire submitted
}
```

## AI Glow Border Effect

The focused card in the card stack displays an animated glowing border to visually distinguish AI-generated content. The effect includes:

- **Rotating gradient border**: A slowly spinning angular gradient (gold/amber tones) that creates ambient light around the card edge
- **Outer glow layer**: A blurred, diffuse version of the gradient for a soft halo
- **Sparkle particles**: Floating 4-point star shapes along the card perimeter that fade in and out at staggered intervals

### Configuration

Control the effect through three configuration properties:

```swift
let config = ARCAIRecommenderConfiguration(
    showGlowEffect: true,       // Enable/disable the glow border
    glowIntensity: .subtle,     // .subtle | .standard | .prominent
    showSparkles: true          // Enable/disable sparkle particles
)
```

### Standalone Usage

The glow border modifier can be used independently on any view:

```swift
MyCardView()
    .aiGlowBorder(
        isActive: isFocused,
        cornerRadius: 16,
        accentColor: .orange,
        intensity: .standard,
        showSparkles: true
    )
```

### Accessibility

- **Reduce Motion**: When enabled, the gradient becomes static (no rotation) and sparkles are hidden entirely
- The effect is purely decorative and is marked with `accessibilityHidden(true)`
- Only one glow Canvas is active at a time (the focused card), minimizing performance impact

### Preset Behavior

| Preset | Glow | Sparkles |
|--------|------|----------|
| `.default` | On | On |
| `.minimal` | Off | Off |
| `.compact` | On | Off |
| `.list` | Off | Off |

## Configuration Presets

ARCAIRecommender includes five configuration presets:

- **Default**: Amber accent with AI/Intelligence styling, glow effect enabled
- **Restaurant**: Orange accent for food-related apps (FavRes)
- **Books**: Blue accent for reading applications (FavBook)
- **Minimal**: No rank badges, AI reasons, or glow effect
- **Compact**: Reduced visual complexity, glow without sparkles

```swift
// Use a preset
ARCAIRecommender(
    selectedCategory: $category,
    items: items,
    configuration: .restaurant
)

// Or customize
let config = ARCAIRecommenderConfiguration(
    title: "My Recommender",
    accentColor: .purple,
    showRankBadges: true,
    showAIReason: true,
    showGlowEffect: true,
    glowIntensity: .standard
)
```

## Creating Questions

Define questions for the questionnaire mode using `AIRecommenderQuestion`:

```swift
let questions: [AIRecommenderQuestion] = [
    AIRecommenderQuestion(
        id: "mood",
        text: "How are you feeling today?",
        subtitle: "Select one option",
        options: [
            .init(id: "adventurous", label: "Adventurous", icon: "sparkles", color: .purple),
            .init(id: "relaxed", label: "Relaxed", icon: "leaf.fill", color: .green),
            .init(id: "social", label: "Social", icon: "person.2.fill", color: .blue)
        ],
        inputType: .singleChoice,
        icon: "face.smiling.fill"
    ),
    AIRecommenderQuestion(
        id: "preferences",
        text: "What do you prefer?",
        options: [
            .init(id: "option1", label: "Option A", icon: "star.fill", color: .orange),
            .init(id: "option2", label: "Option B", icon: "heart.fill", color: .pink)
        ],
        inputType: .multipleChoice
    )
]
```

### Input Types

- **singleChoice**: User selects exactly one option
- **multipleChoice**: User can select multiple options
- **slider**: User selects a value on a scale

## Implementing AIRecommenderItem

Your model must conform to `AIRecommenderItem`:

```swift
struct Restaurant: AIRecommenderItem {
    let id: UUID
    let title: String

    var subtitle: String? { "\(cuisineType) · \(priceRange)" }
    var rating: Double? { averageRating }
    var imageSource: AIRecommenderImageSource? { .system(cuisineIcon, color: .orange) }
    var aiReason: String? { "Based on your preferences" }

    // Your properties
    let cuisineType: String
    let priceRange: String
    let averageRating: Double
    let cuisineIcon: String
}
```

### Image Sources

```swift
// SF Symbol with color
.system("fork.knife", color: .orange)

// Asset catalog image
.image("restaurant-photo")

// Remote URL
.url(URL(string: "https://example.com/image.jpg")!)

// Gradient placeholder with initials
.placeholder(text: "MR", colors: [.orange, .red])
```

## Working with Answers

Access questionnaire responses via `AIRecommenderAnswers`:

```swift
func buildPrompt(from answers: AIRecommenderAnswers) -> String {
    var prompt = "Recommend items where: "

    // Get selected options
    if let mood = answers.selectedOptions(for: "mood").first {
        prompt += "mood is \(mood), "
    }

    // Check if specific option is selected
    if answers.isSelected("vegan", for: "dietary") {
        prompt += "dietary restriction is vegan, "
    }

    // Get slider value (0.0 to 1.0)
    if let budget = answers.sliderValue(for: "budget") {
        prompt += "budget level is \(Int(budget * 100))%"
    }

    return prompt
}

// Export all answers as dictionary
let dict = answers.toDictionary()
```

## Architecture

```
ARCAIRecommender/
├── ARCAIRecommender.swift              # Main view
├── ARCAIRecommenderConfiguration.swift # Configuration with presets
├── ARCAIRecommenderShowcase.swift      # Interactive demo
├── Models/
│   ├── AIRecommenderCategory.swift     # Predefined + custom categories
│   ├── AIRecommenderItem.swift         # Protocol for items
│   ├── AIRecommenderQuestion.swift     # Question model
│   ├── AIRecommenderAnswers.swift      # User responses
│   └── AIGlowIntensity.swift          # Glow effect intensity levels
└── Views/
    ├── AIRecommenderHeader.swift       # Hero section
    ├── AIRecommenderCategoryPicker.swift # Category pills
    ├── AIRecommenderItemCard.swift     # Recommendation card
    ├── AIRecommenderCardStack.swift    # Peek carousel with glow
    ├── AIRecommenderSwipeCard.swift    # Rich card for carousel
    ├── AIRecommenderQuestionCard.swift # Question with chips
    └── AIRecommenderQuestionnaire.swift # Full survey

ARCEffects/
├── AIGlowBorderModifier.swift          # Animated glow border modifier
└── AISparkleCanvas.swift               # Floating sparkle particles
```

## Topics

### Essentials

- ``ARCAIRecommender``
- ``ARCAIRecommenderConfiguration``
- ``AIRecommenderMode``

### Models

- ``AIRecommenderCategory``
- ``AIRecommenderItem``
- ``AIRecommenderImageSource``
- ``AIRecommenderQuestion``
- ``AIRecommenderAnswers``
- ``AIGlowIntensity``

### Examples

- ``ARCAIRecommenderShowcase``

## See Also

- <doc:GettingStarted>
- <doc:ARCDesignSystem>
