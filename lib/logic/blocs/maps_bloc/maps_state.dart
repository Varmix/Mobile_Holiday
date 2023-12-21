part of 'maps_bloc.dart';

enum MapsStatus {initial, loading, loaded, error, inProgress}

class MapsState extends Equatable {
  final MapsStatus status;
  final double latitude;
  final double longitude;
  final String? errorMessage;

  const MapsState({
    this.status = MapsStatus.initial,
    this.latitude = 0,
    this.longitude = 0,
    this.errorMessage = "",
  });

  MapsState copyWith({
    MapsStatus? status,
    double? latitude,
    double? longitude,
    String? errorMessage
  }) {
    return MapsState(
      status : status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      errorMessage : errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [status, latitude, longitude, errorMessage];

}