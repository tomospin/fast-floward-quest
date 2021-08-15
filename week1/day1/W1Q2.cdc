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
    pub let collections: [String]

    init () {
        self.collections = []
    }      

    pub fun print(canvas: Canvas): @Picture? {
        if (!self.collections.contains(canvas.pixels)) {
            let picture <- create Picture(canvas: canvas)
            self.collections.append(canvas.pixels)
            display(canvas: canvas)
            return <- picture
        } else {
            return nil
        }
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

    let printer <- create Printer()
    let picture <- printer.print(canvas: canvasX)
    let picture_duplicate <- printer.print(canvas: canvasX)

    destroy picture
    destroy picture_duplicate
    destroy printer
}
