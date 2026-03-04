# Repository Guidelines

## Project Structure & Module Organization
- `lib/` contains all app code.
- `lib/models/` holds data models (`course.dart`, `schedule.dart`).
- `lib/services/` contains API/auth/cache/business services.
- `lib/pages/` contains UI screens (onboarding, schedule, settings, etc.).
- `android/` contain platform-specific build config.
- Root scripts: `run_dev.ps1` (local run) and `build_prod.ps1` (release APK).
- Environment files: `.env.dev` and `.env.prod` provide `--dart-define` values.

## Build, Test, and Development Commands
- `flutter pub get`: install dependencies from `pubspec.yaml`.
- `./run_dev.ps1`: run app with dev defines (`.env.dev`).
- `flutter run --dart-define-from-file=.env.dev`: equivalent manual dev run.
- `./build_prod.ps1`: build release APK with `.env.prod`.
- `flutter analyze`: run static analysis using `flutter_lints`.
- `flutter test`: run tests (add tests under `test/` as features are added).

## Coding Style & Naming Conventions
- Follow `analysis_options.yaml` (`package:flutter_lints/flutter.yaml`).
- Use 2-space indentation and format with `dart format .` before PRs.
- File names use `snake_case.dart`; classes use `PascalCase`; methods/fields use `lowerCamelCase`.
- Keep widget/page classes in `lib/pages`, service logic in `lib/services`, and avoid cross-layer mixing.

## Testing Guidelines
- Preferred framework: `flutter_test`.
- Place tests in `test/` mirroring `lib/` paths (example: `test/services/auth_service_test.dart`).
- Name files with `_test.dart` suffix.
- For new features or bug fixes, include at least one unit/widget test covering the changed behavior.

## Commit & Pull Request Guidelines
- Use Conventional Commits where possible: `feat(scope): ...`, `fix(scope): ...`, `chore: ...`.
- Keep subject lines imperative and under ~72 chars.
- Group one logical change per commit.
- PRs should include: concise summary, testing notes (`flutter analyze`, `flutter test`), linked issue (if any), and screenshots/GIFs for UI changes.

## Security & Configuration Tips
- Never commit secrets or private keys.
- Treat `.env.*` as configuration inputs; keep production values minimal and reviewed.
- Validate Google sign-in/domain-related changes carefully in auth flows.
