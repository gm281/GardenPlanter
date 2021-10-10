import Foundation

var greeting = "Hello, playground"



let circleLenghts: [Double] = [50,50,50,50,50,50,50,50,100,280,450,550,650,750,850,866.25,882.5,898.75,915,931.25,947.5,963.75,980,996.25,1012.5,1028.75,1045,1061.25,1077.5,1093.75,1110,1126.25,1142.5,1158.75,1175,1191.25,1207.5,1223.75,1240,1256.25,1272.5,1288.75,1305,1321.25,1337.5,1353.75,1370,1386.25,1402.5,1418.75,1435,1451.25,1467.5,1483.75,1500,280,100,50,50,50,50,50,50,50,50]
let backLengths: [Double] = [850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850,850]
let frontLengths: [Double] = [400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400,400]
let anchorLength: Double = 400

print(circleLenghts.count)
print(backLengths.count)
print(frontLengths.count)


extension Array /* where Element: Comparable */ {
    mutating func stableSort(by: (Element, Element) -> Bool) {
        // O(n^2) time, and O(n) space algorithm, ... but simple implementation :)
        var newArray = [Element]()
        while self.count > 0 {
            var minIndex = 0
            for (innerIndex, element) in self.enumerated() {
                if by(element, self[minIndex]) {
                    minIndex = innerIndex
                }
            }
            newArray.append(self.remove(at: minIndex))
        }
        self = newArray
    }
}

struct Slipper: CustomStringConvertible {
    static let slipperLength = Double(2400)
    static let cutBuffer = Double(50)
    let slipperPieces: [SlipperPiece]
    
    private static func bufferedLength(pieces: [SlipperPiece]) -> Double {
        precondition(pieces.count != 0)
        return pieces.reduce(-cutBuffer) { length, piece in
            length + piece.length + cutBuffer
        }
    }
    
    static func doFit(pieces: [SlipperPiece]) -> Bool {
        return bufferedLength(pieces: pieces) < slipperLength
    }
    static func remainingLength(pieces: [SlipperPiece]) -> Double {
        return slipperLength - bufferedLength(pieces: pieces)
    }
    
    var description: String {
        // Find the end pieces
        var endPieces = slipperPieces.filter { $0.endPiece }
        var nonEndPieces = slipperPieces.filter { !$0.endPiece }
        
        endPieces.stableSort { piece1, piece2 in
            piece1.index < piece2.index
        }
        endPieces.stableSort { piece1, piece2 in
            piece1.wall.compare(piece2.wall) == ComparisonResult.orderedAscending
        }
        
        nonEndPieces.stableSort { piece1, piece2 in
            piece1.index < piece2.index
        }
        nonEndPieces.stableSort { piece1, piece2 in
            piece1.wall.compare(piece2.wall) == ComparisonResult.orderedAscending
        }

        var sortedSlipperPieces = [SlipperPiece]()
        if endPieces.count > 0 {
            sortedSlipperPieces.append(endPieces.remove(at: 0))
        }
        sortedSlipperPieces = sortedSlipperPieces + nonEndPieces + endPieces
        
        let slipperDescription = sortedSlipperPieces.enumerated().reduce("") { description, indexPiece in
            let (index, piece) = indexPiece
            return description + "\(piece)" + (index == slipperPieces.count-1 ? "" : ", ")
        }

        
        return "[Slipper: \(slipperDescription) \(Slipper.remainingLength(pieces: slipperPieces))]"
    }
}

struct SlipperPiece: CustomStringConvertible {
    let aboveGroundLength: Double
    let length: Double
    let endPiece: Bool
    let wall: String
    let index: Int
    
    var description: String {
        return "[\(wall.prefix(1))\(index)" + (self.endPiece ? " END" : "") + ": \(length)mm]"
    }
}


func slipperPieces(lengths: [Double], endPiece: Bool, wall: String, anchorLength: Double, isAnchor: (Int, Double) -> Bool) -> [SlipperPiece] {
    return lengths.enumerated().map { (index: Int, length: Double) in
        let anchor = isAnchor(index, length)
        return SlipperPiece(aboveGroundLength: length,
                            length: anchor ? length + anchorLength : length,
                            endPiece: endPiece,
                            wall: wall,
                            index: index+1)
    }
}


