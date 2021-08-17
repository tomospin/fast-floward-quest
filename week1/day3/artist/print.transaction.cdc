import Artist from "./contract.cdc"


// flow transactions send ./artist/print.transaction.cdc --signer emulator-artist --arg UInt8:5 --arg UInt8:5 --arg String:"*   * * *   *   * * *   *"
// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {
    let collectionRef: &Artist.Collection
    let picture: @Artist.Picture?

    prepare(account: AuthAccount) {
        let printerRef = account.getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
                                .borrow() ?? panic("Couldn't borrow printer reference")

        let canvas = Artist.Canvas(width: width, height: height, pixels: pixels)

        self.picture <- printerRef.print(canvas: canvas)

        self.collectionRef = account.getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
                                    .borrow() ?? panic("Couldn't borrow collection reference")
    }
    
    execute {
        if (self.picture != nil) {
            log("Depositing a picture into collection")
            self.collectionRef.deposit(picture: <- self.picture!)
        } else {
            log("Picture already exists")
            destroy self.picture
        }
    }
}