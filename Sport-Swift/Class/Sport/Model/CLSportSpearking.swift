//
//  CLSportSpearking.swift
//  Sport-Swift
//
//  Created by 夜猫子 on 2017/5/18.
//  Copyright © 2017年 夜猫子. All rights reserved.
//

import UIKit
import AVFoundation

class CLSportSpearking: NSObject {
    
    /// 整点距离
    var distanceUnit:NSInteger?
    
    //播报运动类型
    fileprivate var sportType:CLSportType = CLSportType.CLSportRun
    
    //播报运动类型字符串
    fileprivate var sportTypeStr:String?
    
    /// 已经播报的总单位距离
    fileprivate var totalDistanceUnit:NSInteger = 0
    
    /// 语音合成器
    fileprivate var synthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    /// 设置单例
    static let sharedSportSpeaking:CLSportSpearking = CLSportSpearking()
    
    /// 自定义构造方法
    ///
    /// - Parameters:
    ///   - distanceUnit: 整点播放距离
    ///   - sportType: 运动类型
    func initWithDistanceUnit(distanceUnit:NSInteger,sportType:CLSportType) {
        
        self.distanceUnit = distanceUnit
        self.sportType = sportType
        
    }
    
    
    
    
}


// MARK: - 数据处理
extension CLSportSpearking {
    
    /// 运动开始播报
    func sportStart() {
        
        var typeStr:String = ""
        switch sportType {
        case CLSportType.CLSportRun:
            typeStr = "跑步"
            break
        case CLSportType.CLSportWalk:
            typeStr = "走路"
            break
        case CLSportType.CLSportBike:
            typeStr = "骑行"
            break
            
        }
        self.sportTypeStr = typeStr
        //开始播报
        playVoiceWithtext(text: "开始\(typeStr)")
    }
    
    /// 运动状态改变播报
    ///
    /// - Parameter state: 运动状态
    func sportStateChange(state:CLSprotState) {
        var stateStr:String?
        switch state {
        case .CLSprotStateContuter:
            stateStr = "运动以继续"
        case .CLSprotStatePause:
            stateStr = "运动已暂停"
        case .CLSprotStateFinish:
            stateStr = "运动已停止，休息一刻"
        }
        //播报
        playVoiceWithtext(text: stateStr!)
    }
    
    /// 运动整点距离播报
    ///
    /// - Parameters:
    ///   - distance: 运动距离
    ///   - time: 运动时间
    ///   - avgSpeed: 运动速度
    func reportDistance(distance:Float,time:Float,avgSpeed:Float) {
        
        if (NSInteger(distance) > (totalDistanceUnit + distanceUnit!)) {
            totalDistanceUnit += distanceUnit!
            let Str = String(format: "您已经%@ %ld公里  用时%@ 平均速度%0.2f公里/小时", sportTypeStr!,distance,getTimeStrWithTime(time: time),avgSpeed)
            //播报
            playVoiceWithtext(text: Str)
        }
        
    }
    
    /// 将时间转换为播报的文字
    ///
    /// - Parameter time: 数字时间值
    /// - Returns: 时间字符串
    fileprivate func getTimeStrWithTime(time:Float) -> String {
        let hour: Int = (Int(time) / 3600)
        let mintute: Int = Int(time) / 60
        let second: Int = Int(time .truncatingRemainder(dividingBy: 60))
        //小时
        var hourStr:String?
        //分钟
        var minuteStr:String?
        //秒
        var secondStr:String?
        if hour > 0 {
            hourStr = String(format: "%zd小时", hour)
        }else {
            hourStr = ""
        }
        if mintute == 0 && hour == 0 {
            minuteStr = ""
        }else {
            minuteStr = String(format: "%zd分", mintute)
        }
        if second == 0 {
            secondStr = ""
        }else {
            secondStr = String(format: "%zd秒", second)
        }
        return String(format: "%@ %@ %@", hourStr!,minuteStr!,secondStr!)
        
    }
 
}

extension CLSportSpearking {
    
    /// 将文本转化为声音，TTS（text to speech）功能
    ///
    /// - Parameter text: 播报的文字
    fileprivate func playVoiceWithtext(text:String) {
        if synthesizer.isSpeaking == true {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let uttenrance = AVSpeechUtterance(string: text)
        let voice = AVSpeechSynthesisVoice(language: "Zh-Hans")
        uttenrance.voice = voice
        synthesizer.speak(uttenrance)
    }
    
}


