pub struct Canvas {
    
    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
        self.width = width
        self.height = height
        self.pixels = pixels
    }
}

pub resource Picture {
    pub let canvas: Canvas

    init(canvas: Canvas) {
        self.canvas = canvas
    }
}

pub fun serializeStringArray(_ lines: [String]): String {
    var buffer = ""
    for line in lines {
        buffer = buffer.concat(line)
    }

    return buffer
}

pub fun display(canvas: Canvas) {
    var line = 0

    drawVerticalBorder(Int(canvas.width))
    while line < Int(canvas.height) {
        var from = line * Int(canvas.height)
        var upTo = from + Int(canvas.width)

        log("|".concat(canvas.pixels.slice(from: from, upTo: upTo)).concat("|"))
        line = line + 1
    }
    drawVerticalBorder(Int(canvas.width))
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

pub resource Printer {
    pub let width: Int
    pub let height: Int
    pub let collectedPixels: [String]

    init (width: Int, height: Int) {
        self.width = width
        self.height = height
        self.collectedPixels = []
    }      

    pub fun print(canvas: Canvas): @Picture? {
        if (Int(canvas.width) != self.width || Int(canvas.height) != self.height || self.collectedPixels.contains(canvas.pixels)) {
            return nil
        }

        let picture <- create Picture(canvas: canvas)
        self.collectedPixels.append(picture.canvas.pixels)
        display(canvas: picture.canvas)

        return <- picture
    }
}

pub fun main() {
    let pixelsX = [
        "*   *",
        " * * ",
        "  *  ",
        " * * ",
        "*   *"
    ]

    let canvasX = Canvas(
        width: 5,
        height: 5,
        pixels: serializeStringArray(pixelsX)
    )

    let printer <- create Printer(width: 5, height: 5)
    let picture <- printer.print(canvas: canvasX)

    destroy picture
    destroy printer
}
