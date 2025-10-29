// features/onboarding/domain/entities/goal_entity.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GoalEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;

  const GoalEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    icon,
    iconColor,
    borderColor,
  ];
}
