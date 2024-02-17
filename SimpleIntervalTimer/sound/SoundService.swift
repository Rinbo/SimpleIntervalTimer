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
            dingPlayer = try AVAudioPlayer(contentsOf: dingUrl!)
            dingDingPlayer = try AVAudioPlayer(contentsOf: dingDingUrl!)
            
            clapPlayer?.prepareToPlay()
            clapPlayer?.setVolume(0.9, fadeDuration: 0)
            beepPlayer?.prepareToPlay()
            beepPlayer?.setVolume(0.9, fadeDuration: 0)
            dingPlayer?.prepareToPlay()
            dingPlayer?.setVolume(0.9, fadeDuration: 0)
            dingDingPlayer?.prepareToPlay()
            dingDingPlayer?.setVolume(0.9, fadeDuration: 0)
        } catch {
            print("Failed to load player: \(error)")
        }
    }
    
    func playClap() { clapPlayer?.play()}
    func playBeep() { beepPlayer?.play()}
    func playDingDing() { dingDingPlayer?.play()}
    func playDing() { dingPlayer?.play()}
}
