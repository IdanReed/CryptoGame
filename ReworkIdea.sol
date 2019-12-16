pragma solidity ^0.5.0;
/**
Currently the game has baked in item types & handling methods. This would be a
problem because if a mechanic needs changed the entire game contract would need
to be redeployed.

If items were made more generic with serialized data (for external methods)
and actors pointed to external functions that then called back to game methods
(for base operations) the unique code could be deployed after the main game.
Like with item load for data.

Objects could even override base methods to change or prevent standard actions.
For example silo logic could be external and have objects stored in it. These
stored items would then override movement logic that would break the Silo
mechanic.
*/

contract Rework{
    struct Sector{
        address owner;
        uint lastTickBlock;
        Actor[] actors;
        Object[] objects;
    }

    /**

    */
    struct Object{

        bytes data;
    }

    /**
    Does
    */
    struct Actor{
        uint dummy;

    }
}
