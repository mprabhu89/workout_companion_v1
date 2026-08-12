# Workout Companion V1

## Environment

* Flutter 3.44.6
* Dart 3.12.2
* Development branch: `release/v1-development`
* Offline-first Flutter application.

## Development Mode

* The existing architecture is frozen.
* Focus on completing a working V1 product.
* Do not redesign architecture.
* Do not refactor unrelated working code.
* Do not introduce unnecessary abstractions, layers, services, repositories, or frameworks.
* Preserve existing functionality.
* Make the smallest complete change required for the requested feature.
* Do not modify unrelated files.
* Do not commit or push unless explicitly instructed.

## Scope

Workout Companion is a structured guided-workout application, not merely a workout logger or generic sets/reps timer.

It must support guided activities including gym workouts, yoga, karate, meditation, physiotherapy, and similar activities involving ordered guidance, timing, counting, and repetition.

## Core Hierarchy

The intended functional execution hierarchy is:

Workout Plan
-> Workout Day
-> Session
-> Workout Template
-> Sequence Definition

Existing module/class names may differ. Preserve the current codebase terminology unless the requested feature explicitly requires otherwise.

## Sequence Definition

A Workout Template must ultimately support an editable ordered sequence made from these component behaviours:

### Guide

* Speaks the configured script using offline voice guidance.

### Count

* Performs the configured count.
* Counting is part of guided execution.

### Counter

* Defines repetition.
* Content before the Counter executes once.
* The sequence controlled by the Counter repeats for the configured repetition count.
* Each repetition can announce the current repetition number.

### Relax

* Pauses execution for the configured duration.
* Relax itself is not spoken unless separate Guide text explicitly provides speech.

### Break

* Exits the active Counter/repetition block according to sequence semantics.

### End

* Terminates the workout template sequence.

Do not simplify this execution model into only sets, repetitions, duration, and rest timers.

## Repetition Levels

Sequence Counter repetition and Session-level Workout Template repetition are different concepts and must remain distinct.

A Session can contain multiple Workout Templates.

A Workout Template itself can contain internal sequence repetition through Counter.

## Voice

* Voice guidance must work offline.
* Use existing local TTS abstractions/dependencies.
* Never invent exercise or movement instructions that are not stored in the application's data.
* Speech should follow the configured Sequence Definition.
* Voice failures must not break workout execution.

## Workout Execution

Execution must ultimately support:

* Session-level execution.
* Day-level execution.
* Ordered Workout Templates.
* Ordered Sequence Definition steps.
* Guide speech.
* Counting.
* Counter repetition.
* Relax timing.
* Break semantics.
* End handling.
* Progress tracking.

## V1 Completion Rules

Current priority is completing functional V1 behaviour.

Do not spend implementation effort on:

* architectural redesign,
* speculative optimizations,
* cosmetic refactoring,
* coding-standard refactoring,
* unrelated features.

Opening animation/music, final branding/icons, authentication/payment, subscription/admin functionality, paid export/QR sharing, and AI coaching belong to later agreed implementation phases and must not distract from current core functionality.

## File Changes

* Before editing, inspect only files relevant to the requested feature.
* Trace direct call sites/dependencies when required for compilation.
* Do not rescan the entire repository for every task.
* Preserve intentional existing changes.
* Avoid changing generated files unless explicitly required.

## Verification

For normal implementation packs:

1. Implement the requested feature.
2. Run `flutter analyze`.
3. Run only relevant tests when targeted tests exist.
4. Run the full `flutter test` when explicitly requested or before completing a significant pack.
5. Do not automatically run `flutter run` unless the feature requires device/manual verification.
6. Fix only errors caused by the current pack unless explicitly instructed otherwise.

## Reporting

At the end of a task report only:

* files created,
* files modified,
* feature completed,
* analyzer result,
* test result if run,
* blockers if any.

Keep the report concise.

Do not provide architectural recommendations unless explicitly requested.
