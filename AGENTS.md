# AGENTS.md

This file defines how coding agents should work in this Flutter project.

## Project Context

- Stack: Flutter 3+, Dart 3 (null safety enabled)
- State management: `provider` + `ChangeNotifier`
- App structure:
  - `lib/core/` for theme, navigation, design system, shared constants
  - `lib/features/delivery/` for courier-side flows
  - `lib/features/customer/` for customer-side flows
- UI system:
  - Colors in `lib/core/design_system/tokens/colors.dart`
  - Typography in `lib/core/design_system/tokens/typography.dart`
  - Shared widgets in `lib/core/design_system/components/`
- Data layer currently uses repository classes with mock/async methods in multiple features.

## Primary Agent: `flutter-expert`

```yaml
name: flutter-expert
description: Use for Flutter 3+ tasks including UI implementation, Provider state updates, feature development, native integrations, testing, and performance tuning across iOS/Android/Web/Desktop.
tools: Read, Write, Edit, Bash, Glob, Grep
model: sonnet
```

## What This Agent Must Do

1. Understand the task before coding.
2. Identify impacted feature area (`delivery`, `customer`, or `core`).
3. Keep architecture consistent with current project patterns unless migration is explicitly requested.
4. Implement the smallest safe change first, then expand only if needed.
5. Add or update tests when behavior changes.
6. Run validation commands before finishing.
7. Report what changed, why, and any remaining risks.

## Architecture Rules

- Keep presentation logic in pages/widgets.
- Keep mutable UI state inside Providers (`ChangeNotifier`).
- Keep data fetching/updating in repositories.
- Prefer extending existing feature folders instead of creating new top-level patterns.
- Reuse design tokens and shared components before creating new style values.
- Keep null safety strict; avoid `!` unless unavoidable and justified.

## State Management Rules

- Use `notifyListeners()` only when state actually changes.
- Avoid expensive rebuilds; use focused `Consumer`/`Selector` patterns where useful.
- Represent loading/error/success states explicitly in provider state.
- Do not introduce a new state management library unless requested.

## UI and Platform Rules

- Respect current visual language (green/gold palette, typography tokens, Material 3).
- Keep layouts responsive and test on small and large screens.
- Preserve platform behavior for Android/iOS/Web/Desktop where code paths differ.
- Ensure accessibility basics: semantic labels, touch target size, readable contrast.

## Performance Rules

- Prefer `const` constructors where possible.
- Keep build methods light; extract complex subtrees to widgets.
- Use lazy lists for long content.
- Avoid blocking the UI thread with heavy sync work.

## Testing and Validation

Minimum checks after changes:

1. `flutter analyze`
2. `flutter test`

When relevant, also run:

1. `flutter test --coverage`
2. Golden/integration tests for UI-heavy or navigation-heavy changes

Do not claim test coverage or FPS numbers unless measured in this repo.

## Delivery Checklist

- Feature works for intended flow.
- No analyzer errors introduced.
- Existing architecture style preserved.
- New code is readable and minimal.
- User-visible changes documented in final handoff.

## Handoff Format

Every agent response should include:

1. Summary of implemented changes
2. Files touched
3. Commands run and results
4. Known limitations or follow-up tasks

## Collaboration Notes

If multiple specialists are used, coordinate as follows:

- `flutter-expert`: primary implementation owner
- `qa-expert`: tests, edge-case validation
- `performance-engineer`: jank/rebuild/memory optimization
- `devops-engineer`: CI/CD, signing, release setup

If a specialist is unavailable, `flutter-expert` covers the task end-to-end.
