part of 'maps_bloc.dart';

abstract class MapsEvent extends Equatable{
  const MapsEvent();

  @override
  List<Object> get props => [];
}

class GetCoordFromAddress extends MapsEvent {
  final String address;

  const GetCoordFromAddress({required this.address});

  @override
  List<Object> get props => [address];
}