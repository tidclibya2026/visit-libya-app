import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/guide_intent.dart';
import '../../data/repositories/guide_repository.dart';
import '../events/events_screen.dart';
import '../routes/routes_screen.dart';
import 'domain/smart_guide_engine.dart';
import 'widgets/guide_beta_notice.dart';
import 'widgets/guide_result_card.dart';

class SmartGuideScreen extends StatefulWidget {
  final GuideRepository repository;
  final SmartGuideEngine engine;
  final ValueChanged<int>? onSelectTab;

  const SmartGuideScreen({
    this.repository = const GuideRepository(),
    this.engine = const SmartGuideEngine(),
    this.onSelectTab,
    super.key,
  });

  @override
  State<SmartGuideScreen> createState() => _SmartGuideScreenState();
}

class _SmartGuideScreenState extends State<SmartGuideScreen> {
  late Future<List<GuideIntent>> _intentsFuture;
  final TextEditingController _queryController = TextEditingController();

  GuideIntent? _matchedIntent;
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _intentsFuture = widget.repository.loadIntents();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _matchedIntent = null;
      _hasSubmitted = false;
      _intentsFuture = widget.repository.loadIntents();
    });
  }

  void _submit(List<GuideIntent> intents, String query) {
    FocusScope.of(context).unfocus();
    setState(() {
      _hasSubmitted = true;
      _matchedIntent = widget.engine.match(query, intents);
    });
  }

  void _selectPrompt(List<GuideIntent> intents, GuideIntent intent) {
    final String prompt = intent.prompt(Localizations.localeOf(context));
    _queryController.text = prompt;
    _submit(intents, prompt);
  }

  bool _canOpen(GuideIntent intent) {
    return switch (intent.actionType) {
      GuideActionType.openTab =>
        widget.onSelectTab != null && _tabIndex(intent.actionValue) != null,
      GuideActionType.openScreen =>
        intent.actionValue == 'events' || intent.actionValue == 'routes',
      GuideActionType.none => false,
    };
  }

  void _openIntent(GuideIntent intent) {
    switch (intent.actionType) {
      case GuideActionType.openTab:
        final int? index = _tabIndex(intent.actionValue);
        if (index != null) {
          widget.onSelectTab?.call(index);
        }
        return;
      case GuideActionType.openScreen:
        final Widget? screen = switch (intent.actionValue) {
          'events' => const EventsScreen(),
          'routes' => const RoutesScreen(),
          _ => null,
        };
        if (screen != null) {
          Navigator.of(
            context,
          ).push<void>(MaterialPageRoute<void>(builder: (_) => screen));
        }
        return;
      case GuideActionType.none:
        return;
    }
  }

  int? _tabIndex(String actionValue) {
    return switch (actionValue) {
      'explore' => 1,
      'destinations' => 2,
      'plan' => 3,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.smartGuideBeta)),
      body: FutureBuilder<List<GuideIntent>>(
        future: _intentsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<GuideIntent>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                    key: Key('smartGuideLoadingIndicator'),
                  ),
                );
              }

              if (snapshot.hasError) {
                return _GuideError(onRetry: _retry);
              }

              final List<GuideIntent> intents = snapshot.requireData;
              return _GuideContent(
                intents: intents,
                queryController: _queryController,
                matchedIntent: _matchedIntent,
                hasSubmitted: _hasSubmitted,
                onSubmit: (String query) => _submit(intents, query),
                onPromptSelected: (GuideIntent intent) =>
                    _selectPrompt(intents, intent),
                canOpen: _canOpen,
                onOpen: _openIntent,
              );
            },
      ),
    );
  }
}

class _GuideContent extends StatelessWidget {
  final List<GuideIntent> intents;
  final TextEditingController queryController;
  final GuideIntent? matchedIntent;
  final bool hasSubmitted;
  final ValueChanged<String> onSubmit;
  final ValueChanged<GuideIntent> onPromptSelected;
  final bool Function(GuideIntent intent) canOpen;
  final ValueChanged<GuideIntent> onOpen;

  const _GuideContent({
    required this.intents,
    required this.queryController,
    required this.matchedIntent,
    required this.hasSubmitted,
    required this.onSubmit,
    required this.onPromptSelected,
    required this.canOpen,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: <Widget>[
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  context.l10n.smartGuideBeta,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.smartGuideDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                const GuideBetaNotice(),
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  key: const Key('smartGuideInput'),
                  controller: queryController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: onSubmit,
                  decoration: InputDecoration(
                    hintText: context.l10n.smartGuideInputHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  key: const Key('smartGuideSubmitButton'),
                  onPressed: () => onSubmit(queryController.text),
                  icon: const Icon(Icons.travel_explore_rounded),
                  label: Text(context.l10n.smartGuideAsk),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  context.l10n.smartGuideQuickPrompts,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: intents
                          .map(
                            (GuideIntent intent) => ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth,
                              ),
                              child: ActionChip(
                                key: ValueKey<String>(
                                  'smartGuidePrompt-${intent.id}',
                                ),
                                avatar: const Icon(
                                  Icons.auto_awesome_outlined,
                                  size: 18,
                                ),
                                label: Text(
                                  intent.prompt(locale),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: () => onPromptSelected(intent),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    );
                  },
                ),
                if (hasSubmitted) ...<Widget>[
                  const SizedBox(height: AppSpacing.xl),
                  if (matchedIntent == null)
                    Text(
                      context.l10n.smartGuideNoMatch,
                      key: const Key('smartGuideNoMatch'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  else
                    GuideResultCard(
                      intent: matchedIntent!,
                      showAction: canOpen(matchedIntent!),
                      onAction: () => onOpen(matchedIntent!),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GuideError extends StatelessWidget {
  final VoidCallback onRetry;

  const _GuideError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.unableToLoadContent,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              key: const Key('smartGuideRetryButton'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
