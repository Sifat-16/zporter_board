class MatchScore {
  int homeScore;
  int awayScore;

  MatchScore({this.homeScore = 0, this.awayScore = 0});

  factory MatchScore.fromJson(Map<String, dynamic> json) {
    return MatchScore(
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'homeScore': homeScore,
      'awayScore': awayScore,
    };
  }
}