// Figure out which circleLengths from the back wall should be made into archors
func findCircleAnchors(lengths: [Double]) -> Set<Int> {
    // Find first piece longer than 400, i.e. last lower bench anchor
    let firstIndex: Int = {
        for (index, length) in lengths.enumerated() {
            if length > 400 {
                return index
            }
        }
        
        fatalError()
    }()
    
    
    let lastIndex: Int = {
        for (index, _) in lengths.enumerated() {
            if index > 0 && lengths[index-1] > lengths[index] {
                return index-1;
            }
        }
        fatalError()
    }()
    
    // We want 6 anchors, including 2 extreme indicies found above
    let numberOfAnchors = 6
    let spacing = (lastIndex - firstIndex + numberOfAnchors/2) / (numberOfAnchors - 1)
    var anchors = Set<Int>()
    anchors.insert(firstIndex)
    anchors.insert(lastIndex)
    for i in 1..<numberOfAnchors-1 {
        anchors.insert(firstIndex + spacing * i)
    }
    
    return anchors
}

let circleAnchors = findCircleAnchors(lengths: circleLenghts)
let circleSlipperPieces = slipperPieces(lengths: circleLenghts, endPiece: true, wall: "X Circle", anchorLength: anchorLength) { (index: Int, length: Double) in
    if length < 400 {
        return true
    }
    
    if circleAnchors.contains(index) {
        return true
    }
    
    return false
}

let frontBenchSlipperPieces = slipperPieces(lengths: frontLengths, endPiece: false, wall: "Y Front Bench", anchorLength: anchorLength) { (index: Int, length: Double) in
    if index == 0 || index == frontLengths.count-1 {
        return false
    }
    
    let numberOfAnchors = 3
    let spacing = Double(frontLengths.count) / Double(numberOfAnchors + 1)
    if Int(Double(index) / spacing) != Int(Double(index+1) / spacing) {
        return true
    }
    
    return false
}

let backBenchSlipperPieces = slipperPieces(lengths: backLengths, endPiece: true, wall: "Z Back Bench", anchorLength: anchorLength) { (index: Int, length: Double) in
    if index == 0 || index == backLengths.count-1 {
        return false
    }
    
    let numberOfAnchors = 3
    let spacing = Double(backLengths.count) / Double(numberOfAnchors + 1)
    if Int(Double(index) / spacing) != Int(Double(index+1) / spacing) {
        return true
    }
    
    return false
}

let allSlipperPieces = circleSlipperPieces + frontBenchSlipperPieces + backBenchSlipperPieces


// All sliper pieces created

var endPieces = allSlipperPieces.filter { piece in
    piece.endPiece
}.sorted { piece1, piece2 in
    piece1.length < piece2.length
}
print("# of end pieces: \(endPieces.count)")
var nonEndPieces = allSlipperPieces.filter { piece in
    !piece.endPiece
}.sorted { piece1, piece2 in
    piece1.length < piece2.length
}
print(endPieces)


// Match endPieces to leave less than some fraction of the smallest nonEndPiece
func isBetter<T, R: Comparable>(bestMeta: inout T?, bestValue: inout R?, currentMeta: T, currentValue: R) {
    if let bestValueL = bestValue {
        if (bestValueL > currentValue) {
            bestValue = currentValue
            bestMeta = currentMeta
        }
    } else {
        bestValue = currentValue
        bestMeta = currentMeta
    }
}

func isBetter2<T: Comparable>(newValue: T, bestValue: inout T?) {
    if let bestValueL = bestValue {
        if (bestValueL > newValue) {
            bestValue = newValue
        }
    } else {
        bestValue = newValue
    }
}


let maxWastage = nonEndPieces[0].length
func extractOne(pieces: [SlipperPiece]) -> (Int, Int)? {
    var minWastage: Double?
    var indicies: (Int, Int)?
    for (index1, piece1) in pieces.enumerated() {
        for (index2, piece2) in pieces.enumerated() {
            
            let remainingLength = Slipper.remainingLength(pieces: [piece1, piece2])
            if index1 != index2 && Slipper.doFit(pieces: [piece1, piece2]) && remainingLength < maxWastage {
                isBetter(bestMeta: &indicies, bestValue: &minWastage, currentMeta: (index1, index2), currentValue: remainingLength)
            }
        }
    }
    return indicies
}

