.PHONY: analyze ui-check ui-fix arch-check guardian

analyze:
	flutter analyze

ui-check:
	dart tools/ui_police/ui_police.dart

ui-fix:
	dart tools/ui_autofix/ui_autofix.dart

arch-check:
	dart tools/architecture_guard/architecture_guard.dart

guardian:
	dart tools/project_guardian.dart

clean-code:
	dart format .
	dart fix --apply
	flutter analyze