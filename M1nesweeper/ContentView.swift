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
  
  @State private var grid: Array<Array<Cell>> = Array(repeating: Array(repeating: Cell(bombsAround: 0, cellType: Cell.CellType.empty), count: 2), count: 2)
  @State private var isEditing = false
  @State private var gridLength = 20.0
  @State private var minesCount = 2.0
  @State private var showingAlert = false
  
  var gl: Int {
    return Int(gridLength)
  }
  
  private func createField() {
    print(gl)
    print(self.gridLength)
    var grid: Array<Array<Cell>> = Array(repeating: Array(repeating: Cell(bombsAround: 0, cellType: Cell.CellType.empty), count: gl), count: gl)
    self.initBombs(grid: &grid)
    self.initDigits(grid: &grid)
    self.grid.removeAll()
    for i in grid {
      var a: [Cell] = []
      for j in i {
        a.append(j)
      }
      self.grid.append(a)
    }
  }
  
  var body: some View {
    
    return VStack {
      HStack {
        VStack {
          Text("Grid Size \(Int(gridLength))")
          Slider(
            value: $gridLength,
            in: 4...50,
            step: 1
          )
        }.padding(10)
        
        Spacer()
        VStack {
          Text("Mines count \(Int(minesCount))")
          Slider(
            value: $minesCount,
            in: 1...100,
            step: 1
          )
        }.padding(10)
        
        Spacer()
        Button(action: {
          self.createField()
        }) {
          Text("Start")
        }.padding(10)
      }
      
      Spacer()
   
      ForEach(0 ..< self.grid.count, id: \.self) { row in
        HStack {
          ForEach(0 ..< self.grid.count, id: \.self) { column in
            Button(action: {
              self.grid[row][column].hidden = false
              self.cellTapped(row: row, column: column)
            }) {
              Image(systemName: self.grid[row][column].icon)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(100)
            .font(.system(size: 14))
            .foregroundColor(self.grid[row][column].color)
            .frame(width: 10, height: 10)
            .animation(.default)
          }
        }
      }
      
      Spacer()
    }.alert("You lose", isPresented: $showingAlert) {
      Button("OK", role: .cancel) {
        self.createField()
      }
    }
  }
  
  private func initDigits(grid: inout Array<Array<Cell>>) {
    let validRange = 0..<grid.count
    for i in 0..<self.grid.count {
      for j in 0..<self.grid.count {
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
            grid[i][j].bombsAround = bombsAround
            grid[i][j].cellType = bombsAround == 0 ? Cell.CellType.empty : Cell.CellType.digit
          }
        }
      }
    }
  }
  
  private func initBombs(grid: inout Array<Array<Cell>>) {
    for _ in 0..<Int(minesCount) {
      let randomIndex = Int.random(in: 0..<self.gl*self.gl)
      let row = randomIndex / self.gl
      let column = randomIndex % self.gl
      grid[row][column].cellType = Cell.CellType.bomb
    }
  }
  
  private func cellTapped(row: Int, column: Int) {
    if self.grid[row][column].cellType == Cell.CellType.bomb {
      print("You lose")
      // TODO: Reload
    }
    var q: [(Int, Int)] = []
    q.append((row, column))
    let validRange = 0..<self.grid.count
    while !q.isEmpty {
      let c = q.removeLast()
      self.grid[c.0][c.1].hidden = false
      if self.grid[c.0][c.1].cellType == Cell.CellType.digit {
        continue
      }
      for d in neightbors {
        if validRange.contains(c.0 + d.0) && validRange.contains(c.1 + d.1) {
          if self.grid[c.0 + d.0][c.1 + d.1].hidden {
            q.append((c.0 + d.0, c.1 + d.1))
          }
        }
      }
    }
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
      return "questionmark"
    }
    switch self.cellType {
      case .empty: return "square.dotted"
      case .bomb: return "b.circle.fill"
      case .flagged: return "flag.fill"
      case .digit: return "\(bombsAround).square"
    }
  }
}
