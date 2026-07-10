# Visit Libya V2 — Architecture Baseline

Status: LOCKED FOR SPRINT 1

## Application Architecture

lib/
- app/
- core/
- features/
- data/
- l10n/
- shared/

## Navigation

- App Shell
- IndexedStack for primary navigation
- Navigator.push for detail screens

## Bottom Navigation

1. Home
2. Explore
3. Destinations
4. Plan
5. More

## State Management

Sprint 1 uses lightweight Flutter state:

- ChangeNotifier where needed
- ValueNotifier where appropriate
- Local feature state
- No unnecessary Bloc / Redux / Riverpod migration

## Data Flow

JSON
→ Repository
→ Model
→ Feature UI

Screens must not parse JSON directly.

## Core Repositories

- DestinationRepository
- ExperienceRepository
- EventRepository
- GalleryRepository
- RouteRepository
- GuideRepository
- TravelInfoRepository

## Core Models

- Destination
- Experience
- TourismEvent
- GalleryItem
- TouristRoute
- TripPreference
- TripPlan
- GuideIntent
- TravelInformation

## Localization

- Arabic RTL
- English LTR
- Centralized UI strings
- Flutter localization infrastructure

## Design System

Visual style:

Modern Heritage Journey

Approved brand colors:

- Mediterranean Blue #0D5E9D
- Deep Navy #0B1F33
- Heritage Sand #C8A06B
- Journey Red #B62025
- White #FFFFFF