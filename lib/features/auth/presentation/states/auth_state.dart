import 'package:equatable/equatable.dart';
import 'package:tkit/features/auth/domain/entities/twitch_user.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication is in progress
class AuthLoading extends AuthState {
  final String? message;

  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when user is authenticated
class Authenticated extends AuthState {
  final TwitchUser user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// State when an authentication error occurs
class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// State when token is being refreshed
class TokenRefreshing extends AuthState {
  const TokenRefreshing();
}
