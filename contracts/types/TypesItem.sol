pragma solidity ^0.5.0;

contract TypesItem{
    enum ItemType{
        NaturalResource,
        Component,
        Extractor,
        Factory
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

        OptionalItemProperties optionalProperties;
    }
}