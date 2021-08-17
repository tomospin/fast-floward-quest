import Artist from "./contract.cdc"

// flow scripts execute ./artist/displayCollection.script.cdc --arg Address:0x179b6b1cb6755e31
// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String]? {

    let collectionRef = getAccount(address).getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
                                            .borrow()

    if (collectionRef == nil) {
        return nil
    }

    let canvases = collectionRef!.getCanvases()

    if (canvases.length == 0) {
        // Has a collection but empty
        return []
    } else {
        var formattedPictures: [String] = []
        for canvas in canvases {
            formattedPictures.append(canvas.pixels)
        }
        return formattedPictures
    }
}