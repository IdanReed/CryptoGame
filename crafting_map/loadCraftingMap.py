"""
Loads craftingMap.xml an creates a text file with the Game contract calls to
initialize the crafting recipies and items

craftingMap.xml ->
[
    game.addItem(1, 0);
    game.addItem(2, 1);
    game.addRecipe();
    game.addRecipeElement(true, 0, 1);
    .
    .
    .
]

"""