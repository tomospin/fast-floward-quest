import Artist from 0x02

pub fun main() {
  let accounts = [getAccount(0x01), getAccount(0x02), getAccount(0x03), getAccount(0x04), getAccount(0x05)]

  for account in accounts {
    let collectionRef = account
        .getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
        .borrow()
    
    if (collectionRef == nil) {
      log("Account:".concat(account.address.toString()).concat("has no collection"))
      continue
    }

    let canvases = collectionRef!.getCanvases()
    if (canvases.length == 0) {
      log("Account:".concat(account.address.toString()).concat("has not collected any picture"))
    } else {
      log("Displaying canvases of account:".concat(account.address.toString()))
      for canvas in canvases {
        Artist.display(canvas: canvas)
      }
    }
    
  }
}