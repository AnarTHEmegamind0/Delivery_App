# Delivery Driver App - Design System Rules

## Project Overview

Pinterest-inspired delivery driver app with award-quality aesthetics, glassmorphism components, image-first cards, and sophisticated animations.

## Design System Architecture

### Color System
- Primary: Emerald-teal `#00D4A1` (dark mode) / `#00B894` (light mode)
- Accent: Gold `#FFCB45`
- IMPORTANT: Never hardcode colors - always use `AppColors` from `lib/core/design_system/tokens/colors.dart`

### Component Organization
- Design system tokens: `lib/core/design_system/tokens/`
- Reusable components: `lib/core/design_system/components/`
- Feature pages: `lib/features/delivery/pages/`
- Feature widgets: `lib/features/delivery/widgets/`

### Styling Rules
- IMPORTANT: Use `AppSpacing` constants for all padding/margin values
- IMPORTANT: Use `AppShadows` for elevation - never use raw BoxShadow
- IMPORTANT: Use `AppAnimations` curves and durations for all animations
- Glassmorphism: Use `AppColors.glassGradient` with `BackdropFilter`
- Border radius: Use `AppSpacing.borderRadius*` presets

## Figma MCP Integration Rules

### Required Flow (do not skip)
1. Run `get_design_context` first to fetch the structured representation
2. Run `get_screenshot` for visual reference
3. Download any assets needed from the localhost source
4. Translate to Flutter using project conventions
5. Validate against Figma for 1:1 visual parity

### Implementation Rules
- Treat Figma MCP output as design reference, not final code
- Map Figma colors to `AppColors` tokens
- Use existing components from `lib/core/design_system/components/`
- Apply `AppAnimations` for all motion
- Use `AppShadows` for all elevation effects

### Asset Handling
- IMPORTANT: If Figma MCP returns localhost source, use it directly
- Store downloaded assets in `assets/images/`
- DO NOT install new icon packages - use Material Icons or Figma assets

## Component Patterns

### Pinterest-Style Cards
```dart
// Always use ImageCard for content with images
ImageCard(
  imageUrl: 'url',
  title: 'Title',
  subtitle: 'Subtitle',
  onTap: () {},
)
```

### Glassmorphism Containers
```dart
// Use GlassContainer for frosted glass effect
GlassContainer(
  child: content,
  borderRadius: AppSpacing.borderRadiusXl,
)
```

### Animated Buttons
```dart
// Use AnimatedButton for all CTAs
AnimatedButton(
  label: 'Action',
  onPressed: () {},
  variant: ButtonVariant.primary,
)
```

### Status Indicators
```dart
// Use StatusChip for order/delivery status
StatusChip(
  status: OrderStatus.inProgress,
  animated: true,
)
```

### Metric Displays
```dart
// Use MetricCounter for animated numbers
MetricCounter(
  value: 25000,
  prefix: '₮',
  duration: AppAnimations.slow,
)
```

## Animation Standards

### Page Transitions
- Use `AppAnimations.pinterestEaseOut` for entering elements
- Use `AppAnimations.pinterestEaseIn` for exiting elements
- Duration: `AppAnimations.medium` (350ms)

### Micro-interactions
- Button press: Scale to 0.96 with `AppAnimations.fast`
- Card hover: Elevation increase with `AppAnimations.normal`
- Toggle: Use `AppAnimations.smoothSpring` curve

### List Animations
- Stagger delay: 50ms between items
- Max stagger items: 10
- Use `flutter_animate` for declarative animations

## State Management

- Use Provider pattern (already established)
- Repositories handle API calls
- Providers manage state and notify listeners
- IMPORTANT: Keep UI logic in widgets, business logic in providers

## File Naming Conventions

- Components: `snake_case.dart` (e.g., `image_card.dart`)
- Pages: `*_page.dart` (e.g., `delivery_home_page.dart`)
- Widgets: Descriptive names (e.g., `order_card.dart`)
- Providers: `*_provider.dart`
- Models: `*_model.dart`

## Accessibility

- All interactive elements must have semantic labels
- Minimum touch target: 48x48 pixels
- Color contrast: WCAG AA compliance
- Support reduced motion system setting

## Performance

- Use `const` constructors wherever possible
- Wrap expensive widgets with `RepaintBoundary`
- Lazy load images with `cached_network_image`
- Limit stagger animations to 10 items max
