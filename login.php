<?php
session_start();
require_once('db_config.php');

// On initialise la variable pour éviter l'erreur "Undefined variable"
$erreur = ""; 

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email    = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';

    $sql  = "SELECT * FROM utilisateurs WHERE email = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if ($user) {
        // Comparaison directe (attention, admin123 doit être écrit tel quel en BDD)
        if ($password === $user['mot_de_passe']) { 
            $_SESSION['user_id'] = $user['id_utilisateur'];
            $_SESSION['nom']     = $user['nom'];
            $_SESSION['type']    = $user['type_compte'];

            if ($user['type_compte'] == 'admin') {
                header("Location: admin_dashboard.php");
            } elseif ($user['type_compte'] == 'vendeur') {
                header("Location: vendeur_mur.php?id=" . $user['id_utilisateur']);
            } else {
                header("Location: index.php");
            }
            exit();
        } else {
            $erreur = "Mot de passe incorrect.";
        }
    } else {
        $erreur = "Email inconnu.";
    }
}
include('header.php');
?>

<div class="container page-section">
    <div class="form-section">
        <h2 class="form-title">Connexion</h2>
        <p class="form-subtitle">Accédez à votre espace Omnes MarketPlace</p>

        <?php if (!empty($erreur)): ?>
            <div class="alert alert-error"><?php echo htmlspecialchars($erreur); ?></div>
        <?php endif; ?>

        <form method="POST">
            <div class="form-group">
                <label class="form-label" for="email">Adresse e-mail</label>
                <input class="form-control" type="email" id="email" name="email"
                       placeholder="votre@email.com" required
                       value="<?php echo htmlspecialchars($_POST['email'] ?? ''); ?>">
            </div>
            <div class="form-group">
                <label class="form-label" for="password">Mot de passe</label>
                <input class="form-control" type="password" id="password" name="password"
                       placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-primary btn-full mt-2">Se connecter</button>
        </form>

        <p class="form-link mt-2">
            Pas encore de compte ? <a href="inscription.php">S'inscrire</a>
        </p>
    </div>
</div>

<?php include('footer.php'); ?>