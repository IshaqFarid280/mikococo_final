// switch_provider.dart

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:mikococo/setting/SoundModel.dart';
import 'package:motion_toast/motion_toast.dart';

class SwitchProvider extends ChangeNotifier {
  bool _status = false;

  bool get status => _status;

  String _selectedUnit = 'kg';

  String get selectedUnit => _selectedUnit;
  //
  final List<SoundModel> _sounds = [
    SoundModel(name: 'Beep 1', assetPath: 'assets/sound/beep1.mp3'),
    SoundModel(name: 'Beep 2', assetPath: 'assets/sound/beep2.mp3'),
    SoundModel(name: 'Beep 3', assetPath: 'assets/sound/beep3.mp3'),
    SoundModel(name: 'Beep 4', assetPath: 'assets/sound/beep4.mp3'),
    SoundModel(name: 'Beep 5', assetPath: 'assets/sound/beepsound2.mp3'),
    SoundModel(name: 'Beep 6', assetPath: 'assets/sound/beepSound.mp3'),
  ];

  void playSound(SoundModel sound) {
    AssetsAudioPlayer().open(
      Audio(sound.assetPath),
    );
  }
  List<SoundModel> get sounds => _sounds;
  SoundModel? _selectedSound;

  SoundModel? get selectedSound => _selectedSound;

  void setSelectedSound(SoundModel sound) {
    _selectedSound = sound;
    notifyListeners();
  }
  int? _selectedTileIndex;

  int? get selectedTileIndex => _selectedTileIndex;

  void setSelectedTileIndex(int index) {
    _selectedTileIndex = index;
    notifyListeners();
  }

  void toggleSwitch(BuildContext context, bool value) {
    // Show error toast when the user tries to turn on the switch
    if (value) {
      MotionToast.success(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.8,
        title: Text("You have to Buy Premium", style: TextStyle(fontSize: 16)),
        borderRadius: 5,
        dismissable: true,
        animationDuration: Duration(seconds: 3),
        description: Text(''),
      ).show(context);
    } else {
      _status = value;
      notifyListeners();
    }
  }

  void setSelectedUnit(String unit) {
    _selectedUnit = unit;
    notifyListeners();
  }

}
