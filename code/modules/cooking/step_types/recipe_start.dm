//The default starting step.
//Doesn't do anything, just holds the item.

/datum/cooking/recipe_step/start
	class = COOKING_START
	var/required_container

/datum/cooking/recipe_step/start/New(var/container)
	required_container = container


