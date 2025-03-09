import 'package:equatable/equatable.dart';

class MatchEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MatchLoadEvent extends MatchEvent{

}

class MatchSelectEvent extends MatchEvent{
  final int index;
  MatchSelectEvent({required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}