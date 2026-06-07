import '../entities/activity.dart';
import '../entities/emotion.dart';
import '../entities/location.dart';
import '../entities/quadrant.dart';
import '../entities/stage.dart';

abstract class ReferenceRepository {
  Future<List<Quadrant>> getQuadrants();

  Future<Quadrant?> getQuadrant(int id);

  Future<List<Emotion>> getEmotionsForQuadrant(int quadrantId);

  Future<List<Emotion>> getAllEmotions();

  Future<Emotion?> getEmotion(int id);

  Future<List<Stage>> getStages();

  Future<Stage?> getStageByCode(String code);

  Future<List<Activity>> getActivities();

  Future<Activity?> getActivity(int id);

  Future<List<Location>> getLocations();

  Future<Location?> getLocation(int id);
}
