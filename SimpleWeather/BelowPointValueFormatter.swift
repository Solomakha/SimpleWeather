//
//  BelowPointValueFormatter.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 17.11.2024.
//

import Foundation
import DGCharts

class BelowPointValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        // Возвращаем значение с добавлением символа "°"
        return "\(Int(value))°"
    }
    
    func offsetForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> CGPoint {
        // Смещение текста вниз под точку
        return CGPoint(x: 0, y: 10)
    }
}
