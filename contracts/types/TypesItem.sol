pragma solidity ^0.5.0;

contract TypesItem{

    /**
    This struct specifies the full type of an item. Currently this allows only
    two layers where itemCategory defines behavior and subtypes specific extra
    members to allow for unquie behavior.

    Holds no data outside of enums.
    */
    struct ItemType{
        ItemCategory itemCategory;
        uint itemSubtype;
    }

    enum ItemCategory{
        None,
        NaturalResource,
        Component,
        Placeable,
        Max
    }

    enum ItemSubtypeNaturalResource{
        None,
        Standard,
        Max
    }

    enum ItemSubtypeComponent{
        None,
        Standard,
        Max
    }

    enum ItemSubtypePlaceable{
        None,
        Silo,
        Extractor,
        Assembler,
        Max
    }

    uint[] subtypeBounds = [
        0, /* None */
        uint(ItemSubtypeNaturalResource.Max),
        uint(ItemSubtypeComponent.Max),
        uint(ItemSubtypePlaceable.Max)
    ];

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

        ItemType itemType; /* Only specifies */

        /* optional data */
        ItemSubtypes subtypes; /* Holds data */
    }

    /**
    This struct stores all subtype data
    */
    struct ItemSubtypes{
        PlaceableSubtypes placeable;
    }

    /**
    Required struct for item subtypes. Contains a reference back to it's item
    index. Allows for subtype data to be store seperatly.

    // TODO seperate constant subtype data out from vol then use itemIntf?
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

    struct NaturalResourceItem{
        /* contant */
        ItemSubtypeInterface itemIntf;
        uint difficulty;

        /* volitile */
        uint remainingQuantity;
    }
}