var slippers = [Slipper]()

while let extracted = extractOne(pieces: endPieces) {
    let (lower, higher) = extracted.0 < extracted.1 ? (extracted.0, extracted.1) : (extracted.1, extracted.0)
    let piece1 = endPieces.remove(at: higher)
    let piece2 = endPieces.remove(at: lower)
    let slipper = Slipper(slipperPieces: [piece1, piece2])
    slippers.append(slipper)
}

// Now try to combine with a single non end piece and leave less than smallestNonEnd
func extractTwo(pieces: [SlipperPiece], nonEndPiece: SlipperPiece, maxWastageL: Double) -> (Int, Int)? {
    var minWastage: Double?
    var indicies: (Int, Int)?
    for (index1, piece1) in pieces.enumerated() {
        for (index2, piece2) in pieces.enumerated() {
            let remainingLength = Slipper.remainingLength(pieces: [piece1, piece2, nonEndPiece])
            if index1 != index2 && Slipper.doFit(pieces: [piece1, piece2, nonEndPiece]) && remainingLength < maxWastageL {
                isBetter(bestMeta: &indicies, bestValue: &minWastage, currentMeta: (index1, index2), currentValue: remainingLength)
            }
        }
    }
    return indicies
}

while let extracted = extractTwo(pieces: endPieces, nonEndPiece: nonEndPieces.last!, maxWastageL: maxWastage) {
    let (lower, higher) = extracted.0 < extracted.1 ? (extracted.0, extracted.1) : (extracted.1, extracted.0)
    let piece1 = endPieces.remove(at: higher)
    let piece2 = endPieces.remove(at: lower)
    let nonEndPiece = nonEndPieces.removeLast()
    let slipper = Slipper(slipperPieces: [piece1, nonEndPiece, piece2])
    slippers.append(slipper)
}

while let extracted = extractTwo(pieces: endPieces, nonEndPiece: nonEndPieces.first!, maxWastageL: maxWastage) {
    let (lower, higher) = extracted.0 < extracted.1 ? (extracted.0, extracted.1) : (extracted.1, extracted.0)
    let piece1 = endPieces.remove(at: higher)
    let piece2 = endPieces.remove(at: lower)
    let nonEndPiece = nonEndPieces.removeFirst()
    let slipper = Slipper(slipperPieces: [piece1, nonEndPiece, piece2])
    slippers.append(slipper)
}

// Now try to combine with two non end piece and leave less than smallestNonEnd
func extractThree(pieces: [SlipperPiece], nonEndPieces: [SlipperPiece]) -> (Int, Int)? {
    var minWastage: Double?
    var indicies: (Int, Int)?

    for (index1, piece1) in pieces.enumerated() {
        for (index2, piece2) in pieces.enumerated() {
            let remainingLength = Slipper.remainingLength(pieces: [piece1, piece2] + nonEndPieces)
            if index1 != index2 && Slipper.doFit(pieces: [piece1, piece2] + nonEndPieces) && remainingLength < maxWastage {
                isBetter(bestMeta: &indicies, bestValue: &minWastage, currentMeta: (index1, index2), currentValue: remainingLength)
            }
        }
    }
    return indicies
}

while nonEndPieces.count >= 2, let extracted = extractThree(pieces: endPieces, nonEndPieces: [nonEndPieces.first!, nonEndPieces.last!]) {
    let (lower, higher) = extracted.0 < extracted.1 ? (extracted.0, extracted.1) : (extracted.1, extracted.0)
    let piece1 = endPieces.remove(at: higher)
    let piece2 = endPieces.remove(at: lower)
    let nonEndPiece1 = nonEndPieces.removeLast()
    let nonEndPiece2 = nonEndPieces.removeFirst()
    let slipper = Slipper(slipperPieces: [piece1, nonEndPiece1, nonEndPiece2, piece2])
    slippers.append(slipper)
}
while nonEndPieces.count >= 2, let extracted = extractThree(pieces: endPieces, nonEndPieces: [nonEndPieces[nonEndPieces.count-2], nonEndPieces[nonEndPieces.count-1]]) {
    let (lower, higher) = extracted.0 < extracted.1 ? (extracted.0, extracted.1) : (extracted.1, extracted.0)
    let piece1 = endPieces.remove(at: higher)
    let piece2 = endPieces.remove(at: lower)
    let nonEndPiece1 = nonEndPieces.remove(at: nonEndPieces.count-1)
    let nonEndPiece2 = nonEndPieces.remove(at: nonEndPieces.count-1)
    let slipper = Slipper(slipperPieces: [piece1, nonEndPiece1, nonEndPiece2, piece2])
    slippers.append(slipper)
}

