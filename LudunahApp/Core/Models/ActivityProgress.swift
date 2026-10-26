// ActivityProgress.swift - one completed activity, used for weekly progress.
//
// Contains:
// - Struct with: date, interest.
// - Conforms to Codable, Hashable.
//
// Used by: StorageService, WeeklyProgressChart.
//يجمع الاهتمام مع تاريخ الإنجاز

import Foundation

struct ActivityProgress: Codable,Hashable{
    let date:Date
    
    let interest : Interest
    // ينشئ سجل إنجاز جديد
    init(date: Date = Date(), interest: Interest){
        // يخزن التاريخ الذي استقبلناه
        self.date=date
        // يخزن الاهتمام الذي استقبلناه
        self.interest=interest
        
    }
}
