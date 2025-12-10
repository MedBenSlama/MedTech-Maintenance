// Service d'authentification SIMULÉ pour commencer
// Plus tard, on remplacera par Firebase

class AuthService {
  // Stockage local simple (dans la mémoire)
  static final Map<String, String> _users = {
    'technicien@hospital.com': 'password123',
    'admin@hospital.com': 'admin123',
    'test@test.com': 'test123',
  };

  static String? _currentUser;

  // Connexion simulée
  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulation de délai

    if (_users.containsKey(email) && _users[email] == password) {
      _currentUser = email;
      return true;
    }
    return false;
  }

  // Inscription simulée
  static Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_users.containsKey(email)) {
      return false; // Email déjà utilisé
    }

    _users[email] = password;
    _currentUser = email;
    return true;
  }

  // Déconnexion
  static void signOut() {
    _currentUser = null;
  }

  // Vérifier si connecté
  static bool get isLoggedIn => _currentUser != null;

  // Obtenir l'utilisateur actuel
  static String? get currentUserEmail => _currentUser;

  // Obtenir le nom affiché
  static String getDisplayName() {
    if (_currentUser == null) return 'Invité';

    final email = _currentUser!;
    final name = email.split('@').first;
    return name[0].toUpperCase() + name.substring(1);
  }
}
