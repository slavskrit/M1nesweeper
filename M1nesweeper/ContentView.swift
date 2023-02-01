//
//  ContentView.swift
//  M1nesweeper
//
//  Created by Dmitry Pronin on 1/31/23.
//

import SwiftUI

struct ContentView: View {
  
  let neightbors = [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1), (0, 0), (0, 1),
    (1, -1), (1, 0), (1, 1)
  ]
  
  let gridLength: Int
  @State private var grid = Array(repeating: Array(repeating: Cell(bombsAround: 0, cellType: Cell.CellType.empty), count: 2), count: 2)
  @State var hovered: (Int, Int) = (-1, -1)
  
  init() {
    self.gridLength = 20
    var grid: Array<Array<Cell>> = Array(repeating: Array(repeating: Cell(bombsAround: 0, cellType: Cell.CellType.empty), count: gridLength), count: gridLength)
    self.initBombs(grid: &grid, mines: 8)
    self.initDigits(grid: &grid)
    
    self._grid = State(initialValue: grid)
  }
  
  var body: some View {
    VStack {
      ForEach(0 ..< self.gridLength) { row in
        HStack {
          ForEach(0 ..< self.gridLength) { column in
            Button(action: {
              self.cellTapped(row: row, column: column)
            }) {
              Image(systemName: self.grid[row][column].icon)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(100)
            .font(.system(size: 14))
            .foregroundColor(self.grid[row][column].color)
            .frame(width: 10, height: 10)
            .scaleEffect(self.hovered == (row, column) ? 2.0 : 1.0)
            .animation(.default)
            .onHover { hover in
              if hover {
                self.hovered = (row, column)
              } else {
                self.hovered = (-1, -1)
              }
            }
          }
        }
      }
    }
  }
  
  private func initDigits(grid: inout Array<Array<Cell>>) {
    let validRange = 0..<gridLength
    for i in 0..<gridLength {
      for j in 0..<gridLength {
        if (grid[i][j].cellType != Cell.CellType.bomb) {
          var bombsAround = 0
          for n in neightbors {
            let ii = i + n.0
            let jj = j + n.1
            if (validRange.contains(ii)
                && validRange.contains(jj)
                && grid[ii][jj].cellType == Cell.CellType.bomb) {
              bombsAround += 1
            }
          }
          grid[i][j].bombsAround = bombsAround
          grid[i][j].cellType = Cell.CellType.digit
        }
      }
    }
  }
  
  private func initBombs(grid: inout Array<Array<Cell>>, mines: Int) {
    for _ in 0..<mines {
      let randomIndex = Int.random(in: 0..<gridLength*gridLength)
      let row = randomIndex / gridLength
      let column = randomIndex % gridLength
      grid[row][column].cellType = Cell.CellType.bomb
    }
  }
  
  private func cellTapped(row: Int, column: Int) {
    print(self.grid[row][column]);
//    self.grid[row][column].isMine.toggle()
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Cell {
  var bombsAround: Int
  var hidden: Bool = true
  var cellType: CellType
  
  enum CellType {
    case empty, bomb, flagged, digit
  }
  
  var color: Color {
    if hidden {
      return .white
    }
    switch self.cellType {
      case .empty: return .white
      case .bomb: return .red
      case .flagged: return .white
      case .digit: return .white
      }
  }
  
  var icon: String {
    if hidden {
      return "square.dotted"
    }
    switch self.cellType {
      case .empty: return "square.dotted"
      case .bomb: return "b.circle.fill"
      case .flagged: return "flag.fill"
      case .digit: return "\(bombsAround).circle"
    }
  }
}
