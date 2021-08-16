pub contract Artist {
  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      // The following pixels
      // 123
      // 456
      // 789
      // should be serialized as
      // 123456789
      self.pixels = pixels
    }
  }

  pub fun drawVerticalBorder(_ width: Int) {
    var col = 0
    var hyphens = ""

    while col < width {
        hyphens = hyphens.concat("-")
        col = col + 1
    }

    log("+".concat(hyphens).concat("+"))
  }
  
  pub fun display(canvas: Canvas) {
    var line = 0

    Artist.drawVerticalBorder(Int(canvas.width))
    while line < Int(canvas.height) {
        var from = line * Int(canvas.height)
        var upTo = from + Int(canvas.width)

        log("|".concat(canvas.pixels.slice(from: from, upTo: upTo)).concat("|"))
        line = line + 1
    } 
    Artist.drawVerticalBorder(Int(canvas.width))
  }

  pub resource Picture {

    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Printer {

    pub let width: UInt8
    pub let height: UInt8
    pub let prints: {String: Canvas}

    init(width: UInt8, height: UInt8) {
      self.width = width;
      self.height = height;
      self.prints = {}
    }

    pub fun print(canvas: Canvas): @Picture? {
      // Canvas needs to fit Printer's dimensions.
      if canvas.pixels.length != Int(self.width * self.height) {
        return nil
      }

      // Canvas can only use visible ASCII characters.
      for symbol in canvas.pixels.utf8 {
        if symbol < 32 || symbol > 126 {
          return nil
        }
      }

      // Printer is only allowed to print unique canvases.
      if self.prints.containsKey(canvas.pixels) == false {
        let picture <- create Picture(canvas: canvas)
        self.prints[canvas.pixels] = canvas

        return <- picture
      } else {
        return nil
      }
    }
  }

  pub resource Collection {
    pub let pictures: @[Picture]

    init () {
      self.pictures <- []
    }

    pub fun deposit(picture: @Picture) {
      self.pictures.append(<-picture)
    }

    pub fun getCanvases(): [Canvas] {
      var canvases:[Canvas] = []

      // Can not use for in resource
      var i = 0
      while i < self.pictures.length {
        canvases.append(self.pictures[i].canvas)
        i = i + 1
      }

      return canvases
    }

    destroy () {
      destroy self.pictures
    }
  }

  pub fun createCollection(): @Collection {
      let collection <- create Collection()
      return <- collection
  }

  init() {
    self.account.save(<- create Printer(width: 5, height: 5), to: /storage/ArtistPicturePrinter)
    self.account.link<&Printer>(/public/ArtistPicturePrinter, target: /storage/ArtistPicturePrinter)
  }
}