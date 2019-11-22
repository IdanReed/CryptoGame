pragma solidity ^0.5.0;

contract TypesItem{

    enum ItemSubType{
        None,
        Silo,
        Extractor,
        Assembler
    }
    enum ItemType{
        NaturalResource,
        Component,
        Placeable
    }

    /**
    This struct contains all data an item MAY have. This is so an array of
    ItemProperties structs can describe all possible items. Then index refs can
    be made to that array.

    Also structs of an optional subtype can be made to store only optional
    members.

    The only things that should be items are things with data determined by
    external productionMap calls.
    */
    struct ItemProperties{
        uint id; /* backup itemId */

        uint mass;
        uint volume;

        ItemType itemType; /* Defines general behavior */

        ItemSubType itemSubType; /* Specify which subtype in optionalProp */
        OptionalItemProperties optionalProperties;
    }

    /**
    Required struct for item subtypes. Contains a reference back to it's item
    index.
    */
    struct ItemSubtype{
        uint itemId; /* backup itemId */
    }
    struct OptionalItemProperties{
        SiloItem silo;
        ExtractorItem extractor;
        AssemblerItem assembler;
    }

    struct PlaceableProperties {
        uint floorSpace;
    }
    struct SiloItem {
        /* contant */
        ItemSubtype itemSubtype;

        PlaceableProperties placeableProps;

        uint targetItemId;
        uint maxQuantity;

        /* volitile */
        uint curQuantity;

    }

    struct ExtractorItem {
        /* contant */
        ItemSubtype itemSubtype;

        PlaceableProperties placeableProperties;

        uint targetTransformationId;
    }

    struct AssemblerItem {
        /* contant */
        ItemSubtype itemSubtype;

        PlaceableProperties placeableProperties;

        uint targetTransformationId;
    }

}