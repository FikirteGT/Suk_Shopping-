import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Premium Luxury Theme (Lumina / Luxe Style)
  static const Color primary = Color(0xFF0F172A); // Deep Slate / Dark Navy
  static const Color primaryDark = Color(0xFF020617);
  static const Color primaryLight = Color(0xFF1E293B);

  static const Color secondary = Color(0xFFF1F5F9); // Light Slate / Soft Grey
  static const Color accent = Color(0xFFB8926A); // Luxury Gold / Bronze / Taupe
  static const Color tertiary = Color(0xFF23150D); // Espresso Brown

  // Neutral Colors (Light Theme)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Theme Tokens
  static const Color darkBackground = Color(0xFF090D16);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF0F172A);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF1E293B);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF23150D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
