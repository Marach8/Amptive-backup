- [ ] Convert `typedef LiveProgramEntryToken` record to `class LiveProgramEntryToken` with nullable fields.
- [ ] Update `get_live_program_entry_token_cubit.dart` to use the new class (generic types + currentData getter).
- [ ] Update `go_live_repo.dart` and `go_live_repo_impl.dart` to construct/return the new class instead of record literal.
- [ ] Update any other compilation errors from remaining usage points (if any) by locating them via build/analyze output.
- [ ] Run `flutter analyze` (or `flutter test`) to verify.

