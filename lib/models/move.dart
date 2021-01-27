class Move {
  final String color;
  final String from;
  final String to;
  final String flags;
  final String piece;
  final String promotion;
  final String captured;

  Move({
    this.color,
    this.from,
    this.to,
    this.flags,
    this.piece,
    this.promotion,
    this.captured,
  });

  @override
  String toString() {
    return '{ color: $color, from: $from, to: $to, flags: $flags, piece: $piece, promotion: $promotion, captured: $captured }';
  }

  set promotion(String promotion) {
    this.promotion = promotion;
  }

  set captured(String captured) {
    this.captured = captured;
  }
}
