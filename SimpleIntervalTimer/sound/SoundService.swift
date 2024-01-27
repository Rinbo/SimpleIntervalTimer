import AVFoundation
import Foundation

class SoundService {
    private var beepPlayer: AVAudioPlayer?
    private var dingPlayer: AVAudioPlayer?
    private var dingDingPlayer: AVAudioPlayer?
    private var clapPlayer: AVAudioPlayer?
    
    init() {
        let clapUrl = Bundle.main.url(forResource: "clap-clap", withExtension: "mp3")
        let beepUrl = Bundle.main.url(forResource: "beep", withExtension: "mp3")
        let dingDingUrl = Bundle.main.url(forResource: "ding-ding-ding", withExtension: "mp3")
        let dingUrl = Bundle.main.url(forResource: "ding", withExtension: "mp3")
        
        do {
            clapPlayer = try AVAudioPlayer(contentsOf: clapUrl!)
            beepPlayer = try AVAudioPlayer(contentsOf: beepUrl!)
            dingDingPlayer = try AVAudioPlayer(contentsOf: dingDingUrl!)
            dingPlayer = try AVAudioPlayer(contentsOf: dingUrl!)
            
            clapPlayer?.prepareToPlay()
            beepPlayer?.prepareToPlay()
            dingDingPlayer?.prepareToPlay()
            dingDingPlayer?.prepareToPlay()
        } catch {
            print("Failed to load player: \(error)")
        }
    }
    
    func playClap() { clapPlayer?.play()}
    func playBeep() { beepPlayer?.play()}
    func playDingDing() { dingDingPlayer?.play()}
    func playDing() { dingPlayer?.play()}
}
