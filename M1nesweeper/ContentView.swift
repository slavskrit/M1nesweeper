//
//  ContentView.swift
//  M1nesweeper
//
//  Created by Dmitry Pronin on 1/31/23.
//

import SwiftUI

struct ContentView: View {
  
  let gridLength: Int
  @State private var grid = Array(repeating: Array(repeating: Cell(bombsAround: 0, isMine: false), count: 8), count: 8)

  init() {
    self.gridLength = 8
    self.grid = Array(repeating: Array(repeating: Cell(bombsAround: 0, isMine: false), count: gridLength), count: gridLength)
    let mines = 8
    for _ in 0..<mines {
      let randomIndex = Int.random(in: 0..<gridLength*gridLength)
      let row = randomIndex / gridLength
      let column = randomIndex % gridLength
      print(row, column);
      self.grid[row][column].isMine.toggle()
    }
  }
  
  var body: some View {
    VStack {
      ForEach(0 ..< 8) { row in
        HStack {
          ForEach(0 ..< 8) { column in
            Button(action: {
              self.cellTapped(row: row, column: column)
            }) {
              Image(systemName: self.grid[row][column].isMine ? "b.circle.fill" : "square")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(100)
            .font(.system(size: 14))
            .foregroundColor(
              self.grid[row][column].isMine ?  .red : .white)
            .frame(width: 10, height: 10)
          }
        }
      }
    }
  }
  
  func cellTapped(row: Int, column: Int) {
    print(self.grid[row][column]);
    self.grid[row][column].isMine.toggle()
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Cell {
  var bombsAround: Int8
  var isMine: Bool
}
