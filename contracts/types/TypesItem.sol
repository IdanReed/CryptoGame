pragma solidity ^0.5.0;

contract TypesItem{
    enum ItemPlaceableType{
        None,
        Silo,
        Extractor,
        Factory
    }
    enum ItemType{
        NaturalResource,
        Component,
        Placeable
    }
    struct ExtractorProperties{
        uint targetRecipe;
    }
    struct OptionalItemProperties{
        ExtractorProperties extractor;
    }
    struct ItemProperties{
        uint backupItemId;

        uint density;

        ItemType itemType;
        ItemPlaceableType placeableType;

        OptionalItemProperties optionalProperties;
    }
}