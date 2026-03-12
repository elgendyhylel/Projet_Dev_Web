-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mer. 11 mars 2026 à 22:48
-- Version du serveur : 8.4.7
-- Version de PHP : 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `omnes_marketplace`
--

-- --------------------------------------------------------

--
-- Structure de la table `encheres`
--

DROP TABLE IF EXISTS `encheres`;
CREATE TABLE IF NOT EXISTS `encheres` (
  `id_enchere` int NOT NULL AUTO_INCREMENT,
  `id_produit` int DEFAULT NULL,
  `prix_max_client` decimal(10,2) DEFAULT NULL,
  `prix_actuel_enchere` decimal(10,2) DEFAULT NULL,
  `date_fin` datetime DEFAULT NULL,
  `id_meilleur_encherisseur` int DEFAULT NULL,
  PRIMARY KEY (`id_enchere`),
  KEY `id_produit` (`id_produit`),
  KEY `id_meilleur_encherisseur` (`id_meilleur_encherisseur`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `encheres`
--

INSERT INTO `encheres` (`id_enchere`, `id_produit`, `prix_max_client`, `prix_actuel_enchere`, `date_fin`, `id_meilleur_encherisseur`) VALUES
(1, 197, NULL, 499.00, '2026-03-18 23:38:43', 3);

-- --------------------------------------------------------

--
-- Structure de la table `negociations`
--

DROP TABLE IF EXISTS `negociations`;
CREATE TABLE IF NOT EXISTS `negociations` (
  `id_nego` int NOT NULL AUTO_INCREMENT,
  `id_produit` int DEFAULT NULL,
  `id_acheteur` int DEFAULT NULL,
  `dernier_prix_propose` decimal(10,2) DEFAULT NULL,
  `compteur_tours` int DEFAULT '0',
  `statut_nego` enum('en_cours','accepte','refuse') COLLATE utf8mb4_unicode_ci DEFAULT 'en_cours',
  PRIMARY KEY (`id_nego`),
  KEY `id_produit` (`id_produit`),
  KEY `id_acheteur` (`id_acheteur`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `paiements`
--

DROP TABLE IF EXISTS `paiements`;
CREATE TABLE IF NOT EXISTS `paiements` (
  `id_paiement` int NOT NULL AUTO_INCREMENT,
  `id_utilisateur` int DEFAULT NULL,
  `type_carte` enum('Visa','MasterCard','American Express','PayPal') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_carte` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nom_carte` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_expiration` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code_securite` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_paiement`),
  KEY `id_utilisateur` (`id_utilisateur`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `paiements`
--

INSERT INTO `paiements` (`id_paiement`, `id_utilisateur`, `type_carte`, `numero_carte`, `nom_carte`, `date_expiration`, `code_securite`) VALUES
(1, 3, 'Visa', '1234', 'EL GENDY', '02/2030', '123'),
(2, 4, 'PayPal', '11211111111111111111', 'Momo', '09/99', '999');

-- --------------------------------------------------------

--
-- Structure de la table `panier`
--

DROP TABLE IF EXISTS `panier`;
CREATE TABLE IF NOT EXISTS `panier` (
  `id_panier` int NOT NULL AUTO_INCREMENT,
  `id_acheteur` int DEFAULT NULL,
  `id_produit` int DEFAULT NULL,
  PRIMARY KEY (`id_panier`),
  KEY `id_acheteur` (`id_acheteur`),
  KEY `id_produit` (`id_produit`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

DROP TABLE IF EXISTS `produits`;
CREATE TABLE IF NOT EXISTS `produits` (
  `id_produit` int NOT NULL AUTO_INCREMENT,
  `id_vendeur` int DEFAULT NULL,
  `nom` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `prix_initial` decimal(10,2) DEFAULT NULL,
  `categorie` enum('rare','haut_de_gamme','regulier') COLLATE utf8mb4_unicode_ci NOT NULL,
  `type_vente` enum('immediat','transaction','enchere') COLLATE utf8mb4_unicode_ci NOT NULL,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statut` enum('en_vente','vendu') COLLATE utf8mb4_unicode_ci DEFAULT 'en_vente',
  PRIMARY KEY (`id_produit`),
  KEY `id_vendeur` (`id_vendeur`)
) ENGINE=MyISAM AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `produits`
--

INSERT INTO `produits` (`id_produit`, `id_vendeur`, `nom`, `description`, `prix_initial`, `categorie`, `type_vente`, `photo`, `video`, `statut`) VALUES
(1, 2, 'Article de Prestige n°1', 'Ceci est une description détaillée pour l\'article numéro 1. Produit de haute qualité testé pour Omnes MarketPlace.', 392.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(2, 2, 'Article de Prestige n°2', 'Ceci est une description détaillée pour l\'article numéro 2. Produit de haute qualité testé pour Omnes MarketPlace.', 426.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(3, 2, 'Article de Prestige n°3', 'Ceci est une description détaillée pour l\'article numéro 3. Produit de haute qualité testé pour Omnes MarketPlace.', 990.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(4, 2, 'Article de Prestige n°4', 'Ceci est une description détaillée pour l\'article numéro 4. Produit de haute qualité testé pour Omnes MarketPlace.', 455.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(5, 2, 'Article de Prestige n°5', 'Ceci est une description détaillée pour l\'article numéro 5. Produit de haute qualité testé pour Omnes MarketPlace.', 414.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(6, 2, 'Article de Prestige n°6', 'Ceci est une description détaillée pour l\'article numéro 6. Produit de haute qualité testé pour Omnes MarketPlace.', 203.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(7, 2, 'Article de Prestige n°7', 'Ceci est une description détaillée pour l\'article numéro 7. Produit de haute qualité testé pour Omnes MarketPlace.', 552.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(8, 2, 'Article de Prestige n°8', 'Ceci est une description détaillée pour l\'article numéro 8. Produit de haute qualité testé pour Omnes MarketPlace.', 906.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(9, 2, 'Article de Prestige n°9', 'Ceci est une description détaillée pour l\'article numéro 9. Produit de haute qualité testé pour Omnes MarketPlace.', 835.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(10, 2, 'Article de Prestige n°10', 'Ceci est une description détaillée pour l\'article numéro 10. Produit de haute qualité testé pour Omnes MarketPlace.', 738.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(11, 2, 'Article de Prestige n°11', 'Ceci est une description détaillée pour l\'article numéro 11. Produit de haute qualité testé pour Omnes MarketPlace.', 672.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(12, 2, 'Article de Prestige n°12', 'Ceci est une description détaillée pour l\'article numéro 12. Produit de haute qualité testé pour Omnes MarketPlace.', 853.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(13, 2, 'Article de Prestige n°13', 'Ceci est une description détaillée pour l\'article numéro 13. Produit de haute qualité testé pour Omnes MarketPlace.', 873.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(14, 2, 'Article de Prestige n°14', 'Ceci est une description détaillée pour l\'article numéro 14. Produit de haute qualité testé pour Omnes MarketPlace.', 470.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(15, 2, 'Article de Prestige n°15', 'Ceci est une description détaillée pour l\'article numéro 15. Produit de haute qualité testé pour Omnes MarketPlace.', 966.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(16, 2, 'Article de Prestige n°16', 'Ceci est une description détaillée pour l\'article numéro 16. Produit de haute qualité testé pour Omnes MarketPlace.', 188.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(17, 2, 'Article de Prestige n°17', 'Ceci est une description détaillée pour l\'article numéro 17. Produit de haute qualité testé pour Omnes MarketPlace.', 673.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(18, 2, 'Article de Prestige n°18', 'Ceci est une description détaillée pour l\'article numéro 18. Produit de haute qualité testé pour Omnes MarketPlace.', 500.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(19, 2, 'Article de Prestige n°19', 'Ceci est une description détaillée pour l\'article numéro 19. Produit de haute qualité testé pour Omnes MarketPlace.', 261.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(20, 2, 'Article de Prestige n°20', 'Ceci est une description détaillée pour l\'article numéro 20. Produit de haute qualité testé pour Omnes MarketPlace.', 969.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(21, 2, 'Article de Prestige n°21', 'Ceci est une description détaillée pour l\'article numéro 21. Produit de haute qualité testé pour Omnes MarketPlace.', 421.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(22, 2, 'Article de Prestige n°22', 'Ceci est une description détaillée pour l\'article numéro 22. Produit de haute qualité testé pour Omnes MarketPlace.', 207.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(23, 2, 'Article de Prestige n°23', 'Ceci est une description détaillée pour l\'article numéro 23. Produit de haute qualité testé pour Omnes MarketPlace.', 704.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(24, 2, 'Article de Prestige n°24', 'Ceci est une description détaillée pour l\'article numéro 24. Produit de haute qualité testé pour Omnes MarketPlace.', 582.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(25, 2, 'Article de Prestige n°25', 'Ceci est une description détaillée pour l\'article numéro 25. Produit de haute qualité testé pour Omnes MarketPlace.', 278.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(26, 2, 'Article de Prestige n°26', 'Ceci est une description détaillée pour l\'article numéro 26. Produit de haute qualité testé pour Omnes MarketPlace.', 174.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(27, 2, 'Article de Prestige n°27', 'Ceci est une description détaillée pour l\'article numéro 27. Produit de haute qualité testé pour Omnes MarketPlace.', 955.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(28, 2, 'Article de Prestige n°28', 'Ceci est une description détaillée pour l\'article numéro 28. Produit de haute qualité testé pour Omnes MarketPlace.', 656.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(29, 2, 'Article de Prestige n°29', 'Ceci est une description détaillée pour l\'article numéro 29. Produit de haute qualité testé pour Omnes MarketPlace.', 382.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(30, 2, 'Article de Prestige n°30', 'Ceci est une description détaillée pour l\'article numéro 30. Produit de haute qualité testé pour Omnes MarketPlace.', 764.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(31, 2, 'Article de Prestige n°31', 'Ceci est une description détaillée pour l\'article numéro 31. Produit de haute qualité testé pour Omnes MarketPlace.', 673.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(32, 2, 'Article de Prestige n°32', 'Ceci est une description détaillée pour l\'article numéro 32. Produit de haute qualité testé pour Omnes MarketPlace.', 181.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(33, 2, 'Article de Prestige n°33', 'Ceci est une description détaillée pour l\'article numéro 33. Produit de haute qualité testé pour Omnes MarketPlace.', 398.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(34, 2, 'Article de Prestige n°34', 'Ceci est une description détaillée pour l\'article numéro 34. Produit de haute qualité testé pour Omnes MarketPlace.', 590.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(35, 2, 'Article de Prestige n°35', 'Ceci est une description détaillée pour l\'article numéro 35. Produit de haute qualité testé pour Omnes MarketPlace.', 578.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(36, 2, 'Article de Prestige n°36', 'Ceci est une description détaillée pour l\'article numéro 36. Produit de haute qualité testé pour Omnes MarketPlace.', 185.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(37, 2, 'Article de Prestige n°37', 'Ceci est une description détaillée pour l\'article numéro 37. Produit de haute qualité testé pour Omnes MarketPlace.', 377.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(38, 2, 'Article de Prestige n°38', 'Ceci est une description détaillée pour l\'article numéro 38. Produit de haute qualité testé pour Omnes MarketPlace.', 757.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(39, 2, 'Article de Prestige n°39', 'Ceci est une description détaillée pour l\'article numéro 39. Produit de haute qualité testé pour Omnes MarketPlace.', 218.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(40, 2, 'Article de Prestige n°40', 'Ceci est une description détaillée pour l\'article numéro 40. Produit de haute qualité testé pour Omnes MarketPlace.', 137.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(41, 2, 'Article de Prestige n°41', 'Ceci est une description détaillée pour l\'article numéro 41. Produit de haute qualité testé pour Omnes MarketPlace.', 598.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(42, 2, 'Article de Prestige n°42', 'Ceci est une description détaillée pour l\'article numéro 42. Produit de haute qualité testé pour Omnes MarketPlace.', 687.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(43, 2, 'Article de Prestige n°43', 'Ceci est une description détaillée pour l\'article numéro 43. Produit de haute qualité testé pour Omnes MarketPlace.', 81.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(44, 2, 'Article de Prestige n°44', 'Ceci est une description détaillée pour l\'article numéro 44. Produit de haute qualité testé pour Omnes MarketPlace.', 541.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(45, 2, 'Article de Prestige n°45', 'Ceci est une description détaillée pour l\'article numéro 45. Produit de haute qualité testé pour Omnes MarketPlace.', 501.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(46, 2, 'Article de Prestige n°46', 'Ceci est une description détaillée pour l\'article numéro 46. Produit de haute qualité testé pour Omnes MarketPlace.', 111.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(47, 2, 'Article de Prestige n°47', 'Ceci est une description détaillée pour l\'article numéro 47. Produit de haute qualité testé pour Omnes MarketPlace.', 367.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(48, 2, 'Article de Prestige n°48', 'Ceci est une description détaillée pour l\'article numéro 48. Produit de haute qualité testé pour Omnes MarketPlace.', 979.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(49, 2, 'Article de Prestige n°49', 'Ceci est une description détaillée pour l\'article numéro 49. Produit de haute qualité testé pour Omnes MarketPlace.', 197.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(50, 2, 'Article de Prestige n°50', 'Ceci est une description détaillée pour l\'article numéro 50. Produit de haute qualité testé pour Omnes MarketPlace.', 63.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(51, 2, 'Article de Prestige n°51', 'Ceci est une description détaillée pour l\'article numéro 51. Produit de haute qualité testé pour Omnes MarketPlace.', 972.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(52, 2, 'Article de Prestige n°52', 'Ceci est une description détaillée pour l\'article numéro 52. Produit de haute qualité testé pour Omnes MarketPlace.', 247.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(53, 2, 'Article de Prestige n°53', 'Ceci est une description détaillée pour l\'article numéro 53. Produit de haute qualité testé pour Omnes MarketPlace.', 460.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(54, 2, 'Article de Prestige n°54', 'Ceci est une description détaillée pour l\'article numéro 54. Produit de haute qualité testé pour Omnes MarketPlace.', 927.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(55, 2, 'Article de Prestige n°55', 'Ceci est une description détaillée pour l\'article numéro 55. Produit de haute qualité testé pour Omnes MarketPlace.', 175.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(56, 2, 'Article de Prestige n°56', 'Ceci est une description détaillée pour l\'article numéro 56. Produit de haute qualité testé pour Omnes MarketPlace.', 687.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(57, 2, 'Article de Prestige n°57', 'Ceci est une description détaillée pour l\'article numéro 57. Produit de haute qualité testé pour Omnes MarketPlace.', 98.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(58, 2, 'Article de Prestige n°58', 'Ceci est une description détaillée pour l\'article numéro 58. Produit de haute qualité testé pour Omnes MarketPlace.', 945.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(59, 2, 'Article de Prestige n°59', 'Ceci est une description détaillée pour l\'article numéro 59. Produit de haute qualité testé pour Omnes MarketPlace.', 959.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(60, 2, 'Article de Prestige n°60', 'Ceci est une description détaillée pour l\'article numéro 60. Produit de haute qualité testé pour Omnes MarketPlace.', 160.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(61, 2, 'Article de Prestige n°61', 'Ceci est une description détaillée pour l\'article numéro 61. Produit de haute qualité testé pour Omnes MarketPlace.', 455.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(62, 2, 'Article de Prestige n°62', 'Ceci est une description détaillée pour l\'article numéro 62. Produit de haute qualité testé pour Omnes MarketPlace.', 975.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(63, 2, 'Article de Prestige n°63', 'Ceci est une description détaillée pour l\'article numéro 63. Produit de haute qualité testé pour Omnes MarketPlace.', 359.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(64, 2, 'Article de Prestige n°64', 'Ceci est une description détaillée pour l\'article numéro 64. Produit de haute qualité testé pour Omnes MarketPlace.', 807.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(65, 2, 'Article de Prestige n°65', 'Ceci est une description détaillée pour l\'article numéro 65. Produit de haute qualité testé pour Omnes MarketPlace.', 890.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(66, 2, 'Article de Prestige n°66', 'Ceci est une description détaillée pour l\'article numéro 66. Produit de haute qualité testé pour Omnes MarketPlace.', 244.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(67, 2, 'Article de Prestige n°67', 'Ceci est une description détaillée pour l\'article numéro 67. Produit de haute qualité testé pour Omnes MarketPlace.', 522.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(68, 2, 'Article de Prestige n°68', 'Ceci est une description détaillée pour l\'article numéro 68. Produit de haute qualité testé pour Omnes MarketPlace.', 290.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(69, 2, 'Article de Prestige n°69', 'Ceci est une description détaillée pour l\'article numéro 69. Produit de haute qualité testé pour Omnes MarketPlace.', 837.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(70, 2, 'Article de Prestige n°70', 'Ceci est une description détaillée pour l\'article numéro 70. Produit de haute qualité testé pour Omnes MarketPlace.', 410.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(71, 2, 'Article de Prestige n°71', 'Ceci est une description détaillée pour l\'article numéro 71. Produit de haute qualité testé pour Omnes MarketPlace.', 65.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(72, 2, 'Article de Prestige n°72', 'Ceci est une description détaillée pour l\'article numéro 72. Produit de haute qualité testé pour Omnes MarketPlace.', 126.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(73, 2, 'Article de Prestige n°73', 'Ceci est une description détaillée pour l\'article numéro 73. Produit de haute qualité testé pour Omnes MarketPlace.', 981.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(74, 2, 'Article de Prestige n°74', 'Ceci est une description détaillée pour l\'article numéro 74. Produit de haute qualité testé pour Omnes MarketPlace.', 212.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(75, 2, 'Article de Prestige n°75', 'Ceci est une description détaillée pour l\'article numéro 75. Produit de haute qualité testé pour Omnes MarketPlace.', 303.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(76, 2, 'Article de Prestige n°76', 'Ceci est une description détaillée pour l\'article numéro 76. Produit de haute qualité testé pour Omnes MarketPlace.', 733.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(77, 2, 'Article de Prestige n°77', 'Ceci est une description détaillée pour l\'article numéro 77. Produit de haute qualité testé pour Omnes MarketPlace.', 318.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(78, 2, 'Article de Prestige n°78', 'Ceci est une description détaillée pour l\'article numéro 78. Produit de haute qualité testé pour Omnes MarketPlace.', 190.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(79, 2, 'Article de Prestige n°79', 'Ceci est une description détaillée pour l\'article numéro 79. Produit de haute qualité testé pour Omnes MarketPlace.', 259.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(80, 2, 'Article de Prestige n°80', 'Ceci est une description détaillée pour l\'article numéro 80. Produit de haute qualité testé pour Omnes MarketPlace.', 643.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(81, 2, 'Article de Prestige n°81', 'Ceci est une description détaillée pour l\'article numéro 81. Produit de haute qualité testé pour Omnes MarketPlace.', 1000.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(82, 2, 'Article de Prestige n°82', 'Ceci est une description détaillée pour l\'article numéro 82. Produit de haute qualité testé pour Omnes MarketPlace.', 141.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(83, 2, 'Article de Prestige n°83', 'Ceci est une description détaillée pour l\'article numéro 83. Produit de haute qualité testé pour Omnes MarketPlace.', 729.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(84, 2, 'Article de Prestige n°84', 'Ceci est une description détaillée pour l\'article numéro 84. Produit de haute qualité testé pour Omnes MarketPlace.', 561.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(85, 2, 'Article de Prestige n°85', 'Ceci est une description détaillée pour l\'article numéro 85. Produit de haute qualité testé pour Omnes MarketPlace.', 750.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(86, 2, 'Article de Prestige n°86', 'Ceci est une description détaillée pour l\'article numéro 86. Produit de haute qualité testé pour Omnes MarketPlace.', 462.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(87, 2, 'Article de Prestige n°87', 'Ceci est une description détaillée pour l\'article numéro 87. Produit de haute qualité testé pour Omnes MarketPlace.', 817.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(88, 2, 'Article de Prestige n°88', 'Ceci est une description détaillée pour l\'article numéro 88. Produit de haute qualité testé pour Omnes MarketPlace.', 873.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(89, 2, 'Article de Prestige n°89', 'Ceci est une description détaillée pour l\'article numéro 89. Produit de haute qualité testé pour Omnes MarketPlace.', 509.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(90, 2, 'Article de Prestige n°90', 'Ceci est une description détaillée pour l\'article numéro 90. Produit de haute qualité testé pour Omnes MarketPlace.', 315.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(91, 2, 'Article de Prestige n°91', 'Ceci est une description détaillée pour l\'article numéro 91. Produit de haute qualité testé pour Omnes MarketPlace.', 355.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(92, 2, 'Article de Prestige n°92', 'Ceci est une description détaillée pour l\'article numéro 92. Produit de haute qualité testé pour Omnes MarketPlace.', 202.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(93, 2, 'Article de Prestige n°93', 'Ceci est une description détaillée pour l\'article numéro 93. Produit de haute qualité testé pour Omnes MarketPlace.', 187.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(94, 2, 'Article de Prestige n°94', 'Ceci est une description détaillée pour l\'article numéro 94. Produit de haute qualité testé pour Omnes MarketPlace.', 313.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(95, 2, 'Article de Prestige n°95', 'Ceci est une description détaillée pour l\'article numéro 95. Produit de haute qualité testé pour Omnes MarketPlace.', 283.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(96, 2, 'Article de Prestige n°96', 'Ceci est une description détaillée pour l\'article numéro 96. Produit de haute qualité testé pour Omnes MarketPlace.', 237.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(97, 2, 'Article de Prestige n°97', 'Ceci est une description détaillée pour l\'article numéro 97. Produit de haute qualité testé pour Omnes MarketPlace.', 170.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(98, 2, 'Article de Prestige n°98', 'Ceci est une description détaillée pour l\'article numéro 98. Produit de haute qualité testé pour Omnes MarketPlace.', 816.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(99, 2, 'Article de Prestige n°99', 'Ceci est une description détaillée pour l\'article numéro 99. Produit de haute qualité testé pour Omnes MarketPlace.', 97.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(100, 2, 'Article de Prestige n°100', 'Ceci est une description détaillée pour l\'article numéro 100. Produit de haute qualité testé pour Omnes MarketPlace.', 297.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(101, 2, 'Article de Prestige n°101', 'Ceci est une description détaillée pour l\'article numéro 101. Produit de haute qualité testé pour Omnes MarketPlace.', 529.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(102, 2, 'Article de Prestige n°102', 'Ceci est une description détaillée pour l\'article numéro 102. Produit de haute qualité testé pour Omnes MarketPlace.', 349.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(103, 2, 'Article de Prestige n°103', 'Ceci est une description détaillée pour l\'article numéro 103. Produit de haute qualité testé pour Omnes MarketPlace.', 563.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(104, 2, 'Article de Prestige n°104', 'Ceci est une description détaillée pour l\'article numéro 104. Produit de haute qualité testé pour Omnes MarketPlace.', 729.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(105, 2, 'Article de Prestige n°105', 'Ceci est une description détaillée pour l\'article numéro 105. Produit de haute qualité testé pour Omnes MarketPlace.', 568.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(106, 2, 'Article de Prestige n°106', 'Ceci est une description détaillée pour l\'article numéro 106. Produit de haute qualité testé pour Omnes MarketPlace.', 385.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(107, 2, 'Article de Prestige n°107', 'Ceci est une description détaillée pour l\'article numéro 107. Produit de haute qualité testé pour Omnes MarketPlace.', 498.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(108, 2, 'Article de Prestige n°108', 'Ceci est une description détaillée pour l\'article numéro 108. Produit de haute qualité testé pour Omnes MarketPlace.', 275.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(109, 2, 'Article de Prestige n°109', 'Ceci est une description détaillée pour l\'article numéro 109. Produit de haute qualité testé pour Omnes MarketPlace.', 243.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(110, 2, 'Article de Prestige n°110', 'Ceci est une description détaillée pour l\'article numéro 110. Produit de haute qualité testé pour Omnes MarketPlace.', 872.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(111, 2, 'Article de Prestige n°111', 'Ceci est une description détaillée pour l\'article numéro 111. Produit de haute qualité testé pour Omnes MarketPlace.', 755.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(112, 2, 'Article de Prestige n°112', 'Ceci est une description détaillée pour l\'article numéro 112. Produit de haute qualité testé pour Omnes MarketPlace.', 954.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(113, 2, 'Article de Prestige n°113', 'Ceci est une description détaillée pour l\'article numéro 113. Produit de haute qualité testé pour Omnes MarketPlace.', 132.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(114, 2, 'Article de Prestige n°114', 'Ceci est une description détaillée pour l\'article numéro 114. Produit de haute qualité testé pour Omnes MarketPlace.', 294.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(115, 2, 'Article de Prestige n°115', 'Ceci est une description détaillée pour l\'article numéro 115. Produit de haute qualité testé pour Omnes MarketPlace.', 300.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(116, 2, 'Article de Prestige n°116', 'Ceci est une description détaillée pour l\'article numéro 116. Produit de haute qualité testé pour Omnes MarketPlace.', 164.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(117, 2, 'Article de Prestige n°117', 'Ceci est une description détaillée pour l\'article numéro 117. Produit de haute qualité testé pour Omnes MarketPlace.', 578.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(118, 2, 'Article de Prestige n°118', 'Ceci est une description détaillée pour l\'article numéro 118. Produit de haute qualité testé pour Omnes MarketPlace.', 203.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(119, 2, 'Article de Prestige n°119', 'Ceci est une description détaillée pour l\'article numéro 119. Produit de haute qualité testé pour Omnes MarketPlace.', 922.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(120, 2, 'Article de Prestige n°120', 'Ceci est une description détaillée pour l\'article numéro 120. Produit de haute qualité testé pour Omnes MarketPlace.', 80.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(121, 2, 'Article de Prestige n°121', 'Ceci est une description détaillée pour l\'article numéro 121. Produit de haute qualité testé pour Omnes MarketPlace.', 780.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(122, 2, 'Article de Prestige n°122', 'Ceci est une description détaillée pour l\'article numéro 122. Produit de haute qualité testé pour Omnes MarketPlace.', 583.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(123, 2, 'Article de Prestige n°123', 'Ceci est une description détaillée pour l\'article numéro 123. Produit de haute qualité testé pour Omnes MarketPlace.', 195.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(124, 2, 'Article de Prestige n°124', 'Ceci est une description détaillée pour l\'article numéro 124. Produit de haute qualité testé pour Omnes MarketPlace.', 145.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(125, 2, 'Article de Prestige n°125', 'Ceci est une description détaillée pour l\'article numéro 125. Produit de haute qualité testé pour Omnes MarketPlace.', 886.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(126, 2, 'Article de Prestige n°126', 'Ceci est une description détaillée pour l\'article numéro 126. Produit de haute qualité testé pour Omnes MarketPlace.', 656.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(127, 2, 'Article de Prestige n°127', 'Ceci est une description détaillée pour l\'article numéro 127. Produit de haute qualité testé pour Omnes MarketPlace.', 331.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(128, 2, 'Article de Prestige n°128', 'Ceci est une description détaillée pour l\'article numéro 128. Produit de haute qualité testé pour Omnes MarketPlace.', 512.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(129, 2, 'Article de Prestige n°129', 'Ceci est une description détaillée pour l\'article numéro 129. Produit de haute qualité testé pour Omnes MarketPlace.', 946.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(130, 2, 'Article de Prestige n°130', 'Ceci est une description détaillée pour l\'article numéro 130. Produit de haute qualité testé pour Omnes MarketPlace.', 314.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(131, 2, 'Article de Prestige n°131', 'Ceci est une description détaillée pour l\'article numéro 131. Produit de haute qualité testé pour Omnes MarketPlace.', 843.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(132, 2, 'Article de Prestige n°132', 'Ceci est une description détaillée pour l\'article numéro 132. Produit de haute qualité testé pour Omnes MarketPlace.', 291.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(133, 2, 'Article de Prestige n°133', 'Ceci est une description détaillée pour l\'article numéro 133. Produit de haute qualité testé pour Omnes MarketPlace.', 768.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(134, 2, 'Article de Prestige n°134', 'Ceci est une description détaillée pour l\'article numéro 134. Produit de haute qualité testé pour Omnes MarketPlace.', 590.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(135, 2, 'Article de Prestige n°135', 'Ceci est une description détaillée pour l\'article numéro 135. Produit de haute qualité testé pour Omnes MarketPlace.', 149.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(136, 2, 'Article de Prestige n°136', 'Ceci est une description détaillée pour l\'article numéro 136. Produit de haute qualité testé pour Omnes MarketPlace.', 997.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(137, 2, 'Article de Prestige n°137', 'Ceci est une description détaillée pour l\'article numéro 137. Produit de haute qualité testé pour Omnes MarketPlace.', 894.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(138, 2, 'Article de Prestige n°138', 'Ceci est une description détaillée pour l\'article numéro 138. Produit de haute qualité testé pour Omnes MarketPlace.', 164.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(139, 2, 'Article de Prestige n°139', 'Ceci est une description détaillée pour l\'article numéro 139. Produit de haute qualité testé pour Omnes MarketPlace.', 697.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(140, 2, 'Article de Prestige n°140', 'Ceci est une description détaillée pour l\'article numéro 140. Produit de haute qualité testé pour Omnes MarketPlace.', 247.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(141, 2, 'Article de Prestige n°141', 'Ceci est une description détaillée pour l\'article numéro 141. Produit de haute qualité testé pour Omnes MarketPlace.', 266.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(142, 2, 'Article de Prestige n°142', 'Ceci est une description détaillée pour l\'article numéro 142. Produit de haute qualité testé pour Omnes MarketPlace.', 651.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(143, 2, 'Article de Prestige n°143', 'Ceci est une description détaillée pour l\'article numéro 143. Produit de haute qualité testé pour Omnes MarketPlace.', 450.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(144, 2, 'Article de Prestige n°144', 'Ceci est une description détaillée pour l\'article numéro 144. Produit de haute qualité testé pour Omnes MarketPlace.', 627.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(145, 2, 'Article de Prestige n°145', 'Ceci est une description détaillée pour l\'article numéro 145. Produit de haute qualité testé pour Omnes MarketPlace.', 263.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(146, 2, 'Article de Prestige n°146', 'Ceci est une description détaillée pour l\'article numéro 146. Produit de haute qualité testé pour Omnes MarketPlace.', 597.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(147, 2, 'Article de Prestige n°147', 'Ceci est une description détaillée pour l\'article numéro 147. Produit de haute qualité testé pour Omnes MarketPlace.', 957.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(148, 2, 'Article de Prestige n°148', 'Ceci est une description détaillée pour l\'article numéro 148. Produit de haute qualité testé pour Omnes MarketPlace.', 808.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(149, 2, 'Article de Prestige n°149', 'Ceci est une description détaillée pour l\'article numéro 149. Produit de haute qualité testé pour Omnes MarketPlace.', 84.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(150, 2, 'Article de Prestige n°150', 'Ceci est une description détaillée pour l\'article numéro 150. Produit de haute qualité testé pour Omnes MarketPlace.', 399.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(151, 2, 'Article de Prestige n°151', 'Ceci est une description détaillée pour l\'article numéro 151. Produit de haute qualité testé pour Omnes MarketPlace.', 433.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(152, 2, 'Article de Prestige n°152', 'Ceci est une description détaillée pour l\'article numéro 152. Produit de haute qualité testé pour Omnes MarketPlace.', 409.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(153, 2, 'Article de Prestige n°153', 'Ceci est une description détaillée pour l\'article numéro 153. Produit de haute qualité testé pour Omnes MarketPlace.', 348.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(154, 2, 'Article de Prestige n°154', 'Ceci est une description détaillée pour l\'article numéro 154. Produit de haute qualité testé pour Omnes MarketPlace.', 944.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(155, 2, 'Article de Prestige n°155', 'Ceci est une description détaillée pour l\'article numéro 155. Produit de haute qualité testé pour Omnes MarketPlace.', 787.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(156, 2, 'Article de Prestige n°156', 'Ceci est une description détaillée pour l\'article numéro 156. Produit de haute qualité testé pour Omnes MarketPlace.', 677.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(157, 2, 'Article de Prestige n°157', 'Ceci est une description détaillée pour l\'article numéro 157. Produit de haute qualité testé pour Omnes MarketPlace.', 853.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(158, 2, 'Article de Prestige n°158', 'Ceci est une description détaillée pour l\'article numéro 158. Produit de haute qualité testé pour Omnes MarketPlace.', 821.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(159, 2, 'Article de Prestige n°159', 'Ceci est une description détaillée pour l\'article numéro 159. Produit de haute qualité testé pour Omnes MarketPlace.', 142.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(160, 2, 'Article de Prestige n°160', 'Ceci est une description détaillée pour l\'article numéro 160. Produit de haute qualité testé pour Omnes MarketPlace.', 901.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(161, 2, 'Article de Prestige n°161', 'Ceci est une description détaillée pour l\'article numéro 161. Produit de haute qualité testé pour Omnes MarketPlace.', 61.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(162, 2, 'Article de Prestige n°162', 'Ceci est une description détaillée pour l\'article numéro 162. Produit de haute qualité testé pour Omnes MarketPlace.', 764.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(163, 2, 'Article de Prestige n°163', 'Ceci est une description détaillée pour l\'article numéro 163. Produit de haute qualité testé pour Omnes MarketPlace.', 802.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(164, 2, 'Article de Prestige n°164', 'Ceci est une description détaillée pour l\'article numéro 164. Produit de haute qualité testé pour Omnes MarketPlace.', 985.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(165, 2, 'Article de Prestige n°165', 'Ceci est une description détaillée pour l\'article numéro 165. Produit de haute qualité testé pour Omnes MarketPlace.', 364.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(166, 2, 'Article de Prestige n°166', 'Ceci est une description détaillée pour l\'article numéro 166. Produit de haute qualité testé pour Omnes MarketPlace.', 939.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(167, 2, 'Article de Prestige n°167', 'Ceci est une description détaillée pour l\'article numéro 167. Produit de haute qualité testé pour Omnes MarketPlace.', 862.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(168, 2, 'Article de Prestige n°168', 'Ceci est une description détaillée pour l\'article numéro 168. Produit de haute qualité testé pour Omnes MarketPlace.', 179.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(169, 2, 'Article de Prestige n°169', 'Ceci est une description détaillée pour l\'article numéro 169. Produit de haute qualité testé pour Omnes MarketPlace.', 798.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(170, 2, 'Article de Prestige n°170', 'Ceci est une description détaillée pour l\'article numéro 170. Produit de haute qualité testé pour Omnes MarketPlace.', 347.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(171, 2, 'Article de Prestige n°171', 'Ceci est une description détaillée pour l\'article numéro 171. Produit de haute qualité testé pour Omnes MarketPlace.', 808.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(172, 2, 'Article de Prestige n°172', 'Ceci est une description détaillée pour l\'article numéro 172. Produit de haute qualité testé pour Omnes MarketPlace.', 400.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(173, 2, 'Article de Prestige n°173', 'Ceci est une description détaillée pour l\'article numéro 173. Produit de haute qualité testé pour Omnes MarketPlace.', 961.00, 'haut_de_gamme', '', 'default_article.jpg', NULL, 'en_vente'),
(174, 2, 'Article de Prestige n°174', 'Ceci est une description détaillée pour l\'article numéro 174. Produit de haute qualité testé pour Omnes MarketPlace.', 750.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(175, 2, 'Article de Prestige n°175', 'Ceci est une description détaillée pour l\'article numéro 175. Produit de haute qualité testé pour Omnes MarketPlace.', 126.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(176, 2, 'Article de Prestige n°176', 'Ceci est une description détaillée pour l\'article numéro 176. Produit de haute qualité testé pour Omnes MarketPlace.', 557.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(177, 2, 'Article de Prestige n°177', 'Ceci est une description détaillée pour l\'article numéro 177. Produit de haute qualité testé pour Omnes MarketPlace.', 517.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(178, 2, 'Article de Prestige n°178', 'Ceci est une description détaillée pour l\'article numéro 178. Produit de haute qualité testé pour Omnes MarketPlace.', 972.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(179, 2, 'Article de Prestige n°179', 'Ceci est une description détaillée pour l\'article numéro 179. Produit de haute qualité testé pour Omnes MarketPlace.', 358.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(180, 2, 'Article de Prestige n°180', 'Ceci est une description détaillée pour l\'article numéro 180. Produit de haute qualité testé pour Omnes MarketPlace.', 730.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(181, 2, 'Article de Prestige n°181', 'Ceci est une description détaillée pour l\'article numéro 181. Produit de haute qualité testé pour Omnes MarketPlace.', 551.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(182, 2, 'Article de Prestige n°182', 'Ceci est une description détaillée pour l\'article numéro 182. Produit de haute qualité testé pour Omnes MarketPlace.', 850.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(183, 2, 'Article de Prestige n°183', 'Ceci est une description détaillée pour l\'article numéro 183. Produit de haute qualité testé pour Omnes MarketPlace.', 152.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(184, 2, 'Article de Prestige n°184', 'Ceci est une description détaillée pour l\'article numéro 184. Produit de haute qualité testé pour Omnes MarketPlace.', 896.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(185, 2, 'Article de Prestige n°185', 'Ceci est une description détaillée pour l\'article numéro 185. Produit de haute qualité testé pour Omnes MarketPlace.', 323.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(186, 2, 'Article de Prestige n°186', 'Ceci est une description détaillée pour l\'article numéro 186. Produit de haute qualité testé pour Omnes MarketPlace.', 993.00, 'regulier', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(187, 2, 'Article de Prestige n°187', 'Ceci est une description détaillée pour l\'article numéro 187. Produit de haute qualité testé pour Omnes MarketPlace.', 644.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(188, 2, 'Article de Prestige n°188', 'Ceci est une description détaillée pour l\'article numéro 188. Produit de haute qualité testé pour Omnes MarketPlace.', 279.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'vendu'),
(189, 2, 'Article de Prestige n°189', 'Ceci est une description détaillée pour l\'article numéro 189. Produit de haute qualité testé pour Omnes MarketPlace.', 421.00, 'rare', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(190, 2, 'Article de Prestige n°190', 'Ceci est une description détaillée pour l\'article numéro 190. Produit de haute qualité testé pour Omnes MarketPlace.', 774.00, 'haut_de_gamme', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(191, 2, 'Article de Prestige n°191', 'Ceci est une description détaillée pour l\'article numéro 191. Produit de haute qualité testé pour Omnes MarketPlace.', 442.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(192, 2, 'Article de Prestige n°192', 'Ceci est une description détaillée pour l\'article numéro 192. Produit de haute qualité testé pour Omnes MarketPlace.', 475.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(193, 2, 'Article de Prestige n°193', 'Ceci est une description détaillée pour l\'article numéro 193. Produit de haute qualité testé pour Omnes MarketPlace.', 690.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(194, 2, 'Article de Prestige n°194', 'Ceci est une description détaillée pour l\'article numéro 194. Produit de haute qualité testé pour Omnes MarketPlace.', 834.00, 'rare', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(195, 2, 'Article de Prestige n°195', 'Ceci est une description détaillée pour l\'article numéro 195. Produit de haute qualité testé pour Omnes MarketPlace.', 843.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'en_vente'),
(196, 2, 'Article de Prestige n°196', 'Ceci est une description détaillée pour l\'article numéro 196. Produit de haute qualité testé pour Omnes MarketPlace.', 475.00, 'regulier', '', 'default_article.jpg', NULL, 'en_vente'),
(197, 2, 'Article de Prestige n°197', 'Ceci est une description détaillée pour l\'article numéro 197. Produit de haute qualité testé pour Omnes MarketPlace.', 499.00, 'haut_de_gamme', 'enchere', 'default_article.jpg', NULL, 'en_vente'),
(198, 2, 'Article de Prestige n°198', 'Ceci est une description détaillée pour l\'article numéro 198. Produit de haute qualité testé pour Omnes MarketPlace.', 686.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(199, 2, 'Article de Prestige n°199', 'Ceci est une description détaillée pour l\'article numéro 199. Produit de haute qualité testé pour Omnes MarketPlace.', 231.00, 'regulier', 'immediat', 'default_article.jpg', NULL, 'vendu'),
(200, 2, 'Article de Prestige n°200', 'Ceci est une description détaillée pour l\'article numéro 200. Produit de haute qualité testé pour Omnes MarketPlace.', 237.00, 'rare', '', 'default_article.jpg', NULL, 'en_vente'),
(201, 4, 'Kebab', 'Salade Tomate ', 9.80, 'haut_de_gamme', '', '1773269242_075663bc.jpg', NULL, 'en_vente');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
CREATE TABLE IF NOT EXISTS `utilisateurs` (
  `id_utilisateur` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prenom` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mot_de_passe` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type_compte` enum('acheteur','vendeur','admin') COLLATE utf8mb4_unicode_ci NOT NULL,
  `adresse_ligne1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adresse_ligne2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ville` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code_postal` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pays` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_utilisateur`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id_utilisateur`, `nom`, `prenom`, `email`, `mot_de_passe`, `type_compte`, `adresse_ligne1`, `adresse_ligne2`, `ville`, `code_postal`, `pays`, `telephone`) VALUES
(1, 'Hina', 'Manolo', 'admin@omnes.fr', 'admin123', 'admin', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'Dupont', 'Jean', 'jean@vendeur.fr', 'vendeur123', 'vendeur', NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'EL GENDY', 'Hylel', 'elgendyhylel713@gmail.com', '$2y$10$mJ.j.ZTdlcjgB8tfWqdsWeBY4LGNA/BZjUXbDS5wWCVz2kJvYGtbW', 'acheteur', '5 Rue des Aulnes', NULL, 'Aulnay-sous-Bois', '93600', 'France', '0769167131'),
(4, 'Tom', 'Muller', 'tom.muller@bayern.du', '$2y$10$m8trQXQsG8GBbqe6A3OlD.BLYdgYecOiz8uNcfLDHuESSDCrUui1i', 'vendeur', '31 Rue de Bretagne', NULL, 'Sevran', '93270', 'France', '0000000000'),
(5, 'Martin', 'Lucas', 'acheteur1@test.fr', 'hash', 'acheteur', NULL, NULL, 'Paris', NULL, 'France', NULL),
(6, 'Bernard', 'Emma', 'acheteur2@test.fr', 'hash', 'acheteur', NULL, NULL, 'Lyon', NULL, 'France', NULL),
(7, 'Thomas', 'Hugo', 'acheteur3@test.fr', 'hash', 'acheteur', NULL, NULL, 'Marseille', NULL, 'France', NULL),
(8, 'Petit', 'Alice', 'acheteur4@test.fr', 'hash', 'acheteur', NULL, NULL, 'Lille', NULL, 'France', NULL),
(9, 'Robert', 'Liam', 'acheteur5@test.fr', 'hash', 'acheteur', NULL, NULL, 'Bordeaux', NULL, 'France', NULL),
(10, 'Richard', 'Jade', 'acheteur6@test.fr', 'hash', 'acheteur', NULL, NULL, 'Nantes', NULL, 'France', NULL),
(11, 'Durand', 'Arthur', 'acheteur7@test.fr', 'hash', 'acheteur', NULL, NULL, 'Toulouse', NULL, 'France', NULL),
(12, 'Dubois', 'Chloé', 'acheteur8@test.fr', 'hash', 'acheteur', NULL, NULL, 'Nice', NULL, 'France', NULL),
(13, 'Moreau', 'Léo', 'acheteur9@test.fr', 'hash', 'acheteur', NULL, NULL, 'Strasbourg', NULL, 'France', NULL),
(14, 'Laurent', 'Léa', 'acheteur10@test.fr', 'hash', 'acheteur', NULL, NULL, 'Montpellier', NULL, 'France', NULL),
(15, 'Vendeur', 'Pro1', 'vendeur1@test.fr', 'hash', 'vendeur', NULL, NULL, 'Paris', NULL, 'France', NULL),
(16, 'Vendeur', 'Pro2', 'vendeur2@test.fr', 'hash', 'vendeur', NULL, NULL, 'Lyon', NULL, 'France', NULL),
(17, 'Vendeur', 'Pro3', 'vendeur3@test.fr', 'hash', 'vendeur', NULL, NULL, 'Marseille', NULL, 'France', NULL),
(18, 'Vendeur', 'Pro4', 'vendeur4@test.fr', 'hash', 'vendeur', NULL, NULL, 'Lille', NULL, 'France', NULL),
(19, 'Vendeur', 'Pro5', 'vendeur5@test.fr', 'hash', 'vendeur', NULL, NULL, 'Bordeaux', NULL, 'France', NULL),
(20, 'Vendeur', 'Pro6', 'vendeur6@test.fr', 'hash', 'vendeur', NULL, NULL, 'Nantes', NULL, 'France', NULL),
(21, 'Vendeur', 'Pro7', 'vendeur7@test.fr', 'hash', 'vendeur', NULL, NULL, 'Toulouse', NULL, 'France', NULL),
(22, 'Vendeur', 'Pro8', 'vendeur8@test.fr', 'hash', 'vendeur', NULL, NULL, 'Nice', NULL, 'France', NULL),
(23, 'Vendeur', 'Pro9', 'vendeur9@test.fr', 'hash', 'vendeur', NULL, NULL, 'Strasbourg', NULL, 'France', NULL),
(24, 'Vendeur', 'Pro10', 'vendeur10@test.fr', 'hash', 'vendeur', NULL, NULL, 'Montpellier', NULL, 'France', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `vendeurs`
--

DROP TABLE IF EXISTS `vendeurs`;
CREATE TABLE IF NOT EXISTS `vendeurs` (
  `id_vendeur` int NOT NULL AUTO_INCREMENT,
  `id_utilisateur` int DEFAULT NULL,
  `pseudo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_profil` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_fond` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_vendeur`),
  KEY `id_utilisateur` (`id_utilisateur`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `vendeurs`
--

INSERT INTO `vendeurs` (`id_vendeur`, `id_utilisateur`, `pseudo`, `photo_profil`, `image_fond`) VALUES
(1, 2, 'JeanD', NULL, NULL),
(2, 4, 'Muller', 'default_profil.png', 'default_fond.jpg');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
