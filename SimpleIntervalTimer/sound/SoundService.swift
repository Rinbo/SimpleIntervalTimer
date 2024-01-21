import AVFoundation
import Foundation

class SoundService {
    static let shared: SoundService = SoundService()
    private var audioPlayer: AVAudioPlayer?
    
    private init() { }
    
    func playSound(_ named: String) {
        guard let url = Bundle.main.url(forResource: named, withExtension: "mp3") else {
            print("url for \(named) not found")
            return
        }
        
        
        if let player = audioPlayer, player.url == url {
            player.play()
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Failed to load the sound: \(error)")
        }
        
        audioPlayer?.play()
    }
}
