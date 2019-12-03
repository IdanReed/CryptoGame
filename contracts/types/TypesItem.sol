pragma solidity ^0.5.0;

contract TypesItem{

    enum ItemType{
        NaturalResource,
        Component,
        Placeable
    }

    enum ItemSubtypePlaceable{
        None,
        Silo,
        Extractor,
        Assembler
    }

    enum ItemSubtypeComponent{
        None,
        Standard
    }

    enum ItemSubtypeNaturalResource{
        None,
        Standard
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

        // ItemType itemType; /* Specify which ItemSubtype_____ */

        /* optional data */

        ItemTypeFull itemType1;

        // ItemSubtypeNaturalResource itemSubtypeNaturalResource;

        // ItemSubtypeComponent itemSubtypeComponent;

        // ItemSubtypePlaceable itemSubtypePlaceable;
        PlaceableSubtypes placeableSubtypes;
    }


    /*
    TODO convert enum members into cast based type to allow for less
    annoying type checking
    */
    struct ItemTypeFull{
        ItemType itemType;

        ItemSubtypeNaturalResource itemSubtypeNaturalResource;
        ItemSubtypeComponent itemSubtypeComponent;
        ItemSubtypePlaceable itemSubtypePlaceable;
    }

    /**
    Required struct for item subtypes. Contains a reference back to it's item
    index.
    */
    struct ItemSubtypeInterface{
        uint itemId; /* backup itemId */
    }

    struct PlaceableSubtypes{
        SiloItem silo;
        ExtractorItem extractor;
        AssemblerItem assembler;
    }

    struct Placeable {
        uint floorSpace;
    }

    struct SiloItem {
        /* contant */
        ItemSubtypeInterface itemIntf;
        Placeable placeable;

        uint targetItemId;
        uint maxQuantity;

        /* volitile */
        uint curQuantity;

    }

    struct ExtractorItem {
        /* contant */
        ItemSubtypeInterface itemIntf;
        Placeable placeable;

        uint targetTransformationId;
    }

    struct AssemblerItem {
        /* contant */
        ItemSubtypeInterface itemIntf;
        Placeable placeable;

        uint targetTransformationId;
    }
}