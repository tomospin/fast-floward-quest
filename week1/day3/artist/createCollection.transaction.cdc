import Artist from "./contract.cdc"

// flow transactions send ./artist/createCollection.transaction.cdc --signer emulator-artist
// Create a Picture Collection for the transaction authorizer.
transaction {
    prepare(account: AuthAccount) {
        account.save(<- Artist.createCollection(), to: /storage/ArtistPictureCollection)
        account.link<&Artist.Collection>(/public/ArtistPictureCollection, target: /storage/ArtistPictureCollection)
    }
}