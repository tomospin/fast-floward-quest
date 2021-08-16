import Artist from 0x02

transaction {
    let pixels: String
    let picture: @Artist.Picture?
    let collectionRef: &Artist.Collection

    prepare(account: AuthAccount) {
        let printerRef = getAccount(0x02)
            .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
            .borrow()
            ?? panic("Could not borrow printer reference")
        
        self.pixels = "*   * * *   *   * * *   *"
        let canvas = Artist.Canvas(
            width: printerRef.width,
            height: printerRef.height, 
            pixels: self.pixels
        )

        self.picture <- printerRef.print(canvas: canvas)

        self.collectionRef = account
            .getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
            .borrow()
            ?? panic("Could not borrow collection reference")
    }

    execute {
        if (self.picture == nil) {
            log("Picture already exists..")
            destroy self.picture
        } else {
            log("Picture printed!")
            self.collectionRef.deposit(picture: <-self.picture!)
        }

    }
}