import 'package:chess/components/board_piece.dart';
import 'package:chess/components/board_row.dart';
import 'package:chess/components/hint_move.dart';
import 'package:chess/components/square_marker.dart';
import 'package:chess/models/piece.dart';
import 'package:chess/models/position.dart';
import 'package:chess/utils/constants.dart';
import 'package:chess/utils/notations.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  final String player;
  final List<List<Piece>> board;
  final bool Function(String, String) isMoveValid;
  final List<String> Function(String) getPossibleMovesFrom;
  final String inCheck;

  Board({
    @required this.player,
    @required this.board,
    @required this.isMoveValid,
    @required this.getPossibleMovesFrom,
    @required this.inCheck,
  });

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final _rowsCount = List.filled(8, null);
  List<Position> _possibleMoves = [];
  Position _from;

  @override
  void didUpdateWidget(covariant Board oldWidget) {
    _possibleMoves = [];
    super.didUpdateWidget(oldWidget);
  }

  void _setMarkerPosition(Position from, [double size]) {
    setState(() {
      if (from != null) {
        String square = positionToSquare(from, size);
        List<String> moves = widget.getPossibleMovesFrom(square);

        List<Position> hints =
            moves.map((element) => squareToPosision(element, size)).toList();
        _possibleMoves = hints;
      }

      _from = from;
    });
  }

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width;
    double pieceSize = boardSize / 8;

    Position checkPosition = widget.inCheck != null
        ? squareToPosision(widget.inCheck, pieceSize)
        : null;

    List<BoardRow> boardRows = _rowsCount.asMap().entries.map(
      (item) {
        return BoardRow(columnIndex: item.key);
      },
    ).toList();

    List<HintMove> hints = _possibleMoves
        .map(
          (position) => HintMove(
            position: position,
            pieceSize: pieceSize,
          ),
        )
        .toList();

    List<BoardPiece> pieces = new List();

    widget.board.asMap().forEach(
          (columnIndex, row) => row.asMap().forEach(
            (rowIndex, piece) {
              if (piece != null) {
                pieces.add(
                  BoardPiece(
                    piece: piece,
                    player: widget.player,
                    isMoveValid: widget.isMoveValid,
                    setMarkerPosition: _setMarkerPosition,
                    position: Position(
                      x: rowIndex * pieceSize,
                      y: columnIndex * pieceSize,
                    ),
                  ),
                );
              }
            },
          ),
        );

    if (widget.player == BLACK) {
      pieces = pieces.reversed.toList();
    }

    return Center(
      child: Container(
        height: boardSize,
        width: boardSize,
        child: Stack(
          children: [
            Column(children: boardRows),
            ...hints,
            SquareMarker(
              position: checkPosition,
              pieceSize: pieceSize,
              color: Colors.red,
            ),
            SquareMarker(
              position: _from,
              pieceSize: pieceSize,
              color: Colors.yellow[300],
            ),
            ...pieces,
          ],
        ),
      ),
    );
  }
}
