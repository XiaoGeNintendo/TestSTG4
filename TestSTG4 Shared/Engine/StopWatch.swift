//
//  StopWatch.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/4/17.
//

import Foundation

class StopWatch{
    var time = 0.0
    var no = true
    
    init(no: Bool){
        time=NSDate().timeIntervalSince1970
    }
    
    func tap(_ text: String){
        if !no{
            let new=NSDate().timeIntervalSince1970
            print("\(text):\(new-time)s")
            time=new
        }
    }
}
