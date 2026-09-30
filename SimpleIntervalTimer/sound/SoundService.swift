import AVFoundation
import Foundation

class SoundService {
    private var beepPlayer: AVAudioPlayer?
    private var dingPlayer: AVAudioPlayer?
    private var dingDingPlayer: AVAudioPlayer?
    private var clapPlayer: AVAudioPlayer?
    private var pausePlayer: AVAudioPlayer?
    private var silencePlayer: AVAudioPlayer?

    private var keepAliveRequested = false

    init() {
        // .playback ignores the ring/silent switch (like the Clock app's alarms),
        // and .mixWithOthers lets the cues play on top of the user's own music.
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }

        let clapUrl = Bundle.main.url(forResource: "clap-clap", withExtension: "mp3")
        let beepUrl = Bundle.main.url(forResource: "beep", withExtension: "mp3")
        let dingDingUrl = Bundle.main.url(forResource: "ding-ding-ding", withExtension: "mp3")
        let dingUrl = Bundle.main.url(forResource: "ding", withExtension: "mp3")
        let pauseUrl = Bundle.main.url(forResource: "pause", withExtension: "mp3")
        let silenceUrl = Bundle.main.url(forResource: "silence", withExtension: "wav")

        do {
            clapPlayer = try AVAudioPlayer(contentsOf: clapUrl!)
            beepPlayer = try AVAudioPlayer(contentsOf: beepUrl!)
            dingPlayer = try AVAudioPlayer(contentsOf: dingUrl!)
            dingDingPlayer = try AVAudioPlayer(contentsOf: dingDingUrl!)
            pausePlayer = try AVAudioPlayer(contentsOf: pauseUrl!)
            silencePlayer = try AVAudioPlayer(contentsOf: silenceUrl!)

            clapPlayer?.prepareToPlay()
            clapPlayer?.setVolume(1.0, fadeDuration: 0)
            beepPlayer?.prepareToPlay()
            beepPlayer?.setVolume(1.0, fadeDuration: 0)
            dingPlayer?.prepareToPlay()
            dingPlayer?.setVolume(1.0, fadeDuration: 0)
            dingDingPlayer?.prepareToPlay()
            dingDingPlayer?.setVolume(1.0, fadeDuration: 0)
            pausePlayer?.prepareToPlay()
            pausePlayer?.setVolume(1.0, fadeDuration: 0)
            silencePlayer?.numberOfLoops = -1
            silencePlayer?.prepareToPlay()
        } catch {
            print("Failed to load player: \(error)")
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance())
    }

    func playClap() { clapPlayer?.play()}
    func playBeep() { beepPlayer?.play()}
    func playDingDing() { dingDingPlayer?.play()}
    func playDing() { dingPlayer?.play()}
    func playPause() { pausePlayer?.play()}

    // iOS suspends apps in the background unless they are playing audio (UIBackgroundModes: audio).
    // Looping silence while the timer runs keeps it counting and its cues audible when the user
    // switches app or locks the phone.
    func startBackgroundKeepAlive() {
        keepAliveRequested = true
        silencePlayer?.play()
    }

    func stopBackgroundKeepAlive() {
        keepAliveRequested = false
        silencePlayer?.stop()
    }

    // A phone call or Siri stops all our players; resume the keep-alive once the interruption ends.
    @objc private func handleInterruption(notification: Notification) {
        guard let rawType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
              AVAudioSession.InterruptionType(rawValue: rawType) == .ended,
              keepAliveRequested
        else { return }

        try? AVAudioSession.sharedInstance().setActive(true)
        silencePlayer?.play()
    }
}
