-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 06, 2024 at 08:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `recinscan`
--

-- --------------------------------------------------------

--
-- Table structure for table `dishes`
--

CREATE TABLE `dishes` (
  `id` int(11) NOT NULL,
  `dish_name` varchar(255) NOT NULL,
  `instructions` text DEFAULT NULL,
  `image_path` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dishes`
--

INSERT INTO `dishes` (`id`, `dish_name`, `instructions`, `image_path`) VALUES
(1, 'Sisig Kapampangan Style With (Pork Belly)', 'Season pork belly slices with salt and pepper. Let it marinate for at least 30 minutes. Grill pork belly and chicken liver until well done. Pork skin should be crispy. Once grilled, chop the pork belly and chicken liver into small fine pieces. In a bowl, combine the chopped meat, onions, lemon juice and chili pepper. Season with soy sauce and pepper. Warm it in a pan with a bit of oil if desired. Alternatively, heat a sizzling plate and add a some butter or margarine. Add the Sisig and serve while still sizzling hot.', '/static/assets/img/Recipes/recipe1.jpg'),
(2, 'Sisig Kapampangan Style With (Pork Parts)', 'Finely chop the grilled pork parts and set aside. Finely chop the grilled chicken liver. (You may also use a food processor.) In a large bowl, combine the finely chopped grilled pork parts and chicken liver. Add the onions, chilli, and calamansi juice. Add more calamansi juice if you want it more sour. (Note: Sisig should be sour. Others use vinegar as their souring agent, I prefer calamansi as it adds fragrance to the dish. Vinegar is too acidic, in my opinion.) Season with salt and pepper to taste. Serve on a plate. Garnish with a slice of calamansi and chilli. If you wish to serve on a sizzling plate, you may also do so. Preheat the sizzling plate, add a bit of butter, then place the sisig on the hot plate. Garnish with a slice of calamansi and chilli.', '/static/assets/img/Recipes/recipe2.jpg'),
(3, 'Tocino Kapampangan Style', 'In a large mixing bowl. Add all the ingredients for the tocino marinade except for the pork slices. Mix the ingredients together until will combined. Add the pork slices into the marinade and mix by hand for up to an hour, or more if you have the patience to do so. Don’t forget to use gloves to avoid stained hands! Once done with the mixing, transfer the pork to a container with a cover and let it sit overnight on the countertop. Mix pork around for a couple of times more before placing it in the fridge to cure for 24 hours or up to 3 days. It can be frozen afterwards and stored for longer (up to 3 months). Now that you’ve acquired the knack of making your own tocino (or no shame in just getting store-bought ones), it’s time to cook it! Add about 2 cups of water (or just enough to cover the meat) and 1/4 cup of cooking oil into a large frying pan together with the pork tocino slices. Boil over high heat. The process of boiling further tenderises the meat while cooking. When the water evaporates, the cooking oil will be left, instantly frying the meat. Turn the meat over after a few minutes of frying to cook evenly on all sides. Serve hot with garlicky fried rice or steamed rice and fried egg – browned and crispy on the edges with a golden liquidy yolk is how I like my fried eggs. In addition, it tastes best when dipped in spicy vinegar!', '/static/assets/img/Recipes/recipe3.jpg'),
(4, 'Pork Menudo Kapampangan Style', 'Mix kalamansi or lemon juice with salt, pepper. Marinade meat for minimum 30mins the longer the better and ensure to keep in chiller when marinating. Heat oil in a pot, low heat lightly fry diced potatoes and carrots take out from pan and serve aside. On the same pot with oil sauté crushed garlic, onions, Annato powder, bay leaves and oregano. Add the meat leaving the sauce on the side. Simmer until no pink in meat. Add pork liver. Sauté for about 10mins. Add tomato paste and sauté it well. Very important to sauté the paste properly into the meat, onions and garlic. Then add fish sauce, water and lit it simmer until meat is tender. When meat is tender add the lightly browned potato, carrots hot dogs and green peas. Taste and add salt and pepper according to desired taste. Let it simmer 3-5mins. Add the capsicum and raisins. Let it simmer for another 3-5mins. Serve warm with rice.', '/static/assets/img/Recipes/recipe4.jpg'),
(5, 'Beef Caldereta Kapampangan Style', 'Boil and simmer beef brisket, onions, laurel, basil and pepper in at least 1/2 liter water for 1 hour and 45 minutes or until tender. Remove the scums that floats on top.Turn off heat and take off laurel leaf. On another pan, sauté garlic in very little oil until brownish. Drain from oil once garlic is brownish and set it aside. Beef brisket should be cook exactly 1 hr and 45 mins. So you can start adding carrots and potatoes after 1 hour and 30 minutes. Leave at least 2 cups beef broth on your pot and discard excess broth. (if you want a thick sauce for your caldereta, don’t leave too much broth.) Add in Tomato Sauce, chili peppers, carrots and potatoes. Simmer for 5 minutes while stirring occasionally. Add in garlic and liver spread and Nestle All Purpose cream. Stirring constantly. Adjust taste by adding soy sauce, sugar, fish sauce and pinch of salt. Finally, add in bell pepper and 1 cup grated cheese. Cover pot and simmer 1 or 2 mins more. Turn off heat. Ready to serve. Enjoy!', '/static/assets/img/Recipes/recipe5.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `ingredients`
--

CREATE TABLE `ingredients` (
  `id` int(11) NOT NULL,
  `ingredient_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ingredients`
--

INSERT INTO `ingredients` (`id`, `ingredient_name`) VALUES
(1, 'all purpose cream'),
(2, 'annatto powder'),
(3, 'bay leaf'),
(4, 'beef brisket'),
(5, 'bell pepper'),
(6, 'black pepper'),
(7, 'brown sugar'),
(8, 'calamansi'),
(9, 'calamansi juice'),
(10, 'carrot'),
(11, 'chicken liver'),
(12, 'chili pepper'),
(13, 'fish sauce'),
(14, 'garlic'),
(15, 'grated cheese'),
(16, 'green bell pepper'),
(17, 'green chili'),
(18, 'green peas'),
(19, 'hotdogs'),
(20, 'lemon'),
(21, 'lemon juice'),
(22, 'liver spread'),
(23, 'oregano'),
(24, 'pineapple juice'),
(25, 'pork belly'),
(26, 'pork butt'),
(27, 'pork ear'),
(28, 'pork face'),
(29, 'pork liver'),
(30, 'pork skin'),
(31, 'potato'),
(32, 'raisin'),
(33, 'red bell pepper'),
(34, 'red chili'),
(35, 'red onion'),
(36, 'salt'),
(37, 'soy sauce'),
(38, 'tomato'),
(39, 'tomato paste'),
(40, 'tomato sauce'),
(41, 'white onion');

-- --------------------------------------------------------

--
-- Table structure for table `recipe`
--

CREATE TABLE `recipe` (
  `dish_id` int(11) NOT NULL,
  `ingredient_name` varchar(100) NOT NULL,
  `measurement` varchar(100) DEFAULT NULL,
  `category` enum('main','secondary','common') DEFAULT 'common'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `recipe`
--

INSERT INTO `recipe` (`dish_id`, `ingredient_name`, `measurement`, `category`) VALUES
(1, 'black pepper', 'to taste', 'common'),
(1, 'chicken liver', '3 pieces', 'secondary'),
(1, 'chili pepper', '1-2, minced or ¼ tbsp chili flakes', 'common'),
(1, 'ground black pepper', '⅛ tsp', 'common'),
(1, 'lemon', '½, or 3-4 calamansi juice', 'common'),
(1, 'pork belly', '1 pound, sliced about half-inch thick', 'main'),
(1, 'red onion', '1 big, finely chopped', 'secondary'),
(1, 'salt', 'to taste', 'common'),
(1, 'soy sauce', '½ tbsp', 'secondary'),
(2, 'black pepper', 'to taste', 'common'),
(2, 'calamansi', '10 pcs, juiced', 'common'),
(2, 'chicken liver', '250 g, grilled', 'secondary'),
(2, 'green chili', '1 pc, thinly sliced', 'common'),
(2, 'pork ear', '750 g, includes pork skin and maskara', 'main'),
(2, 'red chili', '2 pcs, thinly sliced', 'common'),
(2, 'salt', 'to taste', 'common'),
(2, 'white onion', '2 pcs, minced', 'secondary'),
(3, 'brown sugar', '3/4 cup', 'secondary'),
(3, 'garlic', '3 cloves, finely minced', 'common'),
(3, 'ground black pepper', '1/2 tbsp', 'common'),
(3, 'pineapple juice', '1/4 cup', 'secondary'),
(3, 'pork butt', '1 kg, cut into 1/4 inch thin slices', 'main'),
(3, 'red food colour', 'optional', 'common'),
(3, 'rice vinegar', '2 tbsp', 'secondary'),
(3, 'salt', '1 & 1/2 tbsp', 'common'),
(3, 'soy sauce', '1 tbsp', 'secondary'),
(4, 'annatto powder', '1 tsp', 'common'),
(4, 'bay leaf', '2 pcs', 'common'),
(4, 'bell pepper', '1 cup, red and green capsicum', 'secondary'),
(4, 'calamansi juice', '1/4 cup, or lemon juice', 'common'),
(4, 'carrot', '1 cup, diced', 'secondary'),
(4, 'fish sauce', '2 tbsp, optional', 'secondary'),
(4, 'green peas', '1/4 cup', 'secondary'),
(4, 'hotdogs', '3 pieces, sliced and simmered', 'secondary'),
(4, 'oregano', '1/4 tsp', 'common'),
(4, 'pork belly', '1 lb, rub with salt and soak in vinegar and salt', 'main'),
(4, 'pork liver', '1 cup, washed and drained', 'secondary'),
(4, 'potato', '1 cup, diced', 'secondary'),
(4, 'raisin', '1/4 cup', 'secondary'),
(4, 'salt', '1 tsp, to taste', 'common'),
(4, 'tomato paste', '1 tbsp', 'secondary'),
(4, 'water', '2 cups, or stock if desired', 'common'),
(5, 'all purpose cream', '1/2 cup, Nestle', 'secondary'),
(5, 'basil leaves', 'optional', 'common'),
(5, 'bay leaf', '1 pc', 'common'),
(5, 'beef brisket', '1 kilo, cut into squares', 'main'),
(5, 'black pepper', 'to taste', 'common'),
(5, 'brown sugar', '2 tbsp, optional', 'common'),
(5, 'carrot', '2 pcs, sliced into bite size', 'secondary'),
(5, 'chili pepper', '1-2, minced', 'common'),
(5, 'fish sauce', '1-4 tbsp, adjust to preference', 'secondary'),
(5, 'garlic', '1 head, chopped', 'common'),
(5, 'grated cheese', '1 cup', 'secondary'),
(5, 'green bell pepper', '2 pcs, cut into squares', 'secondary'),
(5, 'liver spread', '1-2 Pure Foods', 'secondary'),
(5, 'potato', '2 pcs, cut into squares', 'secondary'),
(5, 'salt', 'to taste', 'common'),
(5, 'soy sauce', '4 tbsp', 'secondary'),
(5, 'tomato sauce', '4 pcs, 250ml each', 'secondary'),
(5, 'white onion', '2 pcs, chopped', 'secondary');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dishes`
--
ALTER TABLE `dishes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ingredients`
--
ALTER TABLE `ingredients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `recipe`
--
ALTER TABLE `recipe`
  ADD PRIMARY KEY (`dish_id`,`ingredient_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `dishes`
--
ALTER TABLE `dishes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `ingredients`
--
ALTER TABLE `ingredients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `recipe`
--
ALTER TABLE `recipe`
  ADD CONSTRAINT `recipe_ibfk_1` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