while nonEndPieces.count >= 3, let extracted = extractThree(pieces: endPieces, nonEndPieces: [nonEndPieces[0], nonEndPieces[1], nonEndPieces[2]]) {
    let (lower, higher) = extracted.0 < extracted.1 ? (extracted.0, extracted.1) : (extracted.1, extracted.0)
    let piece1 = endPieces.remove(at: higher)
    let piece2 = endPieces.remove(at: lower)
    let nonEndPiece1 = nonEndPieces.remove(at: 2)
    let nonEndPiece2 = nonEndPieces.remove(at: 1)
    let nonEndPiece3 = nonEndPieces.remove(at: 0)
    let slipper = Slipper(slipperPieces: [piece1, nonEndPiece1, nonEndPiece2, nonEndPiece3, piece2])
    slippers.append(slipper)
}

// Now try to combine with a single non end piece but don't pay attention to leftovers
while nonEndPieces.count > 0, let extracted = extractTwo(pieces: endPieces, nonEndPiece: nonEndPieces.first!, maxWastageL: Slipper.slipperLength) {
    let (lower, higher) = extracted.0 < extracted.1 ? (extracted.0, extracted.1) : (extracted.1, extracted.0)
    let piece1 = endPieces.remove(at: higher)
    let piece2 = endPieces.remove(at: lower)
    let nonEndPiece = nonEndPieces.removeFirst()
    let slipper = Slipper(slipperPieces: [piece1, nonEndPiece, piece2])
    slippers.append(slipper)
}

precondition(nonEndPieces.count == 0)

// Pair up the end pieces
while endPieces.count >= 2 {
    let slipper = Slipper(slipperPieces: [endPieces.removeLast(), endPieces.removeLast()])
    slippers.append(slipper)
}

if endPieces.count != 0 {
    let slipper = Slipper(slipperPieces: [endPieces.removeLast()])
    slippers.append(slipper)
}

func slipperComparison(slipper1: Slipper, slipper2: Slipper, wallPrefix: String) -> Bool {
    var slipper1MinIndex: Int?
    slipper1MinIndex = slipper1.slipperPieces.filter({ $0.wall.starts(with: wallPrefix)}).reduce(into: slipper1MinIndex) { partialResult, slipperPiece in
        isBetter2(newValue: slipperPiece.index, bestValue: &partialResult)
    }
    var slipper2MinIndex: Int?
    slipper2MinIndex = slipper2.slipperPieces.filter({ $0.wall.starts(with: wallPrefix)}).reduce(into: slipper2MinIndex) { partialResult, slipperPiece in
        isBetter2(newValue: slipperPiece.index, bestValue: &partialResult)
    }
    if slipper1MinIndex == nil && slipper2MinIndex == nil {
        return false
    }
    
    if let slipper1MinIndex = slipper1MinIndex {
        if let slipper2MinIndex = slipper2MinIndex {
            return slipper1MinIndex < slipper2MinIndex
        } else {
            return true
        }
    } else {
        return false
    }
}
slippers.stableSort { slipper1, slipper2 in
    return slipperComparison(slipper1: slipper1, slipper2: slipper2, wallPrefix: "Z")
}

slippers.stableSort { slipper1, slipper2 in
    return slipperComparison(slipper1: slipper1, slipper2: slipper2, wallPrefix: "Y")
}

slippers.stableSort { slipper1, slipper2 in
    return slipperComparison(slipper1: slipper1, slipper2: slipper2, wallPrefix: "X")
}

precondition(endPieces.count == 0)
precondition(nonEndPieces.count == 0)

print("=============")
slippers.forEach { slipper in
    print(slipper)
}
print("=============")




