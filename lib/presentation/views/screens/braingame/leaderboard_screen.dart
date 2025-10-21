import 'package:brain_memo/l10n/app_localizations.dart';
import 'package:brain_memo/presentation/components/share_screen.dart';
import 'package:brain_memo/presentation/viewmodels/share_viewmodel.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final TextEditingController userPseudoController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    final shareVM = ShareViewModel();
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      //appBar: AppBar(title: const Text("Leaderboard")),
      body: ShareScreen(
        loc: loc,
        correctAnswer: "rr",
        score: 5,
        userAnswer: "ww",
      ),
    );
  }
}
