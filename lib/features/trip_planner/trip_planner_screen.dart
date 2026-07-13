import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/destination.dart';
import '../../data/models/trip_plan.dart';
import '../../data/models/trip_preference.dart';
import '../../data/repositories/destination_repository.dart';
import 'domain/trip_planner_engine.dart';
import 'trip_planner_localization.dart';
import 'trip_result_screen.dart';
import 'widgets/trip_planner_form_section.dart';

class TripPlannerScreen extends StatefulWidget {
  final DestinationRepository repository;

  const TripPlannerScreen({
    this.repository = const DestinationRepository(),
    super.key,
  });

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  static const List<int> _durations = <int>[1, 2, 3, 5, 7];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<Set<TripInterest>>> _interestsFieldKey =
      GlobalKey<FormFieldState<Set<TripInterest>>>();
  final Set<TripInterest> _selectedInterests = <TripInterest>{};

  late Future<List<Destination>> _destinationsFuture;
  String? _selectedDestinationId;
  int _durationDays = 3;
  TravelStyle _travelStyle = TravelStyle.balanced;
  TripGroupType _groupType = TripGroupType.solo;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  void _loadDestinations() {
    _destinationsFuture = widget.repository.loadDestinations();
  }

  void _retry() {
    setState(_loadDestinations);
  }

  void _setInterest(TripInterest interest, bool selected) {
    setState(() {
      if (selected) {
        _selectedInterests.add(interest);
      } else {
        _selectedInterests.remove(interest);
      }
    });
    _interestsFieldKey.currentState?.didChange(
      Set<TripInterest>.unmodifiable(_selectedInterests),
    );
  }

  void _submit(List<Destination> destinations) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final String destinationId = _selectedDestinationId!;
    final Destination destination = destinations.firstWhere(
      (Destination item) => item.id == destinationId,
    );
    final TripPreference preference = TripPreference(
      destinationId: destinationId,
      durationDays: _durationDays,
      interests: _selectedInterests.toList(growable: false),
      travelStyle: _travelStyle,
      groupType: _groupType,
    );
    final TripPlan plan = TripPlannerEngine.generate(preference);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => TripResultScreen(
          destination: destination,
          preference: preference,
          plan: plan,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.planYourTrip)),
      body: SafeArea(
        child: FutureBuilder<List<Destination>>(
          future: _destinationsFuture,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<Destination>> snapshot,
              ) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(
                      key: Key('tripPlannerLoading'),
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return _PlannerErrorState(onRetry: _retry);
                }

                return _buildForm(context, snapshot.requireData);
              },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<Destination> destinations) {
    return Form(
      key: _formKey,
      child: ListView(
        key: const Key('tripPlannerForm'),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xxxl,
        ),
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    context.l10n.tripPlannerDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TripPlannerFormSection(
                    title: context.l10n.destinationFieldLabel,
                    child: DropdownButtonFormField<String>(
                      key: const Key('tripDestinationField'),
                      initialValue: _selectedDestinationId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: context.l10n.selectDestination,
                      ),
                      items: destinations
                          .map(
                            (Destination destination) =>
                                DropdownMenuItem<String>(
                                  value: destination.id,
                                  child: Text(
                                    destination.name(
                                      Localizations.localeOf(context),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                          )
                          .toList(growable: false),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedDestinationId = value;
                        });
                      },
                      validator: (String? value) => value == null
                          ? context.l10n.destinationRequired
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TripPlannerFormSection(
                    title: context.l10n.tripDuration,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _durations
                          .map(
                            (int duration) => ChoiceChip(
                              key: Key('tripDuration-$duration'),
                              label: Text(
                                context.l10n.tripDurationDays(duration),
                              ),
                              selected: _durationDays == duration,
                              onSelected: (_) {
                                setState(() {
                                  _durationDays = duration;
                                });
                              },
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TripPlannerFormSection(
                    title: context.l10n.interests,
                    child: FormField<Set<TripInterest>>(
                      key: _interestsFieldKey,
                      initialValue: const <TripInterest>{},
                      validator: (Set<TripInterest>? value) =>
                          value == null || value.isEmpty
                          ? context.l10n.interestsRequired
                          : null,
                      builder: (FormFieldState<Set<TripInterest>> fieldState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: TripInterest.values
                                  .map(
                                    (TripInterest interest) => FilterChip(
                                      key: Key('tripInterest-${interest.id}'),
                                      label: Text(
                                        context.l10n.tripInterestLabel(
                                          interest,
                                        ),
                                      ),
                                      selected: _selectedInterests.contains(
                                        interest,
                                      ),
                                      onSelected: (bool selected) =>
                                          _setInterest(interest, selected),
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                            if (fieldState.hasError) ...<Widget>[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                fieldState.errorText!,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TripPlannerFormSection(
                    title: context.l10n.travelStyle,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: TravelStyle.values
                          .map(
                            (TravelStyle style) => ChoiceChip(
                              key: Key('tripStyle-${style.id}'),
                              label: Text(context.l10n.travelStyleLabel(style)),
                              selected: _travelStyle == style,
                              onSelected: (_) {
                                setState(() {
                                  _travelStyle = style;
                                });
                              },
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TripPlannerFormSection(
                    title: context.l10n.groupType,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: TripGroupType.values
                          .map(
                            (TripGroupType groupType) => ChoiceChip(
                              key: Key('tripGroup-${groupType.id}'),
                              label: Text(
                                context.l10n.tripGroupTypeLabel(groupType),
                              ),
                              selected: _groupType == groupType,
                              onSelected: (_) {
                                setState(() {
                                  _groupType = groupType;
                                });
                              },
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton.icon(
                    key: const Key('tripPlannerSubmitButton'),
                    onPressed: () => _submit(destinations),
                    icon: const Icon(Icons.route_outlined),
                    label: Text(context.l10n.createItinerary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlannerErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _PlannerErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(context.l10n.unableToLoadContent, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              key: const Key('tripPlannerRetryButton'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
