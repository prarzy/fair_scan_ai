class MatchSnapshot {
  final String homeTeam;
  final String awayTeam;
  final String score;
  final String clock;
  final bool hasOverlay;

  const MatchSnapshot({
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.clock,
    required this.hasOverlay,
  });

  @override
  String toString() {
    return 'MatchSnapshot(homeTeam: $homeTeam, awayTeam: $awayTeam, score: $score, clock: $clock, hasOverlay: $hasOverlay)';
  }
}
