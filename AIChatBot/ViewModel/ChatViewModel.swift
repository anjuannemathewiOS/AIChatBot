//
//  ChatViewModel.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 21/05/2025.
//
//private let openRouterApiKey = "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"


import Foundation
import AVFoundation
import Speech

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isRecording: Bool = false
    private var openRouterApiKey: String {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENROUTER_API_KEY") as? String {
            return apiKey
        } else {
            fatalError("OpenRouter API key missing in Info.plist")
        }
    }
    @Published var isTyping: Bool = false



    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    init() {
        loadMessages()
    }

    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMessage = ChatMessage(text: trimmed, isUser: true, timestamp: Date())
        messages.append(userMessage)
        inputText = ""
        saveMessages()

        fetchBotReply(for: trimmed)
    }

    func fetchBotReply(for prompt: String) {
        isTyping = true // START typing indicator

        guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else {
            isTyping = false
            return
        }

        let payload: [String: Any] = [
            "model": "openai/gpt-3.5-turbo",
            "messages": [["role": "user", "content": prompt]]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openRouterApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            defer {
                DispatchQueue.main.async {
                    self.isTyping = false // END typing indicator
                }
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let content = message["content"] as? String
            else { return }

            DispatchQueue.main.async {
                let reply = ChatMessage(text: content.trimmingCharacters(in: .whitespacesAndNewlines), isUser: false, timestamp: Date())
                self.messages.append(reply)
                self.saveMessages()
            }
        }.resume()
    }


    func requestPermissions(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            if status == .authorized {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    DispatchQueue.main.async { completion(granted) }
                }
            } else {
                DispatchQueue.main.async { completion(false) }
            }
        }
    }

    func startRecording() throws {
        if audioEngine.isRunning { return }

        recognitionTask?.cancel()
        recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }

        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.inputText = result.bestTranscription.formattedString
            }
            if error != nil || result?.isFinal == true {
                self.stopRecording()
                if !self.inputText.isEmpty {
                    self.sendMessage()
                }
            }
        }
    }

    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            isRecording = false
        }
    }

    private func saveMessages() {
        if let data = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(data, forKey: "chatMessages")
        }
    }

    private func loadMessages() {
        if let data = UserDefaults.standard.data(forKey: "chatMessages"),
           let saved = try? JSONDecoder().decode([ChatMessage].self, from: data) {
            messages = saved
        }
    }
}
